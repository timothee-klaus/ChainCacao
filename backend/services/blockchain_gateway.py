import json
import logging
import httpx
import os
from typing import Any, Dict, List, Optional
from dotenv import load_dotenv

load_dotenv()

class BlockchainGateway:
    def __init__(self):
        self.logger = logging.getLogger("blockchain_gateway")
        # URL of our Node.js bridge from .env
        self.gateway_url = os.getenv("BLOCKCHAIN_GATEWAY_URL", "http://localhost:3000")
        self.channel_name = os.getenv("CHANNEL_NAME", "chaincacaochannel")
        self.chaincode_name = os.getenv("CHAINCODE_NAME", "chaincacao")


    async def invoke_transaction(self, function_name: str, args: List[str], org_name: str, user_id: str) -> Dict[str, Any]:
        """
        Calls the Node.js gateway to submit a transaction with specific identity.
        """
        self.logger.info(f"Invoking {function_name} as {user_id}@{org_name}")
        
        try:
            async with httpx.AsyncClient(timeout=45.0) as client:
                headers = {
                    "X-Org-Name": org_name,
                    "X-User-ID": user_id
                }
                response = await client.post(
                    f"{self.gateway_url}/invoke",
                    json={"function": function_name, "args": args},
                    headers=headers
                )
                
                if response.status_code != 200:
                    try:
                        # Try to get JSON error message
                        error_json = response.json()
                        return {"success": False, "error": error_json.get("error", response.text)}
                    except:
                        # Fallback to safe text decoding
                        return {"success": False, "error": response.content.decode('utf-8', errors='replace')}
                
                data = response.json()
                if not data.get("success", True):
                    raise Exception(data.get("error", "Unknown blockchain error"))
                return data
        except Exception as e:
            error_msg = str(e).encode('utf-8', 'replace').decode('utf-8')
            self.logger.error(f"Error invoking transaction: {error_msg}")
            raise Exception(error_msg)

    async def query_ledger(self, function_name: str, args: List[str], org_name: str, user_id: str) -> Any:
        """
        Calls the Node.js gateway to evaluate a transaction (query) with specific identity.
        """
        self.logger.info(f"Querying {function_name} as {user_id}@{org_name}")
        
        try:
            async with httpx.AsyncClient(timeout=10.0) as client:
                headers = {
                    "X-Org-Name": org_name,
                    "X-User-ID": user_id
                }
                response = await client.post(
                    f"{self.gateway_url}/query",
                    json={"function": function_name, "args": args},
                    headers=headers
                )
                
                if response.status_code != 200:
                    try:
                        error_json = response.json()
                        return {"success": False, "error": error_json.get("error", response.text)}
                    except:
                        return {"success": False, "error": response.content.decode('utf-8', errors='replace')}
                
                data = response.json()
                if not data.get("success", True):
                    raise Exception(data.get("error", "Unknown blockchain error"))
                
                result = data.get("result")
                # Si le résultat est une chaîne JSON, on la parse automatiquement
                if isinstance(result, str):
                    try:
                        import json as json_lib
                        return json_lib.loads(result)
                    except:
                        return result
                return result
        except Exception as e:
            error_msg = str(e).encode('utf-8', 'replace').decode('utf-8')
            self.logger.error(f"Error querying ledger: {error_msg}")
            return {"success": False, "error": error_msg}

    async def register_user(self, user_id: str, org_name: str, role: str = "client") -> Dict[str, Any]:
        """
        Calls the Node.js gateway to register and enroll a new user via CA.
        """
        self.logger.info(f"Registering new user {user_id} in {org_name}")
        
        try:
            async with httpx.AsyncClient(timeout=30.0) as client:
                response = await client.post(
                    f"{self.gateway_url}/register",
                    json={"userId": user_id, "orgName": org_name, "role": role}
                )
                
                if response.status_code not in (200, 201):
                    try:
                        error_json = response.json()
                        return {"success": False, "error": error_json.get("error", response.text)}
                    except:
                        return {"success": False, "error": response.text}
                        
                return response.json()
        except Exception as e:
            self.logger.error(f"Error registering user: {str(e)}")
            return {"success": False, "error": str(e)}

    # --- Wrapper methods matching the chaincode ---


    async def create_lot(self, data: Dict, org_name: str, user_id: str):
        args = [
            data['lot_hash'], data['farmer_id'], data['parcelle_id'],
            str(data['poids_kg']), data['espece'], data['date_collecte'],
            data['media_hash'], data.get('coop_id', "")
        ]
        return await self.invoke_transaction("CreateLot", args, org_name, user_id)

    async def register_parcelle(self, data: Dict, org_name: str, user_id: str):
        args = [
            data['parcelle_id'], data['farmer_id'], json.dumps(data['gps']),
            data['culture'], str(data['surface'])
        ]
        return await self.invoke_transaction("RegisterParcelle", args, org_name, user_id)

    async def get_parcelle(self, parcelle_id: str, org_name: str, user_id: str):
        return await self.query_ledger("GetParcelle", [parcelle_id], org_name, user_id)

    async def get_farmer_parcelles(self, farmer_id: str, org_name: str, user_id: str):
        return await self.query_ledger("GetFarmerParcelles", [farmer_id], org_name, user_id)

    async def get_lot(self, lot_hash: str, org_name: str, user_id: str):
        return await self.query_ledger("GetLot", [lot_hash], org_name, user_id)

    async def update_lot_status(self, lot_hash: str, nouveau_statut: str, org_name: str, user_id: str):
        return await self.invoke_transaction("UpdateLotStatus", [lot_hash, nouveau_statut], org_name, user_id)

    async def create_transfer(self, data: Dict, org_name: str, user_id: str):
        # On supporte à la fois les clés Python et les clés d'alias (CamelCase)
        args = [
            data.get('transfer_hash') or data.get('transferHash'),
            json.dumps(data.get('lot_hashes') or data.get('lotHashes')),
            data.get('expediteur_id') or data.get('expediteurId'),
            data.get('destinataire_id') or data.get('destinataireId'),
            data.get('preuve_hash') or data.get('preuveHash'),
            data.get('transporteur_id') or data.get('transporteurId') or ""
        ]
        return await self.invoke_transaction("CreateTransfer", args, org_name, user_id)

    async def get_history(self, asset_hash: str, org_name: str, user_id: str):
        return await self.query_ledger("GetHistoryForAsset", [asset_hash], org_name, user_id)

    async def query_lots_by_status(self, status: str, org_name: str, user_id: str):
        return await self.query_ledger("QueryLotsByStatus", [status], org_name, user_id)

    async def get_eudr_report(self, lot_hash: str, org_name: str, user_id: str) -> Dict[str, Any]:
        """
        Aggregates data for EUDR.
        """
        lot = await self.get_lot(lot_hash, org_name, user_id)
        if not lot or "error" in lot:
            return {"success": False, "error": "LOT_NOT_FOUND"}
            
        history = await self.get_history(lot_hash, org_name, user_id)
        certifications = await self.query_ledger("QueryCertifications", [lot_hash], org_name, user_id)
        
        # Check if private data (GPS) is present
        has_private_access = "gps" in lot
        
        return {
            "success": True,
            "report_timestamp": lot.get("dateCollecte"),
            "compliance_status": "COMPLIANT" if certifications else "PENDING_VERIFICATION",
            "access_level": "FULL" if has_private_access else "REDACTED",
            "data": {
                "lot": lot,
                "history": history,
                "certifications": certifications
            },
            "proof_hash": lot_hash
        }

    async def add_certification(self, data: Dict, org_name: str, user_id: str):
        args = [
            data['cert_hash'], data['ref_hash'], data['verificateur_id'],
            data['statut'], data['rapport_hash']
        ]
        return await self.invoke_transaction("AddCertification", args, org_name, user_id)

    async def create_bundle(self, bundle_hash: str, lot_hashes: List[str], coop_id: str, org_name: str, user_id: str):
        args = [bundle_hash, json.dumps(lot_hashes), coop_id]
        return await self.invoke_transaction("CreateBundle", args, org_name, user_id)

    async def get_shipment_eudr_report(self, shipment_hash: str, org_name: str, user_id: str) -> Dict[str, Any]:
        """
        Génère un rapport de conformité pour une expédition (regroupe tous les lots).
        """
        # 1. Get shipment details
        shipment = await self.query_ledger("GetShipment", [shipment_hash], org_name, user_id)
        if not shipment or "error" in shipment:
            return {"success": False, "error": "SHIPMENT_NOT_FOUND"}
            
        lot_hashes = shipment.get("lotHashes", [])
        lot_reports = []
        
        # 2. Get report for each lot
        for lot_hash in lot_hashes:
            report = await self.get_eudr_report(lot_hash, org_name, user_id)
            lot_reports.append(report)
            
        return {
            "success": True,
            "shipment_hash": shipment_hash,
            "destination": shipment.get("destination"),
            "exportateur_id": shipment.get("exportateurId"),
            "lots_count": len(lot_hashes),
            "lot_reports": lot_reports,
            "compliance_summary": "ALL_COMPLIANT" if all(r.get("compliance_status") == "COMPLIANT" for r in lot_reports) else "ACTION_REQUIRED"
        }

    async def get_bundle_eudr_report(self, bundle_hash: str, org_name: str, user_id: str) -> Dict[str, Any]:
        """
        Génère un rapport de conformité agrégé pour un regroupement de lots (Bundle).
        """
        # 1. Récupérer les détails du bundle (on utilise GetLot car c'est la même collection sur le ledger)
        bundle = await self.query_ledger("GetLot", [bundle_hash], org_name, user_id)
        if not bundle or "error" in bundle:
            return {"success": False, "error": "BUNDLE_NOT_FOUND"}
            
        lot_hashes = bundle.get("lotHashes", [])
        lot_reports = []
        
        # 2. Récupérer le rapport individuel pour chaque lot enfant
        for lot_hash in lot_hashes:
            report = await self.get_eudr_report(lot_hash, org_name, user_id)
            lot_reports.append(report)
            
        # 3. Calculer un statut de conformité global
        is_all_compliant = all(r.get("compliance_status") == "COMPLIANT" for r in lot_reports)
        
        return {
            "success": True,
            "bundle_hash": bundle_hash,
            "total_poids": bundle.get("totalPoids"),
            "timestamp": bundle.get("timestamp"),
            "lots_count": len(lot_hashes),
            "lot_reports": lot_reports,
            "compliance_summary": "ALL_COMPLIANT" if is_all_compliant else "ACTION_REQUIRED"
        }
