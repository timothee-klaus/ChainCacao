from fastapi import APIRouter, Depends, HTTPException, status
from models.schemas import ActorRegister
from services.blockchain_gateway import BlockchainGateway
from sqlalchemy.orm import Session
from database import User, get_db
from services.storage import StorageService, get_storage
import security

router = APIRouter()
gateway = BlockchainGateway()

@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register_actor(
    actor: ActorRegister,
    current_user: User = Depends(security.get_current_user),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage)
):
    """
    1. Registers the identity in Fabric CA (Certificates)
    2. Registers the business metadata in the Smart Contract
    """
    # Hiérarchie : Ministère -> Coopérative -> Producteur
    if current_user.role == "MINISTERE":
        pass  # Autorisé pour tout type d'acteur
    elif current_user.role == "COOPERATIVE":
        if actor.type_acteur != "PRODUCTEUR":
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Une coopérative ne peut enregistrer que des producteurs."
            )
        # Vérification supplémentaire : est-ce que ce producteur a bien choisi cette coopérative ?
        target_user = storage.get_user_by_blockchain_id(db, actor.actor_id_hash)
        if not target_user or target_user.parent_id != current_user.blockchain_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Ce producteur ne fait pas partie de votre coopérative."
            )
    else:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seul le ministère ou une coopérative peut enregistrer des acteurs"
        )

    try:
        # 0. Récupération des métadonnées locales (ex: Hash du document de légalité)
        target_user = storage.get_user_by_blockchain_id(db, actor.actor_id_hash)
        metadata = "{}"
        if target_user and target_user.document_legalite_hash:
            import json
            metadata = json.dumps({
                "preuve_legalite_hash": target_user.document_legalite_hash,
                "full_name": target_user.full_name
            })

        # 1. CA Registration (Identity)
        ca_result = await gateway.register_user(actor.actor_id_hash, actor.org_name)
        if not ca_result.get("success"):
            raise HTTPException(status_code=500, detail=f"CA Registration failed: {ca_result.get('error')}")

        # 2. Chaincode Registration (Business Logic)
        args = [actor.actor_id_hash, actor.type_acteur, actor.cle_publique, metadata]
        cc_result = await gateway.invoke_transaction(
            "RegisterActor", 
            args, 
            current_user.org_name, 
            current_user.blockchain_id
        )
        
        # 3. Mark as validated in local DB and set as admin if institutional
        storage.set_user_blockchain_validated(db, actor.actor_id_hash, True)
        
        if actor.type_acteur in ["COOPERATIVE", "EXPORTATEUR", "CERTIF", "TRANSFORMATEUR", "MINISTERE"]:
            if target_user:
                target_user.is_admin = True
                db.commit()
        
        # 4. If a Cooperative registers a Producer, link them
        if current_user.role == "COOPERATIVE" and actor.type_acteur == "PRODUCTEUR":
            storage.update_user_parent(db, actor.actor_id_hash, current_user.blockchain_id)
        
        return {
            "success": True,
            "message": "Actor fully registered in CA and Blockchain",
            "ca_details": ca_result,
            "chaincode_details": cc_result
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

