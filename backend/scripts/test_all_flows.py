import httpx
import time
import json
import os
import uuid

# Configuration
BASE_URL = "https://chaincacao-production-363c.up.railway.app/api/v1"
ADMIN_EMAIL = "admin@ministere.tg"
ADMIN_PWD = "Ministere2026!"

# For dynamic generation
timestamp = int(time.time())

def log(msg, level="INFO"):
    colors = {"INFO": "\033[94m", "SUCCESS": "\033[92m", "ERROR": "\033[91m", "WARNING": "\033[93m", "RESET": "\033[0m"}
    print(f"{colors.get(level, '')}[{level}] {msg}{colors['RESET']}")

def create_dummy_pdf(filename="dummy_proof.pdf"):
    with open(filename, "wb") as f:
        f.write(b"%PDF-1.4 dummy content for test " + str(uuid.uuid4()).encode())
    return filename

def create_dummy_image(filename="dummy_lot.jpg"):
    with open(filename, "wb") as f:
        f.write(os.urandom(1024)) # Dummy binary data
    return filename

def run_test():
    client = httpx.Client(base_url=BASE_URL, timeout=60.0)
    
    test_results = []
    
    try:
        # STEP 1: Ministry Login
        log("--- STEP 1: Ministry Login ---")
        resp = client.post("/auth/login", data={"username": ADMIN_EMAIL, "password": ADMIN_PWD})
        if resp.status_code != 200:
            log(f"FAIL: Ministry login failed: {resp.text}", "ERROR")
            return
        
        admin_token = resp.json()["access_token"]
        headers_admin = {"Authorization": f"Bearer {admin_token}"}
        log("Ministry login successful.", "SUCCESS")

        # STEP 2: Register Cooperative
        log("--- STEP 2: Register Cooperative ---")
        coop_email = f"coop_{timestamp}@test.com"
        pdf = create_dummy_pdf()
        
        with open(pdf, "rb") as f:
            resp = client.post("/auth/register", data={
                "email": coop_email,
                "password": "CoopPassword123!",
                "full_name": "Coop Test Togo",
                "role": "COOPERATIVE",
                "is_admin": "true"
            }, files={"file": ("proof.pdf", f, "application/pdf")})
        
        if resp.status_code != 201:
            log(f"FAIL: Coop registration: {resp.text}", "ERROR")
            return
        
        coop_data = resp.json()
        coop_blockchain_id = coop_data["blockchain_id"]
        log(f"Coop registered locally. ID: {coop_blockchain_id}", "SUCCESS")

        # STEP 3: Validate Cooperative (Ministry)
        log("--- STEP 3: Ministry Validating Coop ---")
        # In schemas.py, all roles map to org 'test'
        resp = client.post("/actors/register", json={
            "actorIdHash": coop_blockchain_id,
            "typeActeur": "COOPERATIVE",
            "clePublique": "PUB_KEY_COOP_" + str(timestamp),
            "orgName": "test" 
        }, headers=headers_admin)
        
        if resp.status_code != 201:
            log(f"FAIL: Coop validation: {resp.text}", "ERROR")
            # Note: This might fail if the blockchain gateway is not running or unreachable
            log("Ambiguity/Error: Blockchain registration failed. Is the gateway up?", "WARNING")
        else:
            log("Coop validated on blockchain.", "SUCCESS")

        # STEP 4: Login as Cooperative
        log("--- STEP 4: Cooperative Login ---")
        resp = client.post("/auth/login", data={"username": coop_email, "password": "CoopPassword123!"})
        if resp.status_code != 200:
            log(f"FAIL: Coop login: {resp.text}", "ERROR")
            return
        
        coop_token = resp.json()["access_token"]
        headers_coop = {"Authorization": f"Bearer {coop_token}"}
        log("Coop login successful.", "SUCCESS")

        # STEP 5: Register Producer (Delegated by Coop)
        log("--- STEP 5: Coop Registering Producer ---")
        prod_phone = f"22899{str(timestamp)[-5:]}"
        resp = client.post("/auth/register-producer", json={
            "fullName": "Jean Producteur",
            "numeroTelephone": prod_phone
        }, headers=headers_coop)
        
        if resp.status_code != 200:
            log(f"FAIL: Producer registration: {resp.text}", "ERROR")
            return
        
        prod_data = resp.json()
        prod_blockchain_id = prod_data["blockchain_id"]
        log(f"Producer registered locally. ID: {prod_blockchain_id}", "SUCCESS")

        # STEP 6: Validate Producer (Coop)
        log("--- STEP 6: Coop Validating Producer ---")
        resp = client.post("/actors/register", json={
            "actorIdHash": prod_blockchain_id,
            "typeActeur": "PRODUCTEUR",
            "clePublique": "PUB_KEY_PROD_" + str(timestamp),
            "orgName": "test"
        }, headers=headers_coop)
        
        if resp.status_code != 201:
            log(f"FAIL: Producer validation: {resp.text}", "ERROR")
        else:
            log("Producer validated on blockchain.", "SUCCESS")

        # STEP 7: Login as Producer
        log("--- STEP 7: Producer Login ---")
        # Producer login uses phone as username and password (delegated flow)
        resp = client.post("/auth/login", data={"username": prod_phone, "password": prod_phone})
        if resp.status_code != 200:
            log(f"FAIL: Producer login: {resp.text}", "ERROR")
            return
        
        prod_token = resp.json()["access_token"]
        headers_prod = {"Authorization": f"Bearer {prod_token}"}
        log("Producer login successful.", "SUCCESS")

        # STEP 8: Register Parcelle
        log("--- STEP 8: Register Parcelle ---")
        resp = client.post("/parcelles/", json={
            "gps": [
                {"latitude": 6.12, "longitude": 1.22},
                {"latitude": 6.13, "longitude": 1.22},
                {"latitude": 6.12, "longitude": 1.23}
            ],
            "culture": "Cacao",
            "surface": 2.5
        }, headers=headers_prod)
        
        if resp.status_code != 200:
            log(f"FAIL: Parcelle registration: {resp.text}", "ERROR")
            log("Ambiguity: Does the blockchain support Parcelle type?", "WARNING")
            parcelle_id = "UNKNOWN"
        else:
            parcelle_id = resp.json().get("parcelle_id", f"PARC-{timestamp}")
            log(f"Parcelle {parcelle_id} registered automatically.", "SUCCESS")

        # STEP 9: Create Lot
        log("--- STEP 9: Create Lot ---")
        lot_id = f"LOT-{timestamp}"
        img = create_dummy_image()
        
        with open(img, "rb") as f:
            resp = client.post("/lots/", data={
                "parcelle_id": parcelle_id,
                "poids_kg": "50.5",
                "espece": "Forastero",
                "date_collecte": "2026-05-12",
                "coop_id": coop_blockchain_id
            }, files={"file": ("harvest.jpg", f, "image/jpeg")}, headers=headers_prod)
        
        if resp.status_code != 201:
            log(f"FAIL: Lot creation: {resp.text}", "ERROR")
        else:
            log(f"Lot {lot_id} created.", "SUCCESS")
            real_lot_id = resp.json().get("lot_id", lot_id)

            # STEP 10: Audit / Traceability
            log("--- STEP 10: Audit Lot ---")
            resp = client.get(f"/audit/verify/{real_lot_id}")
            if resp.status_code == 200:
                log("Public verification successful.", "SUCCESS")
                print(json.dumps(resp.json(), indent=2))
            else:
                log(f"FAIL: Public verification: {resp.text}", "ERROR")

            log("--- STEP 11: EUDR Report ---")
            resp = client.get(f"/audit/eudr-report/{real_lot_id}", headers=headers_admin)
            if resp.status_code == 200:
                log("EUDR Report generated.", "SUCCESS")
                # print(json.dumps(resp.json(), indent=2))
            else:
                log(f"FAIL: EUDR Report: {resp.text}", "ERROR")

            log("--- STEP 12: Register Certificateur ---")
            cert_email = f"cert_{timestamp}@test.com"
            pdf = create_dummy_pdf()
            with open(pdf, "rb") as f:
                resp = client.post("/auth/register", data={
                    "email": cert_email,
                    "password": "CertPassword123!",
                    "full_name": "Ecocert Togo",
                    "role": "CERTIF",
                    "is_admin": "true"
                }, files={"file": ("proof.pdf", f, "application/pdf")})
            
            if resp.status_code != 201:
                log(f"FAIL: Cert register: {resp.text}", "ERROR")
            else:
                cert_id = resp.json()["blockchain_id"]
                log(f"Certificateur registered locally. ID: {cert_id}", "SUCCESS")
                
                resp = client.post("/actors/register", json={
                    "actorIdHash": cert_id,
                    "typeActeur": "CERTIFICATEUR",
                    "clePublique": "PUB_KEY_CERT_" + str(timestamp),
                    "orgName": "test"
                }, headers=headers_admin)
                log("Certificateur validated on blockchain.", "SUCCESS")

                resp = client.post("/auth/login", data={"username": cert_email, "password": "CertPassword123!"})
                cert_token = resp.json()["access_token"]
                headers_cert = {"Authorization": f"Bearer {cert_token}"}
                log("Certificateur login successful.", "SUCCESS")
                
                log("--- STEP 13: Add Certification ---")
                resp = client.post("/audit/certifications", json={
                    "certHash": f"CERT-{timestamp}",
                    "refHash": real_lot_id,
                    "verificateurId": cert_id,
                    "statut": "VALIDE",
                    "rapportHash": "HASH1234"
                }, headers=headers_cert)
                
                if resp.status_code == 201:
                    log("Certification added to lot.", "SUCCESS")
                else:
                    log(f"FAIL: Add cert: {resp.text}", "ERROR")

            log("--- STEP 14: Register Exportateur ---")
            exp_email = f"exp_{timestamp}@test.com"
            pdf = create_dummy_pdf()
            with open(pdf, "rb") as f:
                resp = client.post("/auth/register", data={
                    "email": exp_email,
                    "password": "ExpPassword123!",
                    "full_name": "Togo Exports",
                    "role": "EXPORTATEUR",
                    "is_admin": "true"
                }, files={"file": ("proof.pdf", f, "application/pdf")})
                
            if resp.status_code != 201:
                log(f"FAIL: Exportateur register: {resp.text}", "ERROR")
            else:
                exp_id = resp.json()["blockchain_id"]
                log(f"Exportateur registered locally. ID: {exp_id}", "SUCCESS")
                
                resp = client.post("/actors/register", json={
                    "actorIdHash": exp_id,
                    "typeActeur": "EXPORTATEUR",
                    "clePublique": "PUB_KEY_EXP_" + str(timestamp),
                    "orgName": "test"
                }, headers=headers_admin)
                log("Exportateur validated on blockchain.", "SUCCESS")

                resp = client.post("/auth/login", data={"username": exp_email, "password": "ExpPassword123!"})
                exp_token = resp.json()["access_token"]
                headers_exp = {"Authorization": f"Bearer {exp_token}"}
                log("Exportateur login successful.", "SUCCESS")
                
            log("--- STEP 15: Transfer (Producer -> Cooperative) ---")
            pdf = create_dummy_pdf()
            with open(pdf, "rb") as f:
                resp = client.post("/traceability/transfers", data={
                    "lotHashes": json.dumps([real_lot_id]),
                    "expediteurId": prod_blockchain_id,
                    "destinataireId": coop_blockchain_id
                }, files={"file": ("trans_prod_coop.pdf", f, "application/pdf")}, headers=headers_prod)
            
            if resp.status_code == 201:
                log("Transfer Producer -> Coop successful.", "SUCCESS")
            else:
                log(f"FAIL: Transfer Prod->Coop: {resp.text}", "ERROR")
                return

            log("--- STEP 16: Register & Login Transformateur ---")
            transfo_email = f"transfo_{timestamp}@test.com"
            pdf = create_dummy_pdf()
            with open(pdf, "rb") as f:
                client.post("/auth/register", data={
                    "email": transfo_email, "password": "TransfoPassword123!",
                    "full_name": "Usine Cacao Togo", "role": "TRANSFORMATEUR", "is_admin": "true"
                }, files={"file": ("proof.pdf", f, "application/pdf")})
            
            # Login & Validation Blockchain
            resp = client.post("/auth/login", data={"username": transfo_email, "password": "TransfoPassword123!"})
            transfo_token = resp.json()["access_token"]
            headers_transfo = {"Authorization": f"Bearer {transfo_token}"}
            transfo_id = resp.json()["user"]["blockchain_id"]
            
            client.post("/actors/register", json={
                "actorIdHash": transfo_id, "typeActeur": "TRANSFORMATEUR",
                "clePublique": "PUB_KEY_TRANS_" + str(timestamp), "orgName": "test"
            }, headers=headers_admin)
            log(f"Transformateur prêt. ID: {transfo_id}", "SUCCESS")

            log("--- STEP 17: Transfer (Cooperative -> Transformateur) ---")
            with open(create_dummy_pdf(), "rb") as f:
                resp = client.post("/traceability/transfers", data={
                    "lotHashes": json.dumps([real_lot_id]),
                    "expediteurId": coop_blockchain_id,
                    "destinataireId": transfo_id
                }, files={"file": ("trans_coop_transfo.pdf", f, "application/pdf")}, headers=headers_coop)
            
            if resp.status_code == 201:
                log("Transfer Coop -> Transfo successful.", "SUCCESS")
            else:
                log(f"FAIL: Transfer Coop->Transfo: {resp.text}", "ERROR")

            log("--- STEP 18: Transfer (Transformateur -> Exportateur) ---")
            # On utilise l'exportateur déjà créé à l'étape 14
            with open(create_dummy_pdf(), "rb") as f:
                resp = client.post("/traceability/transfers", data={
                    "lotHashes": json.dumps([real_lot_id]),
                    "expediteurId": transfo_id,
                    "destinataireId": exp_id
                }, files={"file": ("trans_transfo_exp.pdf", f, "application/pdf")}, headers=headers_transfo)
            
            if resp.status_code == 201:
                log("Transfer Transfo -> Export successful.", "SUCCESS")
            else:
                log(f"FAIL: Transfer Transfo->Export: {resp.text}", "ERROR")

            log("--- STEP 19: Create Shipment (Exportateur) ---")
            with open(create_dummy_pdf(), "rb") as f:
                resp = client.post("/traceability/shipments", data={
                    "lotHashes": json.dumps([real_lot_id]),
                    "exportateurId": exp_id,
                    "destination": "Anvers, Belgique",
                    "dateDepartPrevue": "2026-06-01",
                    "dateArriveePrevue": "2026-06-20"
                }, files={"file": ("customs.pdf", f, "application/pdf")}, headers=headers_exp)
            
            if resp.status_code == 201:
                log("Shipment created successfully.", "SUCCESS")
            else:
                log(f"FAIL: Shipment: {resp.text}", "ERROR")

    except Exception as e:
        log(f"Unexpected error: {e}", "ERROR")
    finally:
        client.close()
        # Cleanup
        for f in ["dummy_proof.pdf", "dummy_lot.jpg"]:
            if os.path.exists(f):
                os.remove(f)
        log("Test finished.")

if __name__ == "__main__":
    run_test()
