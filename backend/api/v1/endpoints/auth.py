import logging
import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta
from typing import Any

import security
from database import get_db
from models.schemas import UserRegister, UserPublicResponse
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
    Inscrit un nouvel utilisateur :

    1. Vérifie que l'email n'est pas déjà pris.
    2. Génère un `blockchain_id` unique (`<role>-<uuid8>`).
    3. Tente l'enregistrement auprès de la CA Fabric via le gateway Node.js.
       → En cas d'échec (réseau indisponible), l'inscription locale se fait quand même
         et une alerte est loguée (`blockchain_enrolled: false`).
    4. Persiste l'utilisateur en base SQLite.
    5. Retourne le profil public (sans mot de passe).
    """
    # ── 1. Unicité de l'email ──────────────────────────────────
    if storage.get_user_by_email(db, payload.email):
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Un compte existe déjà avec cet email.",
        )

    # ── 2. Génération du blockchain_id ────────────────────────
    #   Format : PRODUCTEUR-3f7a1b9c  (lisible + unique)
    short_uuid = uuid.uuid4().hex[:8]
    blockchain_id = f"{payload.role}-{short_uuid}"
    org_name = payload.org_name   # dérivé du rôle via la property Pydantic

    logger.info(f"Nouvelle inscription : {payload.email} → {blockchain_id} @ {org_name}")

    # ── 3. Enregistrement CA Fabric ───────────────────────────
    blockchain_enrolled = False
    fabric_role = payload.role.lower()   # ex: "producteur"

    try:
        bc_result = await gateway.register_user(
            user_id=blockchain_id,
            org_name=org_name,
            role=fabric_role,
        )
        if bc_result.get("success"):
            blockchain_enrolled = True
            logger.info(f"Fabric CA : {blockchain_id} enregistré avec succès dans {org_name}")
        else:
            logger.warning(
                f"Fabric CA : échec pour {blockchain_id} — {bc_result.get('error')}. "
                "L'utilisateur est créé localement."
            )
    except Exception as exc:
        logger.warning(
            f"Fabric CA injoignable ({exc}). "
            f"{blockchain_id} créé localement uniquement."
        )

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
        is_admin=payload.is_admin,
    )

    storage.log_action(
        db,
        user_id=blockchain_id,
        action=f"REGISTER:blockchain_enrolled={blockchain_enrolled}",
    )

    # ── 5. Réponse publique ───────────────────────────────────
    return UserPublicResponse(
        email=user.email,
        full_name=user.full_name,
        numero_telephone=user.numero_telephone,
        role=user.role,
        org_name=user.org_name,
        blockchain_id=user.blockchain_id,
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
    user = storage.authenticate_user(db, email=form_data.username, password=form_data.password)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Email ou mot de passe incorrect",
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
