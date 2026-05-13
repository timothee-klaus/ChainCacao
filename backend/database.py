from sqlalchemy import create_engine, Column, Integer, String, DateTime, Boolean, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import datetime
import os
from dotenv import load_dotenv

load_dotenv()

SQLALCHEMY_DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./chaincacao.db")


if SQLALCHEMY_DATABASE_URL.startswith("sqlite"):
    engine = create_engine(
        SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
    )
else:
    engine = create_engine(
        SQLALCHEMY_DATABASE_URL,
        pool_pre_ping=True,
        pool_recycle=3600
    )


SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

class MediaMetadata(Base):
    __tablename__ = "media_metadata"

    id = Column(Integer, primary_key=True, index=True)
    lot_hash = Column(String, index=True)
    filename = Column(String)
    file_path = Column(String)
    sha256_hash = Column(String, unique=True, index=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=True)
    hashed_password = Column(String)
    full_name = Column(String)
    role = Column(String) # PRODUCTEUR, EXPORTATEUR, etc.
    numero_telephone = Column(String, nullable=True) # Ajout du numéro de téléphone
    parent_id = Column(String, nullable=True) # ID de la coopérative parente
    org_name = Column(String) # producteurs, exportateurs, etc.
    blockchain_id = Column(String, unique=True) # ID dans le wallet Fabric
    blockchain_validated = Column(Boolean, default=False) # True si enregistré sur le ledger
    document_legalite_path = Column(String, nullable=True) # Chemin vers le document de preuve
    document_legalite_hash = Column(String, nullable=True) # Hash SHA-256 du document
    is_admin = Column(Boolean, default=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

# Create tables and seed initial data
def init_db():
    Base.metadata.create_all(bind=engine)
    
    # Seeding : Créer le compte Ministère s'il n'existe pas
    from sqlalchemy.orm import Session
    db = SessionLocal()
    try:
        # On vérifie si un compte MINISTERE existe déjà
        ministere = db.query(User).filter(User.role == "MINISTERE").first()
        if not ministere:
            import bcrypt
            print("Initialisation du compte Ministère (Super Admin)...")
            
            # Hachage du mot de passe par défaut
            password = "Ministere2026!"
            hashed_pwd = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt()).decode('utf-8')
            
            admin_user = User(
                email="admin@ministere.tg",
                hashed_password=hashed_pwd,
                full_name="Ministère de l'Agriculture",
                role="MINISTERE",
                org_name="ministere",
                blockchain_id="MINISTERE-ROOT",
                blockchain_validated=True, # Le ministère est validé par défaut
                is_admin=True,
                is_active=True
            )
            db.add(admin_user)
            db.commit()
            print("Compte Ministère créé avec succès : admin@ministere.tg / Ministere2026!")
    except Exception as e:
        print(f"Erreur lors du seeding : {e}")
        db.rollback()
    finally:
        db.close()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
