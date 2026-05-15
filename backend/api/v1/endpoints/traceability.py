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
    transfer_hash: str = Form(..., alias="transferHash"),
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
    try:
        lot_hashes_list = json.loads(lot_hashes)
        content = await file.read()
        media = storage.save_media(db, lot_hash=transfer_hash, filename=file.filename, content=content)
        
        data = {
            "transfer_hash": transfer_hash,
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
    transformation_hash: str = Form(..., alias="transformationHash"),
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

    try:
        lot_hashes_list = json.loads(lot_hashes)
        content = await file.read()
        media = storage.save_media(db, lot_hash=transformation_hash, filename=file.filename, content=content)
        
        args = [
            transformation_hash, 
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
    shipment_hash: str = Form(..., alias="shipmentHash"),
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

    try:
        lot_hashes_list = json.loads(lot_hashes)
        content = await file.read()
        media = storage.save_media(db, lot_hash=shipment_hash, filename=file.filename, content=content)
        
        args = [
            shipment_hash, json.dumps(lot_hashes_list), exportateur_id,
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


