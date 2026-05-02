from fastapi import APIRouter, Depends, HTTPException, status
from services.blockchain_gateway import BlockchainGateway
from models.schemas import CertificationCreate
from database import User
import security
import uuid

router = APIRouter()
gateway = BlockchainGateway()

@router.post("/certifications", status_code=status.HTTP_201_CREATED)
async def create_certification(
    cert: CertificationCreate,
    current_user: User = Depends(security.get_current_user)
):
    """
    Submit a new compliance certification (EUDR, Bio, etc.) for a lot.
    Role: CERTIF or MINISTERE
    """
    if current_user.role not in ["CERTIF", "MINISTERE"]:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Seuls les certificateurs ou le ministère peuvent approuver des lots"
        )
    
    try:
        return await gateway.add_certification(
            cert.model_dump(), 
            current_user.org_name, 
            current_user.blockchain_id
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/history/{asset_hash}")
async def get_asset_history(
    asset_hash: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Fetch the complete immutable audit trail for any asset on the ledger.
    """
    return await gateway.get_history(asset_hash, current_user.org_name, current_user.blockchain_id)

@router.get("/query/status/{status}")
async def query_by_status(
    status: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Search for lots based on their current status (utilizes CouchDB indexes).
    """
    return await gateway.query_lots_by_status(status, current_user.org_name, current_user.blockchain_id)

@router.get("/query/farmer/{farmer_id}")
async def query_by_farmer(
    farmer_id: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Retrieve all lots associated with a specific farmer.
    """
    return await gateway.query_ledger("QueryLotsByFarmer", [farmer_id], current_user.org_name, current_user.blockchain_id)

@router.get("/query/certifications/{ref_hash}")
async def get_certifications(
    ref_hash: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Get all certifications linked to a lot or a shipment.
    """
    return await gateway.query_ledger("QueryCertifications", [ref_hash], current_user.org_name, current_user.blockchain_id)

@router.get("/eudr-report/{lot_hash}")
async def generate_eudr_report(
    lot_hash: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Generate a structured proof for EUDR compliance.
    Includes origin, history, and certifications.
    """
    result = await gateway.get_eudr_report(lot_hash, current_user.org_name, current_user.blockchain_id)
    if not result.get("success"):
        raise HTTPException(status_code=404, detail=result.get("error"))
    return result

@router.get("/verify/{lot_hash}")
async def verify_lot_public(
    lot_hash: str,
    # For public verification, we might allow any logged in user to see basic info
    current_user: User = Depends(security.get_current_user)
):
    """
    Public endpoint for QR Code verification.
    Provides a simplified, consumer-friendly view of the lot's journey.
    """
    try:
        # 1. Get the latest state of the lot
        lot_details = await gateway.get_lot(lot_hash, current_user.org_name, current_user.blockchain_id)
        
        # 2. Get the history of transfers
        history = await gateway.get_history(lot_hash, current_user.org_name, current_user.blockchain_id)
        
        # 3. Format a consumer-friendly response
        return {
            "lot_id": lot_hash,
            "product": "Cacao du Togo",
            "harvest_info": {
                "date": lot_details.get("dateCollecte"),
                "species": lot_details.get("espece"),
                "weight": lot_details.get("poidsKg")
            },
            "origin_photo": f"/api/v1/lots/media/{lot_details.get('mediaHash')}" if lot_details.get("mediaHash") else None,
            "journey": [
                {
                    "step": h.get("value", {}).get("statut"),
                    "date": h.get("timestamp"),
                    "txId": h.get("txId")[:10] + "..." # Mask for consumers
                } for h in history
            ],
            "blockchain_verified": True
        }
    except Exception as e:
        raise HTTPException(status_code=404, detail="Traceability info not found for this QR code")
