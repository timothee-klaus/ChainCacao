from fastapi import APIRouter, Depends, HTTPException, status
from typing import List, Dict, Any
from models.schemas import ParcelleCreate, ParcelleResponse
from database import User
import security
from services.blockchain_gateway import BlockchainGateway

router = APIRouter()
blockchain = BlockchainGateway()

@router.post("/", response_model=Dict[str, Any])
async def register_parcelle(
    parcelle: ParcelleCreate,
    current_user: User = Depends(security.get_validated_user)
):
    """
    Enregistre une nouvelle parcelle pour un producteur.
    Seuls les producteurs peuvent enregistrer leurs parcelles.
    """
    if current_user.role != "PRODUCTEUR":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seuls les producteurs peuvent enregistrer des parcelles."
        )

    # Force le farmer_id à être celui de l'utilisateur connecté
    parcelle_data = parcelle.model_dump(by_alias=True)
    parcelle_data["farmerId"] = current_user.blockchain_id

    result = await blockchain.register_parcelle(
        parcelle.model_dump(), 
        current_user.org_name, 
        current_user.blockchain_id
    )
    
    if not result.get("success"):
        raise HTTPException(status_code=400, detail=result.get("error"))
    
    return result

@router.get("/me", response_model=List[ParcelleResponse])
async def get_my_parcelles(current_user: User = Depends(security.get_validated_user)):
    """
    Récupère la liste des parcelles du producteur connecté.
    """
    if current_user.role != "PRODUCTEUR":
         raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Action réservée aux producteurs."
        )

    result = await blockchain.get_farmer_parcelles(
        current_user.blockchain_id,
        current_user.org_name,
        current_user.blockchain_id
    )
    
    if isinstance(result, dict) and result.get("success") is False:
        return []
        
    return result

@router.get("/{parcelle_id}", response_model=ParcelleResponse)
async def get_parcelle(
    parcelle_id: str,
    current_user: User = Depends(security.get_validated_user)
):
    """
    Récupère les détails d'une parcelle spécifique.
    """
    result = await blockchain.get_parcelle(
        parcelle_id,
        current_user.org_name,
        current_user.blockchain_id
    )
    
    if isinstance(result, dict) and result.get("success") is False:
        raise HTTPException(status_code=404, detail="Parcelle non trouvée")
        
    return result
