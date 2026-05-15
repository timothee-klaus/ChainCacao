from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import FileResponse
from services.blockchain_gateway import BlockchainGateway
from models.schemas import CertificationCreate
from database import User
import security
import uuid
import os
import tempfile
from fpdf import FPDF

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

@router.get("/query/owner/{owner_id}")
async def query_by_owner(
    owner_id: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Retrieve all lots currently owned by a specific actor (after transfer).
    """
    return await gateway.query_ledger("QueryLotsByOwner", [owner_id], current_user.org_name, current_user.blockchain_id)

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

@router.get("/eudr-report/{lot_hash}/pdf")
async def generate_eudr_report_pdf(
    lot_hash: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Generate a structured PDF proof for EUDR compliance.
    """
    result = await gateway.get_eudr_report(lot_hash, current_user.org_name, current_user.blockchain_id)
    if not result.get("success"):
        raise HTTPException(status_code=404, detail=result.get("error"))
    
    # Create PDF
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("helvetica", "B", 16)
    pdf.cell(w=0, h=10, txt="Certificat de Conformite EUDR", new_x="LMARGIN", new_y="NEXT", align="C")
    
    pdf.set_font("helvetica", size=12)
    pdf.ln(10)
    pdf.cell(w=0, h=10, txt=f"ID du Lot: {lot_hash}", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(w=0, h=10, txt=f"Statut: {result.get('compliance_status')}", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(w=0, h=10, txt=f"Date d'emission: {result.get('report_timestamp')}", new_x="LMARGIN", new_y="NEXT")
    
    pdf.ln(5)
    pdf.set_font("helvetica", "B", 12)
    pdf.cell(w=0, h=10, txt="Informations d'Origine:", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("helvetica", size=12)
    
    lot_data = result.get("data", {}).get("lot", {})
    if lot_data:
        gps = lot_data.get("gps", {})
        if gps:
            pdf.cell(w=0, h=10, txt=f"GPS: Lat {gps.get('latitude')}, Lon {gps.get('longitude')}", new_x="LMARGIN", new_y="NEXT")
        pdf.cell(w=0, h=10, txt=f"Espece: {lot_data.get('espece')}", new_x="LMARGIN", new_y="NEXT")
        pdf.cell(w=0, h=10, txt=f"Poids: {lot_data.get('poidsKg')} kg", new_x="LMARGIN", new_y="NEXT")
        pdf.cell(w=0, h=10, txt=f"Date de collecte: {lot_data.get('dateCollecte')}", new_x="LMARGIN", new_y="NEXT")
    
    pdf.ln(5)
    pdf.set_font("helvetica", "B", 12)
    pdf.cell(w=0, h=10, txt="Certifications:", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("helvetica", size=10)
    certs = result.get("data", {}).get("certifications", [])
    if certs:
        for cert in certs:
            pdf.cell(w=0, h=8, txt=f"- {cert.get('statut')} par {cert.get('verificateurId')}", new_x="LMARGIN", new_y="NEXT")
    else:
         pdf.cell(w=0, h=8, txt="Aucune certification trouvée.", new_x="LMARGIN", new_y="NEXT")
         
    pdf.ln(10)
    pdf.set_font("helvetica", "I", 10)
    pdf.cell(w=0, h=10, txt=f"Preuve d'integrite (Blockchain): {result.get('proof_hash')}", new_x="LMARGIN", new_y="NEXT")
    
    # Save to temp file
    fd, path = tempfile.mkstemp(suffix=".pdf")
    os.close(fd)
    pdf.output(path)
    
    return FileResponse(path, media_type="application/pdf", filename=f"EUDR_Report_{lot_hash}.pdf")

@router.get("/verify/{lot_hash}")
async def verify_lot_public(
    lot_hash: str,
):
    """
    Public endpoint for QR Code verification.
    Provides a simplified, consumer-friendly view of the lot's journey.
    """
    try:
        # 1. Get the latest state of the lot
        # Utilisation de l'identité admin pour la lecture publique (ou identité neutre)
        lot_details = await gateway.get_lot(lot_hash, "producteurs", "admin")
        
        # 2. Get the history of transfers
        history = await gateway.get_history(lot_hash, "producteurs", "admin")
        
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

@router.get("/shipment-report/{shipment_hash}")
async def generate_shipment_report(
    shipment_hash: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Rapport de conformité agrégé pour une expédition entière.
    """
    if current_user.role != "EXPORTATEUR" and current_user.role != "MINISTERE":
        raise HTTPException(status_code=403, detail="Accès réservé aux exportateurs et au ministère.")
    
    return await gateway.get_shipment_eudr_report(shipment_hash, current_user.org_name, current_user.blockchain_id)

@router.get("/shipment-report/{shipment_hash}/pdf")
async def generate_shipment_report_pdf(
    shipment_hash: str,
    current_user: User = Depends(security.get_current_user)
):
    """
    Génère un PDF récapitulatif de conformité pour l'exportation.
    """
    report = await gateway.get_shipment_eudr_report(shipment_hash, current_user.org_name, current_user.blockchain_id)
    if not report.get("success"):
        raise HTTPException(status_code=404, detail=report.get("error"))
    
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("helvetica", "B", 16)
    pdf.cell(w=0, h=10, txt=f"Manifeste de Conformite Export - {shipment_hash}", new_x="LMARGIN", new_y="NEXT", align="C")
    
    pdf.set_font("helvetica", size=12)
    pdf.ln(10)
    pdf.cell(w=0, h=8, txt=f"Destination: {report.get('destination')}", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(w=0, h=8, txt=f"Exportateur ID: {report.get('exportateur_id')}", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(w=0, h=8, txt=f"Nombre de Lots: {report.get('lots_count')}", new_x="LMARGIN", new_y="NEXT")
    pdf.cell(w=0, h=8, txt=f"Statut Global: {report.get('compliance_summary')}", new_x="LMARGIN", new_y="NEXT")
    
    pdf.ln(10)
    pdf.set_font("helvetica", "B", 12)
    pdf.cell(w=0, h=10, txt="Detail des points GPS (EUDR):", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("helvetica", size=10)
    
    for lot_rep in report.get("lot_reports", []):
        lot_data = lot_rep.get("data", {}).get("lot", {})
        gps = lot_data.get("gps", {})
        txt = f"- Lot {lot_data.get('lotHash')}: Lat {gps.get('latitude')}, Lon {gps.get('longitude')} | {lot_rep.get('compliance_status')}"
        pdf.cell(w=0, h=7, txt=txt, new_x="LMARGIN", new_y="NEXT")
    
    pdf.ln(15)
    pdf.set_font("helvetica", "I", 8)
    pdf.multi_cell(w=0, h=5, txt="Ce document atteste que tous les lots inclus dans cette expedition ont fait l'objet d'un suivi blockchain de la parcelle jusqu'au port d'embarquement.")
    
    fd, path = tempfile.mkstemp(suffix=".pdf")
    os.close(fd)
    pdf.output(path)
    
    return FileResponse(path, media_type="application/pdf", filename=f"Shipment_EUDR_{shipment_hash}.pdf")
