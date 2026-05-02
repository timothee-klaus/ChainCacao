from fastapi import APIRouter, Depends, HTTPException, status
from models.schemas import ActorRegister
from services.blockchain_gateway import BlockchainGateway
from database import User
import security

router = APIRouter()
gateway = BlockchainGateway()

@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register_actor(
    actor: ActorRegister,
    current_user: User = Depends(security.get_current_user)
):
    """
    1. Registers the identity in Fabric CA (Certificates)
    2. Registers the business metadata in the Smart Contract
    """
    # Seul le ministère peut enregistrer de nouveaux acteurs officiels
    if current_user.role != "MINISTERE":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seul le ministère peut enregistrer des acteurs"
        )

    try:
        # 1. CA Registration (Identity)
        ca_result = await gateway.register_user(actor.actor_id_hash, actor.org_name)
        if not ca_result.get("success"):
            raise HTTPException(status_code=500, detail=f"CA Registration failed: {ca_result.get('error')}")

        # 2. Chaincode Registration (Business Logic)
        args = [actor.actor_id_hash, actor.type_acteur, actor.cle_publique]
        cc_result = await gateway.invoke_transaction(
            "RegisterActor", 
            args, 
            current_user.org_name, 
            current_user.blockchain_id
        )
        
        return {
            "success": True,
            "message": "Actor fully registered in CA and Blockchain",
            "ca_details": ca_result,
            "chaincode_details": cc_result
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

