from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta
from typing import Any
import security
from database import get_db
from services.storage import StorageService, get_storage

router = APIRouter()


@router.post("/login")
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
        },
    }


@router.get("/me")
async def read_users_me(
    current_user=Depends(security.get_current_user),
):
    """Retourne le profil de l'utilisateur authentifié."""
    return {
        "email": current_user.email,
        "full_name": current_user.full_name,
        "role": current_user.role,
        "org": current_user.org_name,
        "blockchain_id": current_user.blockchain_id,
    }


@router.post("/setup-test-user", include_in_schema=False)
async def setup_test_user(
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
):
    """Endpoint dev : crée un utilisateur de test si absent."""
    test_email = "prod@test.com"
    existing = storage.get_user_by_email(db, test_email)
    if existing:
        return {"message": "Test user already exists"}

    storage.create_user(
        db,
        email=test_email,
        password="password123",
        full_name="Producteur de Test",
        role="PRODUCTEUR",
        org_name="producteurs",
        blockchain_id="admin",
    )
    return {"message": "Test user created: prod@test.com / password123"}
