from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Form
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session
from database import get_db, User
from services.blockchain_gateway import BlockchainGateway
from services.storage import StorageService, get_storage
import datetime
import security
import uuid
from models.schemas import GPSModel, BundleCreate

router = APIRouter()
gateway = BlockchainGateway()


@router.post("/", response_model=dict, status_code=status.HTTP_201_CREATED)
async def create_new_lot(
    latitude: str = Form(...),
    longitude: str = Form(...),
    poids_kg: str = Form(...),
    espece: str = Form(...),
    date_collecte: str = Form(...),
    coop_id: str = Form(""),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
    current_user: User = Depends(security.get_current_user),
):
    """
    Crée un nouveau lot de récolte (opération unifiée) :
    - Génère un ID unique (LOT-YYYYMMDD-XXXXXXXX)
    - Sauvegarde l'image via StorageService
    - Inscrit le lot sur le ledger Fabric
    """
    # 0. Contrôle d'accès : rôle PRODUCTEUR requis
    if current_user.role != "PRODUCTEUR":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seuls les producteurs peuvent créer des lots",
        )

    # 1. Génération de l'ID du lot
    today = datetime.datetime.now().strftime("%Y%m%d")
    short_id = str(uuid.uuid4())[:8].upper()
    generated_lot_id = f"LOT-{today}-{short_id}"

    # 2. Conversion et validation des coordonnées
    try:
        f_lat = float(latitude)
        f_lon = float(longitude)
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
    lot_data = {
        "lot_hash": generated_lot_id,
        "farmer_id": current_user.blockchain_id,
        "gps": {"latitude": f_lat, "longitude": f_lon},
        "poids_kg": f_poids,
        "espece": espece,
        "date_collecte": date_collecte,
        "media_hash": sha256_hash,
        "coop_id": coop_id,
    }

    blockchain_result = await gateway.create_lot(
        lot_data,
        current_user.org_name,
        current_user.blockchain_id,
    )

    return {
        "success": True,
        "lot_id": generated_lot_id,
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
            current_user.org_name,
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
    Récupère l'état actuel d'un lot depuis le ledger Fabric.
    """
    result = await gateway.get_lot(lot_hash, current_user.org_name, current_user.blockchain_id)
    if result is None or (isinstance(result, dict) and result.get("success") is False):
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=result.get("error", "Lot non trouvé sur le ledger")
            if isinstance(result, dict)
            else "Lot non trouvé",
        )
    return {"success": True, "data": result}


@router.get("/media/{media_hash}")
async def get_lot_media(
    media_hash: str,
    db: Session = Depends(get_db),
    storage: StorageService = Depends(get_storage),
):
    """
    Retourne le fichier image associé à un hash SHA-256.
    """
    media = storage.get_media_by_hash(db, media_hash)
    if not media:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Média non trouvé")
    return FileResponse(media.file_path)
