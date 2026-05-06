import os
import hashlib
import logging
from sqlalchemy.orm import Session
from database import MediaMetadata, User
import security

logger = logging.getLogger("storage_service")


class StorageService:
    """
    Centralise toutes les opérations sur la base de données locale (SQLite / PostgreSQL).
    Les endpoints ne manipulent jamais directement SQLAlchemy — ils passent par ce service.
    """

    UPLOAD_DIR = os.getenv("UPLOAD_DIR", "uploads")

    # ─────────────────────────────────────────────
    # Médias
    # ─────────────────────────────────────────────

    def save_media(self, db: Session, lot_hash: str, filename: str, content: bytes) -> dict:
        """
        Sauvegarde un fichier sur le disque et ses métadonnées en base.
        Retourne le hash SHA-256 et le chemin du fichier.
        """
        sha256_hash = hashlib.sha256(content).hexdigest()
        file_ext = os.path.splitext(filename)[1]
        stored_filename = f"{sha256_hash}{file_ext}"
        file_path = os.path.join(self.UPLOAD_DIR, stored_filename)

        os.makedirs(self.UPLOAD_DIR, exist_ok=True)

        # Écriture idempotente : on ne réécrit pas si le fichier existe déjà
        if not os.path.exists(file_path):
            with open(file_path, "wb") as buffer:
                buffer.write(content)

        try:
            existing = db.query(MediaMetadata).filter(
                MediaMetadata.sha256_hash == sha256_hash
            ).first()

            if not existing:
                db_media = MediaMetadata(
                    lot_hash=lot_hash,
                    filename=filename,
                    file_path=file_path,
                    sha256_hash=sha256_hash,
                )
                db.add(db_media)
                db.commit()
                logger.info(f"Média enregistré : {sha256_hash} pour lot {lot_hash}")
        except Exception as e:
            db.rollback()
            logger.error(f"Erreur BDD lors de la sauvegarde du média : {e}")

        return {"sha256_hash": sha256_hash, "file_path": file_path}

    def get_media_by_hash(self, db: Session, sha256_hash: str) -> MediaMetadata | None:
        """Retourne les métadonnées d'un fichier à partir de son hash SHA-256."""
        return db.query(MediaMetadata).filter(
            MediaMetadata.sha256_hash == sha256_hash
        ).first()

    def get_media_by_lot(self, db: Session, lot_hash: str) -> list[MediaMetadata]:
        """Retourne tous les médias associés à un lot."""
        return db.query(MediaMetadata).filter(
            MediaMetadata.lot_hash == lot_hash
        ).all()

    # ─────────────────────────────────────────────
    # Utilisateurs
    # ─────────────────────────────────────────────

    def get_user_by_email(self, db: Session, email: str) -> User | None:
        """Recherche un utilisateur par son email."""
        return db.query(User).filter(User.email == email).first()

    def get_user_by_phone(self, db: Session, phone: str) -> User | None:
        """Recherche un utilisateur par son numéro de téléphone."""
        return db.query(User).filter(User.numero_telephone == phone).first()

    def get_user_by_blockchain_id(self, db: Session, blockchain_id: str) -> User | None:
        """Retourne un utilisateur par son identifiant blockchain."""
        return db.query(User).filter(User.blockchain_id == blockchain_id).first()

    def authenticate_user(self, db: Session, identifier: str, password: str) -> User | None:
        """Vérifie les identifiants (email ou téléphone) et retourne l'utilisateur."""
        # Tente par email
        user = self.get_user_by_email(db, identifier)
        # Si non trouvé, tente par téléphone
        if not user:
            user = self.get_user_by_phone(db, identifier)
            
        if not user:
            return None
        if not security.verify_password(password, user.hashed_password):
            return None
        return user

    def create_user(
        self,
        db: Session,
        email: str | None,
        password: str,
        full_name: str,
        role: str,
        org_name: str,
        blockchain_id: str,
        numero_telephone: str | None = None,
        parent_id: str | None = None,
        is_admin: bool = False,
        blockchain_validated: bool = False,
        document_legalite_path: str | None = None,
        document_legalite_hash: str | None = None,
    ) -> User:
        """Crée et persiste un nouvel utilisateur."""
        new_user = User(
            email=email,
            hashed_password=security.get_password_hash(password),
            full_name=full_name,
            role=role,
            numero_telephone=numero_telephone,
            parent_id=parent_id,
            org_name=org_name,
            blockchain_id=blockchain_id,
            is_admin=is_admin,
            blockchain_validated=blockchain_validated,
            document_legalite_path=document_legalite_path,
            document_legalite_hash=document_legalite_hash,
        )
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
        logger.info(f"Utilisateur créé : {email} ({role} / {org_name})")
        return new_user

    def update_user_parent(self, db: Session, blockchain_id: str, parent_id: str) -> bool:
        """Met à jour la coopérative parente d'un producteur."""
        user = self.get_user_by_blockchain_id(db, blockchain_id)
        if user:
            user.parent_id = parent_id
            db.commit()
            return True
        return False

    def get_users(self, db: Session, role: str | None = None, parent_id: str | None = None) -> list[User]:
        """Retourne tous les utilisateurs, éventuellement filtrés par rôle ou parent."""
        query = db.query(User)
        if role:
            query = query.filter(User.role == role)
        if parent_id:
            query = query.filter(User.parent_id == parent_id)
        return query.all()

    def set_user_blockchain_validated(self, db: Session, blockchain_id: str, status: bool = True) -> bool:
        """Marque un utilisateur comme validé sur la blockchain."""
        user = self.get_user_by_blockchain_id(db, blockchain_id)
        if user:
            user.blockchain_validated = status
            db.commit()
            return True
        return False

    def log_action(self, db: Session, user_id: str, action: str) -> None:
        """
        Point d'extension pour journaliser les actions des utilisateurs.
        Peut être étendu vers une table `audit_logs`.
        """
        logger.info(f"[AUDIT] user={user_id} action={action}")


# ─────────────────────────────────────────────
# Singleton injectable via FastAPI Depends
# ─────────────────────────────────────────────

_storage_service = StorageService()


def get_storage() -> StorageService:
    """Dependency injector — à utiliser avec Depends(get_storage)."""
    return _storage_service
