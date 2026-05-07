# 🌊 Architecture et Flux du Système ChainCacao

Ce document décrit les différents flux de données et processus métiers actuellement implémentés dans la plateforme ChainCacao. Le système vise à garantir la traçabilité complète de la filière Cacao au Togo, de la parcelle jusqu'à l'exportation, en conformité avec la réglementation européenne (EUDR).

---

## 1. Flux d'Identité et d'Enrôlement (Onboarding)

Le système repose sur un accès hiérarchisé et validé par l'État (via le Ministère).

*   **Inscription Publique (Producteurs) :**
    1. Un producteur soumet ses informations (nom, contact, rôle `PRODUCTEUR`) via `/api/v1/auth/register`.
    2. Son compte est créé localement (en attente de validation).
    3. Une **Coopérative** valide son profil, ce qui déclenche son enregistrement officiel sur la Blockchain (via `/api/v1/actors/register`).
*   **Création Déléguée (Coopératives / Entreprises) :**
    1. Un administrateur de coopérative peut inscrire un producteur sans email (via `/api/v1/auth/register-producer`).
    2. Un administrateur (Export, Certif) peut créer des comptes pour ses employés (`/api/v1/auth/register-agent`).
*   **Enrôlement Institutionnel et Validation :**
    1. Les acteurs majeurs (Coopératives, Exportateurs, Certificateurs) s'inscrivent en fournissant une **Preuve de Légalité** documentaire.
    2. Le Ministère liste les inscriptions en attente (`/api/v1/auth/pending-registrations`).
    3. Une fois vérifié, l'acteur est officiellement enregistré sur la Blockchain via l'enrôlement CA (`/api/v1/actors/register`). Il reçoit ses clés cryptographiques pour signer ses futures transactions.

---

## 2. Flux de Production (La Récolte)

C'est le point d'entrée de la fève de cacao dans la blockchain.

1.  **Déclaration de la Parcelle :**
    *   L'agriculteur (ou la coopérative) enregistre la localisation (GPS) et les détails de sa parcelle via `/api/v1/parcelles/`.
2.  **Création du Lot (Collecte) :**
    *   Lors de la récolte, le producteur déclare un nouveau lot (`POST /api/v1/lots/`).
    *   Il transmet une photo (preuve visuelle), le poids, l'espèce et l'ID de la parcelle d'origine.
    *   **Action système :** Le backend génère un identifiant unique (ex: `LOT-20260502-XXX`), stocke l'image, calcule son hash SHA-256, et inscrit le lot dans le Smart Contract Hyperledger Fabric. Les coordonnées GPS sont liées de manière immuable au lot.

---

## 3. Flux Logistique et de Transformation (Supply Chain)

Une fois le lot créé, il parcourt la chaîne logistique. Chaque étape ajoute un bloc à l'historique de la blockchain.

1.  **Transfert de Propriété :**
    *   Le lot passe du Producteur à la Coopérative, puis de la Coopérative à l'Exportateur (`POST /api/v1/traceability/transfers`).
    *   L'opération requiert la signature de l'expéditeur et du destinataire, avec l'empreinte cryptographique (hash) du reçu physique.
2.  **Regroupement (Bundling) :**
    *   Les coopératives regroupent souvent plusieurs petits lots de différents producteurs en un grand lot pour optimiser le transport (`POST /api/v1/traceability/bundles` / `regroup`).
    *   Le lot parent hérite des caractéristiques géographiques (GPS) de tous ses sous-lots pour la conformité EUDR.
3.  **Transformation :**
    *   Un lot peut subir des processus (Fermentation, Séchage, Torréfaction) déclarés par le Transformateur ou l'Exportateur (`POST /api/v1/traceability/transformations`).

---

## 4. Flux d'Exportation et de Conformité (EUDR)

L'aboutissement du cycle est la préparation à l'exportation vers le marché international.

1.  **Envoi International (Shipment) :**
    *   L'Exportateur déclare l'envoi (`POST /api/v1/traceability/shipments`) en joignant les hashs des documents de douane. Les lots sont marqués comme `EXPORTE`.
2.  **Génération du Rapport EUDR :**
    *   À l'arrivée (ex: douanes européennes), les autorités requêtent le backend (`GET /api/v1/audit/eudr-report/{lot_hash}`).
    *   **Action système :** Le système agrège l'historique complet du lot, ses certifications, et vérifie que ses coordonnées GPS d'origine ne correspondent pas à des zones déforestées. Le statut de conformité (`COMPLIANT` ou `NON_COMPLIANT`) est retourné.
3.  **Vérification Consommateur (QR Code) :**
    *   Le consommateur final scanne le QR code du produit.
    *   Le flux appelle un endpoint public (`GET /api/v1/audit/verify/{lot_hash}`) pour afficher l'histoire du cacao, certifiée par la blockchain, de la coopérative jusqu'à l'exportation.
