from fastapi import APIRouter, Depends, HTTPException, status
from models.schemas import ActorRegister, UserPublicResponse
from typing import List
from services.blockchain_gateway import BlockchainGateway
from sqlalchemy.orm import Session
from database import User, get_db
from services.storage import StorageService, get_storage
import security

router = APIRouter()
gateway = BlockchainGateway()

@router.get("/producers/pending", response_model=List[UserPublicResponse], summary="Lister les producteurs en attente de validation")
async def list_pending_producers(
    current_user: User = Depends(security.get_current_user),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage)
):
    """
    Retourne la liste des producteurs ayant choisi cette coopérative lors de leur inscription,
    mais n'ayant pas encore reçu leur identité numérique blockchain officielle.
    """
    if current_user.role != "COOPERATIVE":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seules les coopératives peuvent consulter leurs producteurs en attente."
        )
    
    return storage.get_users(db, role="PRODUCTEUR", parent_id=current_user.blockchain_id, validated=False)

@router.get("/recipients", response_model=List[UserPublicResponse], summary="Lister les destinataires autorisés pour un transfert")
async def list_available_recipients(
    current_user: User = Depends(security.get_current_user),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage)
):
    """
    Filtre les acteurs de la blockchain pouvant recevoir un transfert :
    - PRODUCTEUR -> COOPERATIVE
    - COOPERATIVE -> EXPORTATEUR / TRANSFORMATEUR
    - EXPORTATEUR -> TRANSFORMATEUR
    """
    if current_user.role == "PRODUCTEUR":
        # Producteur -> Coopérative uniquement
        return storage.get_users(db, role="COOPERATIVE", validated=True)
    
    elif current_user.role == "COOPERATIVE":
        # Coopérative -> Transformateur uniquement
        return storage.get_users(db, role="TRANSFORMATEUR", validated=True)
        
    elif current_user.role == "TRANSFORMATEUR":
        # Transformateur -> Exportateur uniquement
        return storage.get_users(db, role="EXPORTATEUR", validated=True)
        
    
    else:
        # Pour les autres rôles (Audit, Ministère), on liste tous les acteurs validés
        return storage.get_users(db, validated=True)


@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register_actor(
    actor: ActorRegister,
    current_user: User = Depends(security.get_current_user),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage)
):
    """
    Finaliser l'enrôlement d'un acteur sur la blockchain :
    1. Enregistre l'identité numérique auprès de l'Autorité de Certification (Fabric CA).
    2. Inscrit le profil métier et les métadonnées de légalité dans le Smart Contract.
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
        # 0. Récupération des métadonnées locales
        from models.schemas import ROLE_TO_ORG
        target_user = storage.get_user_by_blockchain_id(db, actor.actor_id_hash)
        metadata = "{}"
        if target_user and target_user.document_legalite_hash:
            import json
            metadata = json.dumps({
                "preuve_legalite_hash": target_user.document_legalite_hash,
                "full_name": target_user.full_name
            })

        # 1. CA Registration (Identity) - On force le dossier selon le rôle
        target_org = ROLE_TO_ORG.get(actor.type_acteur, "test")
        ca_result = await gateway.register_user(actor.actor_id_hash, target_org)
        if not ca_result.get("success"):
            raise HTTPException(status_code=500, detail=f"CA Registration failed: {ca_result.get('error')}")

        # 2. Chaincode Registration (Business Logic)
        # On utilise aussi le mapping pour l'utilisateur qui signe (current_user)
        signer_org = ROLE_TO_ORG.get(current_user.role, "test")
        args = [actor.actor_id_hash, actor.type_acteur, actor.cle_publique, metadata]
        cc_result = await gateway.invoke_transaction(
            "RegisterActor", 
            args, 
            signer_org, 
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
            "message": "Acteur entièrement enregistré (Identité CA + Profil Blockchain)",
            "ca_details": ca_result,
            "chaincode_details": cc_result
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

