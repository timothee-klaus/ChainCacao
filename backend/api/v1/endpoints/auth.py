import logging
import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta
from typing import Any, List, Optional

import security
from database import get_db, User
from models.schemas import UserRegister, UserPublicResponse, ProducerRegisterDelegated, AgentRegister
from services.storage import StorageService, get_storage
from services.blockchain_gateway import BlockchainGateway

logger = logging.getLogger("auth")
router = APIRouter()
gateway = BlockchainGateway()


# ──────────────────────────────────────────────────────────────
# POST /register
# ──────────────────────────────────────────────────────────────

@router.post(
    "/register",
    response_model=UserPublicResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Créer un compte utilisateur",
)
async def register(
    payload: UserRegister,
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
) -> Any:
    """
    Inscrit un nouvel utilisateur (Stockage local avant validation blockchain).
    L'email est optionnel pour les producteurs si le téléphone est fourni.
    """
    # 1. Vérification qu'au moins l'email ou le téléphone est présent
    if not payload.email and not payload.numero_telephone:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Un email ou un numéro de téléphone est requis pour l'inscription."
        )

    # 2. Vérification si l'utilisateur existe déjà
    if payload.email and storage.get_user_by_email(db, payload.email):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Cet email est déjà utilisé."
        )
    
    if payload.numero_telephone and storage.get_user_by_phone(db, payload.numero_telephone):
         raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Ce numéro de téléphone est déjà utilisé."
        )

    # ── 3. Détermination de l'organisation Fabric associée ────────
    short_uuid = uuid.uuid4().hex[:8]
    blockchain_id = f"{payload.role}-{short_uuid}"
    org_name = payload.org_name 

    logger.info(f"Nouvelle inscription locale : {payload.email or payload.numero_telephone} → {blockchain_id}")

    # ── 4. Persistance SQLite ─────────────────────────────────
    user = storage.create_user(
        db,
        email=payload.email,
        password=payload.password,
        full_name=payload.full_name,
        role=payload.role,
        org_name=org_name,
        blockchain_id=blockchain_id,
        numero_telephone=payload.numero_telephone,
        parent_id=payload.cooperative_id,
        is_admin=payload.is_admin,
        blockchain_validated=False,
    )

    storage.log_action(
        db,
        user_id=blockchain_id,
        action="REGISTER_PENDING_VALIDATION",
    )

    # ── 5. Réponse publique ───────────────────────────────────
    return UserPublicResponse(
        email=user.email,
        full_name=user.full_name,
        numero_telephone=user.numero_telephone,
        role=user.role,
        org_name=user.org_name,
        blockchain_id=user.blockchain_id,
        blockchain_validated=user.blockchain_validated,
    )


# ──────────────────────────────────────────────────────────────
# POST /login
# ──────────────────────────────────────────────────────────────

@router.post("/login", summary="Se connecter et obtenir un JWT")
async def login(
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    form_data: OAuth2PasswordRequestForm = Depends(),
) -> Any:
    """Authentifie un utilisateur et retourne un JWT Bearer Token."""
    user = storage.authenticate_user(db, identifier=form_data.username, password=form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email/Téléphone ou mot de passe incorrect",
            headers={"WWW-Authenticate": "Bearer"},
        )

    access_token = security.create_access_token(
        data={"sub": user.email},
        expires_delta=timedelta(minutes=security.ACCESS_TOKEN_EXPIRE_MINUTES),
    )

    storage.log_action(db, user_id=user.blockchain_id, action="LOGIN")

    return {
        "access_token": access_token,
        "token_type": "bearer",
        "user": {
            "full_name": user.full_name,
            "role": user.role,
            "org": user.org_name,
            "blockchain_id": user.blockchain_id,
        },
    }


# ──────────────────────────────────────────────────────────────
# GET /me
# ──────────────────────────────────────────────────────────────

@router.get("/me", response_model=UserPublicResponse, summary="Mon profil")
async def read_users_me(
    current_user=Depends(security.get_current_user),
):
    """Retourne le profil de l'utilisateur authentifié."""
    return UserPublicResponse(
        email=current_user.email,
        full_name=current_user.full_name,
        numero_telephone=current_user.numero_telephone,
        role=current_user.role,
        org_name=current_user.org_name,
        blockchain_id=current_user.blockchain_id,
        blockchain_validated=current_user.blockchain_validated,
    )


# ──────────────────────────────────────────────────────────────
# POST /setup-test-user  (dev only — masqué du Swagger)
# ──────────────────────────────────────────────────────────────

@router.post("/setup-test-user", include_in_schema=False)
async def setup_test_user(
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
):
    """Endpoint dev : crée un utilisateur de test si absent."""
    test_email = "prod@test.com"
    existing = storage.get_user_by_email(db, test_email)
    if existing:
        return {
            "message": "Test user already exists",
            "blockchain_id": existing.blockchain_id,
        }

    user = storage.create_user(
        db,
        email=test_email,
        password="password123",
        full_name="Producteur de Test",
        role="PRODUCTEUR",
        numero_telephone="0123456789",
        org_name="producteurs",
        blockchain_id="admin",
    )
    return {
        "message": "Test user created: prod@test.com / password123",
        "blockchain_id": user.blockchain_id,
    }

@router.get("/users", response_model=List[UserPublicResponse], summary="Lister les utilisateurs")
async def list_users(
    role: Optional[str] = None,
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_current_user)
) -> Any:
    """
    Liste les utilisateurs inscrits. 
    - Le Ministère peut tout voir.
    - Une Coopérative peut voir les comptes à valider.
    """
    if current_user.role not in ["MINISTERE", "COOPERATIVE"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Accès réservé au Ministère et aux Coopératives."
        )
    
    # Sécurité : un administrateur ne voit que "ses" membres (agents ou producteurs)
    parent_id_filter = None
    if current_user.is_admin and current_user.role != "MINISTERE":
        parent_id_filter = current_user.blockchain_id
        # Si aucun rôle n'est spécifié, on montre tout ce qui est lié à cette organisation
        if not role:
            role = None 

    users = storage.get_users(db, role=role, parent_id=parent_id_filter)
    return users

@router.post("/register-producer", response_model=UserPublicResponse, summary="Inscrire un producteur (Délégué)")
async def register_producer_delegated(
    payload: ProducerRegisterDelegated,
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_current_user)
) -> Any:
    """
    Permet à une coopérative d'inscrire directement un producteur.
    - Le mot de passe par défaut est le numéro de téléphone.
    - Le lien de parenté est automatiquement établi.
    """
    if current_user.role != "COOPERATIVE":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seules les coopératives peuvent enrôler des producteurs."
        )

    # 1. Vérification si le téléphone existe déjà
    if storage.get_user_by_phone(db, payload.numero_telephone):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Ce numéro de téléphone est déjà enregistré."
        )

    # 2. Préparation des données (Déléguées)
    short_uuid = uuid.uuid4().hex[:8]
    blockchain_id = f"PRODUCTEUR-{short_uuid}"
    
    # 3. Création locale
    user = storage.create_user(
        db=db,
        email=None,
        password=payload.numero_telephone, # Mot de passe par défaut = téléphone
        full_name=payload.full_name,
        role="PRODUCTEUR",
        org_name="producteurs",
        blockchain_id=blockchain_id,
        numero_telephone=payload.numero_telephone,
        parent_id=current_user.blockchain_id,
        is_admin=False,
        blockchain_validated=False,
    )
    
    return user

@router.post("/register-agent", response_model=UserPublicResponse, summary="Inscrire un agent (Générique)")
async def register_agent(
    payload: AgentRegister,
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_current_user)
) -> Any:
    """
    Permet à l'administrateur d'une organisation (Coop, Export, Transfo, Ministère) d'inscrire ses agents.
    Les agents héritent du rôle, de l'organisation et du parent_id de l'administrateur.
    """
    if not current_user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seul un compte administrateur peut inscrire des agents."
        )

    if current_user.role == "PRODUCTEUR":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Les producteurs ne peuvent pas avoir d'agents délégués."
        )

    # 1. Vérification email ou téléphone
    if not payload.email and not payload.numero_telephone:
        raise HTTPException(status_code=400, detail="Email ou Téléphone requis.")

    if payload.email and storage.get_user_by_email(db, payload.email):
        raise HTTPException(status_code=400, detail="Email déjà utilisé.")

    # 2. Création de l'agent
    short_uuid = uuid.uuid4().hex[:4]
    # Format de l'ID blockchain pour l'agent
    blockchain_id = f"AGENT-{current_user.role}-{short_uuid}"

    user = storage.create_user(
        db=db,
        email=payload.email,
        password=payload.password,
        full_name=payload.full_name,
        role=current_user.role, # Héritage du rôle
        org_name=current_user.org_name, # Héritage de l'organisation
        blockchain_id=blockchain_id,
        numero_telephone=payload.numero_telephone,
        parent_id=current_user.blockchain_id,
        is_admin=False, # L'agent n'est pas admin par défaut
        blockchain_validated=False,
    )
    
    return user
