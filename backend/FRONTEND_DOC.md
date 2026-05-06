# 🚀 Guide d'Intégration API & Modèles — ChainCacao

Ce document fournit les détails techniques nécessaires pour l'intégration du frontend avec le backend ChainCacao.

---

## 🛠 Informations Générales

- **Base URL (Local) :** `http://localhost:8000`
- **Format des données :** JSON
- **Authentification :** JWT Bearer Token
- **Conventions :** Les requêtes utilisent majoritairement le `camelCase` via les alias Pydantic.

---

## 🧭 Résumé des Endpoints & Rôles

| Module | Endpoint | Méthode | Rôle Autorisé |
| :--- | :--- | :--- | :--- |
| **🔐 Auth** | `/api/v1/auth/register` | `POST` | **Public** (Requête) |
| | `/api/v1/auth/login` | `POST` | **Public** |
| | `/api/v1/auth/pending-registrations`| `GET` | **MINISTERE** |
| | `/api/v1/auth/users` | `GET` | **MINISTERE, COOPERATIVE** |
| | `/api/v1/auth/register-producer` | `POST` | **COOPERATIVE** (Admin) |
| | `/api/v1/auth/register-agent` | `POST` | **Toute Orgue (Admin)** |
| **👤 Acteurs**| `/api/v1/actors/register` | `POST` | **MINISTERE, COOPERATIVE** |
| **📦 Lots** | `/api/v1/lots/` | `POST` | **PRODUCTEUR, COOPERATIVE** (Validé) |
| | `/api/v1/lots/regroup` | `POST` | **COOPERATIVE** (Admin + Validé) |
| **🗺️ Parcelles**| `/api/v1/parcelles/` | `POST` | **PRODUCTEUR, COOPERATIVE** (Validé) |
| **🔗 Trace** | `/api/v1/traceability/transfers` | `POST` | **Tous les acteurs Validés** |
| | `/api/v1/traceability/transformations`| `POST` | **TRANSFO, EXPORT** (Validé) |
| | `/api/v1/traceability/shipments` | `POST` | **EXPORTATEUR** (Validé) |
| **📊 Audit** | `/api/v1/audit/verify/{hash}` | `GET` | **Public** (QR Code) |

---

## 🔐 Authentification

### 1. Inscription
`POST /api/v1/auth/register`

**Content-Type :** `multipart/form-data`

**Form Fields :**
| Champ | Type | Obligatoire | Description |
| :--- | :--- | :--- | :--- |
| `email` | string | Optionnel | Email (requis si pas de téléphone) |
| `numero_telephone` | string | Optionnel | Téléphone (requis si pas d'email) |
| `password` | string | Oui | Mot de passe (min 8 car.) |
| `full_name` | string | Oui | Nom complet |
| `role` | string | Oui | Rôle (PRODUCTEUR, COOPERATIVE, EXPORTATEUR, etc.) |
| `org_name` | string | Oui | Nom de l'organisation (ex: "producteurs") |
| `cooperative_id` | string | Non | ID de la coopérative parente |
| `is_admin` | boolean | Non | Flag administrateur (default: false) |
| `file` | file (Binary) | **Oui*** | **Preuve de légalité** (Requis pour COOPERATIVE, EXPORTATEUR, CERTIF) |

> [!IMPORTANT]
> **Hiérarchie de Création :**
> - **PRODUCTEUR** : Inscription libre (publique).
> - **ADMIN de Coop/Export/Certif** : Doit être créé par un agent du **MINISTERE**. L'appelant doit être authentifié avec un token valide du Ministère.

*\*Pour les PRODUCTEURS, le document est recommandé mais pas bloquant.*

### 2. Connexion
`POST /api/v1/auth/login`

**Content-Type :** `application/x-www-form-urlencoded`

**Request Body :**
| Champ | Type | Description |
| :--- | :--- | :--- |
| `username` | string | Email de l'utilisateur |
| `password` | string | Mot de passe |

**Response 200 :**
```json
{
  "access_token": "eyJhbGci...",
  "token_type": "bearer",
  "user": {
    "email": "jean.dupont@email.com",
    "full_name": "Jean Dupont",
    "role": "PRODUCTEUR",
    "org_name": "producteurs",
    "blockchain_id": "jean_dupont_123"
  }
}
```

### 3. Profil Actuel
`GET /api/v1/auth/me` (Header `Authorization: Bearer <token>`)

### 4. Lister les Utilisateurs (Dashboard)
`GET /api/v1/auth/users`
*Filtrage optionnel : `?role=PRODUCTEUR`*

**Permissions :** MINISTERE ou COOPERATIVE.

**Response Body :**
```json
[
  {
    "email": "prod@test.com",
    "full_name": "Producteur de Test",
    "role": "PRODUCTEUR",
    "org_name": "producteurs",
    "blockchain_id": "PRODUCTEUR-abc123",
    "blockchain_validated": false // Flag indiquant s'il faut valider le compte
  }
]
```

### 5. Demandes en Attente (Ministère)
`GET /api/v1/auth/pending-registrations`
*Retourne uniquement les acteurs institutionnels non encore validés sur la blockchain.*

**Permissions :** MINISTERE uniquement.

**Response Body :** Même format que `/users`, mais inclut toujours `document_legalite_hash`.

### 6. Enrôlement Délégué (Coopérative)
`POST /api/v1/auth/register-producer`
*Réservé aux coopératives pour inscrire leurs producteurs sans email.*

**Request Body :**
```json
{
  "fullName": "Koffi Mensah",
  "numeroTelephone": "+228 99 00 11 22",
  "location": "Région des Plateaux"
}
```
**Note :** Le mot de passe par défaut sera le numéro de téléphone. Le producteur est automatiquement rattaché à la coopérative appelante.

### 6. Gestion des Agents (Admin d'Organisation)
`POST /api/v1/auth/register-agent`
*Permet à l'admin d'une organisation (Export, Transfo, Ministère, Coop) de créer des comptes pour ses employés.*

**Request Body :**
```json
{
  "email": "agent@exportateur.com",
  "numeroTelephone": "+228 90 00 11 22",
  "fullName": "Agent Logistique 01",
  "password": "password123"
}
```
**Note :** L'agent hérite automatiquement du rôle et de l'organisation de l'administrateur qui le crée.

---

## 👤 Enregistrement d'Acteurs Officiels (Blockchain)

Cet endpoint permet d'officialiser un compte utilisateur sur la Blockchain. Sans cette étape, l'utilisateur ne peut pas signer de transactions (ex: créer un lot).

`POST /api/v1/actors/register`

**Permissions (Hiérarchie) :**
- **MINISTERE** : Peut enregistrer tout type d'acteur (Coopérative, Exportateur, etc.).
- **COOPERATIVE** : Peut enregistrer uniquement ses **PRODUCTEURs**.
- **Autres** : Accès refusé.

**Request Body :**
```json
{
  "actorIdHash": "PRODUCTEUR-XYZ", // blockchain_id de l'utilisateur
  "typeActeur": "PRODUCTEUR",      // [PRODUCTEUR, COOPERATIVE, EXPORTATEUR, etc.]
  "clePublique": "PEM_FORMAT_KEY", // Clé publique de l'utilisateur
  "orgName": "producteurs"         // Nom de l'organisation Fabric
}
```

---

## 📦 Gestion des Lots (PRODUCTEUR / COOPERATIVE)

### 1. Créer un Lot (Collecte)
`POST /api/v1/lots/` (Multipart Form Data)

**Form Fields :**
- `file`: (Binary) Image de la récolte
- `parcelle_id`: (String) ID de la parcelle enregistrée (ex: "PARC-001")
- `poids_kg`: (String) ex: "50.5"
- `espece`: (String) ex: "Forastero"
- `date_collecte`: (String) "YYYY-MM-DD"
- `coop_id`: (String, Optionnel) Rempli automatiquement si le producteur est rattaché à une coopérative.

**Note :** Le système récupère automatiquement les coordonnées GPS de la parcelle liée.

### 2. Récupérer un Lot
`GET /api/v1/lots/{lot_hash}`

### 3. Regrouper des lots (Bundle)
`POST /api/v1/traceability/bundles`

---

## 🔗 Opérations de Traçabilité (EXPORTATEUR / TRANSFORMATEUR)

### 1. Transfert de Propriété
`POST /api/v1/traceability/transfers`

```json
{
  "transferHash": "TRF-2026-001",
  "lotHashes": ["LOT-A", "LOT-B"],
  "expediteurId": "FARMER-01",
  "destinataireId": "COOP-01",
  "preuveHash": "sha256_du_reçu"
}
```

### 2. Transformation
`POST /api/v1/traceability/transformations`

```json
{
  "transformationHash": "TRANS-001",
  "lotHashes": ["LOT-A"],
  "typeProcessus": "FERMENTATION", // [FERMENTATION, SECHAGE, TORREFACTION]
  "preuveHash": "sha256_du_rapport"
}
```

### 3. Envoi International (Shipment)
`POST /api/v1/traceability/shipments`

---

## 📊 Audit & Vérification Public

### 1. Vérification par QR Code
`GET /api/v1/audit/verify/{lot_hash}`
*Endpoint public retournant le parcours simplifié.*

### 2. Rapport de Conformité EUDR
`GET /api/v1/audit/eudr-report/{lot_hash}`
*Génère les preuves de non-déforestation basées sur les coordonnées GPS immuables.*

---

## 📝 Modèles TypeScript (Interfaces)

```typescript
export interface GPS {
  latitude: number;
  longitude: number;
}

export interface User {
  email: string;
  fullName: string;
  role: 'PRODUCTEUR' | 'COOPERATIVE' | 'EXPORTATEUR' | 'CERTIF' | 'MINISTERE' | 'TRANSFORMATEUR';
  orgName: string;
  blockchainId: string;
}

export interface Lot {
  lotHash: string;
  farmerId: string;
  gps: GPS;
  poidsKg: number;
  espece: string;
  dateCollecte: string;
  mediaHash: string;
  coopId?: string;
  statut: 'COLLECTE' | 'EN_TRANSIT' | 'TRANSFORME' | 'EXPORTE' | 'REGROUPE';
}

export interface TraceabilityHistory {
  txId: string;
  timestamp: string;
  isDelete: boolean;
  value: any; // Dépend de l'actif
}

export interface EUDRReport {
  success: boolean;
  compliance_status: 'COMPLIANT' | 'NON_COMPLIANT' | 'UNKNOWN';
  data: {
    lot: Lot;
    history: TraceabilityHistory[];
    certifications: any[];
  };
}
```

---

## ⚠️ Codes d'Erreurs Communs

- `401 Unauthorized` : Token invalide ou expiré.
- `403 Forbidden` : L'utilisateur n'a pas le rôle requis pour cette action.
- `422 Unprocessable Entity` : Données envoyées invalides (format de date, type de nombre, etc.).
- `500 Internal Server Error` : Problème de connexion avec le réseau Blockchain.
