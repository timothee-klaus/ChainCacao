from datetime import datetime, timedelta
from typing import Optional, Any, Union
from jose import jwt, JWTError
import bcrypt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
import os
from database import get_db, User

# Configuration (using values from .env)
SECRET_KEY = os.getenv("SECRET_KEY", "une_cle_secrete_tres_longue_et_securisee_pour_le_dev")
ALGORITHM = os.getenv("ALGORITHM", "HS256")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "60"))

# pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
# On utilise maintenant bcrypt directement pour éviter les bugs de compatibilité de passlib
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="api/v1/auth/login")

def verify_password(plain_password, hashed_password):
    return bcrypt.checkpw(plain_password.encode('utf-8'), hashed_password.encode('utf-8'))

def get_password_hash(password):
    # bcrypt a une limite de 72 octets, on s'assure que le password est en bytes
    pwd_bytes = password.encode('utf-8')
    salt = bcrypt.gensalt()
    return bcrypt.hashpw(pwd_bytes, salt).decode('utf-8')

def create_access_token(data: dict, expires_delta: Optional[timedelta] = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

async def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
        
    user = db.query(User).filter(User.blockchain_id == user_id).first()
    if user is None:
        raise credentials_exception
    return user

async def get_optional_current_user(token: Optional[str] = Depends(OAuth2PasswordBearer(tokenUrl="api/v1/auth/login", auto_error=False)), db: Session = Depends(get_db)) -> Optional[User]:
    """Version optionnelle de get_current_user qui ne lève pas d'erreur si le token est absent."""
    if not token:
        return None
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        if user_id is None:
            return None
        return db.query(User).filter(User.blockchain_id == user_id).first()
    except:
        return None

async def get_validated_user(current_user: User = Depends(get_current_user)) -> User:
    """Vérifie que l'utilisateur a été validé par le Ministère sur la Blockchain."""
    if not current_user.blockchain_validated and current_user.role != "MINISTERE":
        detail_msg = "Votre compte est en attente de validation. "
        if current_user.role == "PRODUCTEUR":
            detail_msg += "Veuillez contacter votre coopérative pour activer votre compte."
        else:
            detail_msg += "Veuillez attendre la validation du Ministère."
            
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail=detail_msg
        )
    return current_user
