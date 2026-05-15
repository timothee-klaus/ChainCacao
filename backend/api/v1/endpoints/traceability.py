from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from sqlalchemy.orm import Session
from database import get_db, User
from services.storage import StorageService, get_storage
from services.blockchain_gateway import BlockchainGateway
import security
import json
from models.schemas import ROLE_TO_ORG

router = APIRouter()
gateway = BlockchainGateway()

@router.post("/transfers", status_code=status.HTTP_201_CREATED)
async def create_transfer(
    lot_hashes: str = Form(..., alias="lotHashes", description="JSON list of lot hashes"),
    expediteur_id: str = Form(..., alias="expediteurId"),
    destinataire_id: str = Form(..., alias="destinataireId"),
    transporteur_id: str = Form("", alias="transporteurId", description="ID of the transport company (optional)"),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_validated_user)
):
    """
    Record a ownership transfer between two actors.
    Requires uploading a proof document. Optionally associate a transporteur.
    """
    import datetime, uuid
    try:
        # Génération automatique du hash de transfert
        today = datetime.datetime.now().strftime("%Y%m%d")
        short_id = str(uuid.uuid4())[:8].upper()
        generated_transfer_hash = f"TRANS-{today}-{short_id}"

        lot_hashes_list = json.loads(lot_hashes)
        content = await file.read()
        media = storage.save_media(db, lot_hash=generated_transfer_hash, filename=file.filename, content=content)
        
        data = {
            "transfer_hash": generated_transfer_hash,
            "lot_hashes": lot_hashes_list,
            "expediteur_id": expediteur_id,
            "destinataire_id": destinataire_id,
            "transporteur_id": transporteur_id,
            "preuve_hash": media["sha256_hash"]
        }
        
        return await gateway.create_transfer(
            data, 
            ROLE_TO_ORG.get(current_user.role, "test"), 
            current_user.blockchain_id
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/transformations", status_code=status.HTTP_201_CREATED)
async def create_transformation(
    lot_hashes: str = Form(..., alias="lotHashes", description="JSON list of lot hashes"),
    type_processus: str = Form(..., alias="typeProcessus"),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_validated_user)
):
    """
    Enregistre un processus de transformation industrielle.
    Rôles autorisés : TRANSFORMATEUR, EXPORTATEUR.
    """
    if current_user.role not in ["TRANSFORMATEUR", "EXPORTATEUR"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seuls les transformateurs et exportateurs peuvent enregistrer une transformation."
        )

    import datetime, uuid
    try:
        # Génération automatique du hash de transformation
        today = datetime.datetime.now().strftime("%Y%m%d")
        short_id = str(uuid.uuid4())[:8].upper()
        generated_transformation_hash = f"TRSF-{today}-{short_id}"

        lot_hashes_list = json.loads(lot_hashes)
        content = await file.read()
        media = storage.save_media(db, lot_hash=generated_transformation_hash, filename=file.filename, content=content)
        
        args = [
            generated_transformation_hash, 
            json.dumps(lot_hashes_list), 
            type_processus, 
            media["sha256_hash"]
        ]
        return await gateway.invoke_transaction(
            "CreateTransformation", 
            args, 
            ROLE_TO_ORG.get(current_user.role, "test"), 
            current_user.blockchain_id
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.post("/shipments", status_code=status.HTTP_201_CREATED)
async def create_shipment(
    lot_hashes: str = Form(..., alias="lotHashes", description="JSON list of lot hashes"),
    exportateur_id: str = Form(..., alias="exportateurId"),
    destination: str = Form(...),
    date_depart_prevue: str = Form(..., alias="dateDepartPrevue"),
    date_arrivee_prevue: str = Form(..., alias="dateArriveePrevue"),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_validated_user)
):
    """
    Enregistre un nouvel envoi international.
    Rôle autorisé : EXPORTATEUR.
    """
    if current_user.role != "EXPORTATEUR":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seuls les exportateurs peuvent enregistrer un envoi."
        )

    import datetime, uuid
    try:
        # Génération automatique du hash d'expédition
        today = datetime.datetime.now().strftime("%Y%m%d")
        short_id = str(uuid.uuid4())[:8].upper()
        generated_shipment_hash = f"SHIP-{today}-{short_id}"

        lot_hashes_list = json.loads(lot_hashes)
        content = await file.read()
        media = storage.save_media(db, lot_hash=generated_shipment_hash, filename=file.filename, content=content)
        
        args = [
            generated_shipment_hash, json.dumps(lot_hashes_list), exportateur_id,
            destination, media["sha256_hash"], date_depart_prevue,
            date_arrivee_prevue
        ]
        return await gateway.invoke_transaction(
            "CreateShipment", 
            args, 
            ROLE_TO_ORG.get(current_user.role, "test"), 
            current_user.blockchain_id
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/transfers/{transfer_hash}")
async def get_transfer(
    transfer_hash: str,
    current_user: User = Depends(security.get_validated_user)
):
    """
    Retrieve details of a specific transfer from the blockchain.
    """
    return await gateway.query_ledger("GetTransfer", [transfer_hash], ROLE_TO_ORG.get(current_user.role, "test"), current_user.blockchain_id)

@router.get("/transformations/{transformation_hash}")
async def get_transformation(
    transformation_hash: str,
    current_user: User = Depends(security.get_validated_user)
):
    """
    Retrieve details of a specific transformation from the blockchain.
    """
    return await gateway.query_ledger("GetTransformation", [transformation_hash], ROLE_TO_ORG.get(current_user.role, "test"), current_user.blockchain_id)

@router.get("/shipments/{shipment_hash}")
async def get_shipment(
    shipment_hash: str,
    current_user: User = Depends(security.get_validated_user)
):
    """
    Retrieve details of a specific shipment from the blockchain.
    """
    return await gateway.query_ledger("GetShipment", [shipment_hash], ROLE_TO_ORG.get(current_user.role, "test"), current_user.blockchain_id)

@router.get("/transfers/user/{user_id}")
async def get_user_transfers(
    user_id: str,
    current_user: User = Depends(security.get_validated_user)
):
    """
    Retrieve all transfers where the specified user is either sender or receiver.
    """
    return await gateway.query_ledger("QueryTransfersByUser", [user_id], ROLE_TO_ORG.get(current_user.role, "test"), current_user.blockchain_id)
