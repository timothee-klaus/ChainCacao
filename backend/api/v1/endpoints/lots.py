from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from database import get_db, User
from services.blockchain_gateway import BlockchainGateway
from services.storage import StorageService, get_storage
import datetime
import security
import uuid
from models.schemas import GPSModel, BundleCreate, ROLE_TO_ORG
from pydantic import BaseModel

class LotStatusUpdate(BaseModel):
    nouveau_statut: str

router = APIRouter()
gateway = BlockchainGateway()


@router.post("/", response_model=dict, status_code=status.HTTP_201_CREATED)
async def create_new_lot(
    parcelle_id: str = Form(...),
    poids_kg: str = Form(...),
    espece: str = Form(...),
    date_collecte: str = Form(...),
    coop_id: str = Form(""),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_validated_user),
):
    """
    Créer un nouveau lot de cacao dès la récolte. Cette opération unifiée :
    1. Génère un identifiant unique (LOT-YYYYMMDD-XXXXXXXX).
    2. Récupère les coordonnées GPS de la parcelle associée.
    3. Sauvegarde la photo de preuve via le StorageService (Hash SHA-256).
    4. Inscrit le lot de manière immuable sur la blockchain Fabric.
    """
    # 0. Contrôle d'accès : rôle PRODUCTEUR ou COOPERATIVE requis
    if current_user.role not in ["PRODUCTEUR", "COOPERATIVE"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seuls les producteurs et coopératives peuvent créer des lots",
        )

    # 1. Génération de l'ID du lot
    today = datetime.datetime.now().strftime("%Y%m%d")
    short_id = str(uuid.uuid4())[:8].upper()
    generated_lot_id = f"LOT-{today}-{short_id}"

    # 2. Conversion et validation des données numériques
    try:
        f_poids = float(poids_kg)
    except ValueError as ve:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Erreur de format numérique : {ve}",
        )

    # 3. Sauvegarde du média via le StorageService
    content = await file.read()
    media = storage.save_media(db, lot_hash=generated_lot_id, filename=file.filename, content=content)
    sha256_hash = media["sha256_hash"]

    # 4. Journalisation de l'action
    storage.log_action(db, user_id=current_user.blockchain_id, action=f"CREATE_LOT:{generated_lot_id}")

    # 5. Préparation et envoi vers la blockchain
    # On utilise automatiquement le parent_id de l'utilisateur si c'est un producteur
    effective_coop_id = coop_id if coop_id else (current_user.parent_id or "")

    lot_data = {
        "lot_hash": generated_lot_id,
        "farmer_id": current_user.blockchain_id,
        "parcelle_id": parcelle_id,
        "poids_kg": f_poids,
        "espece": espece,
        "date_collecte": date_collecte,
        "media_hash": sha256_hash,
        "coop_id": effective_coop_id,
    }

    blockchain_result = await gateway.create_lot(
        lot_data,
        ROLE_TO_ORG.get(current_user.role, "test"),
        current_user.blockchain_id,
    )
    
    if not blockchain_result.get("success"):
         raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=blockchain_result.get("error", "Erreur blockchain lors de la création du lot"),
        )

    return {
        "success": True,
        "lot_id": generated_lot_id,
        "parcelle_id": parcelle_id,
        "statut": "COLLECTE",
        "blockchain": blockchain_result,
        "media": {
            "hash": sha256_hash,
            "url": f"/api/v1/lots/media/{sha256_hash}",
        },
    }


# ...
@router.post("/regroup", response_model=dict, status_code=status.HTTP_201_CREATED)
async def regroup_lots(
    bundle: BundleCreate,
    current_user: User = Depends(security.get_current_user),
):
    """
    Action réservée aux coopératives (rôle PRODUCTEUR) :
    Regroupe plusieurs petits lots de producteurs en un seul lot consolidé (Bundle).
    """
    if current_user.role != "COOPERATIVE" or not current_user.is_admin:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seul l'administrateur d'une coopérative peut regrouper des lots",
        )

    try:
        result = await gateway.create_bundle(
            bundle.bundle_hash,
            bundle.lot_hashes,
            bundle.coop_id,
            ROLE_TO_ORG.get(current_user.role, "test"),
            current_user.blockchain_id
        )
        return {"success": True, "bundle": result}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/{lot_hash}", response_model=dict)
async def get_lot_details(
    lot_hash: str,
    current_user: User = Depends(security.get_current_user),
):
    """
    Récupérer les détails complets d'un lot spécifique (poids, origine, statut actuel) depuis le registre blockchain.
    """
    result = await gateway.get_lot(lot_hash, ROLE_TO_ORG.get(current_user.role, "test"), current_user.blockchain_id)
    if result is None or (isinstance(result, dict) and result.get("success") is False):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=result.get("error", "Lot non trouvé sur le ledger")
            if isinstance(result, dict)
            else "Lot non trouvé",
        )
    return {"success": True, "data": result}


@router.put("/{lot_hash}/status", response_model=dict)
async def update_lot_status(
    lot_hash: str,
    payload: LotStatusUpdate,
    current_user: User = Depends(security.get_current_user),
):
    """
    Mettre à jour le statut d'un lot existant (ex: passage de 'COLLECTE' à 'TRANSFORME' ou 'EN_EXPEDITION').
    Toute modification est tracée et horodatée sur la blockchain.
    """
    result = await gateway.update_lot_status(
        lot_hash,
        payload.nouveau_statut,
        ROLE_TO_ORG.get(current_user.role, "test"),
        current_user.blockchain_id
    )
    if not result or (isinstance(result, dict) and result.get("success") is False):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=result.get("error", "Erreur lors de la mise à jour") if isinstance(result, dict) else "Erreur"
        )
    return {"success": True, "data": result}

@router.get("/media/{media_hash}")
async def get_lot_media(
    media_hash: str,
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
):
    """
    Récupérer le fichier image (preuve visuelle de la récolte ou du transport) associé à un hash unique.
    """
    media = storage.get_media_by_hash(db, media_hash)
    if not media:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Média non trouvé")
    return FileResponse(media.file_path)
