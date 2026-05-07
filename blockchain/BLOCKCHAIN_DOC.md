# ⛓️ Documentation Blockchain - ChainCacao

Ce document décrit l'architecture et les fonctionnalités du Smart Contract (Chaincode) de la plateforme ChainCacao, conçue pour assurer une traçabilité totale et la conformité EUDR de la chaîne d'approvisionnement du cacao.

## 1. Architecture du Réseau (Hyperledger Fabric)
Le réseau est structuré autour de 5 organisations principales (MSPs) pour garantir une gouvernance décentralisée et sécurisée :
*   **🏢 Ministère (`OrgMinistereMSP`)** : Autorité de régulation, d'audit et de validation légale.
*   **🧑‍🌾 Producteurs & Coopératives (`OrgProducteursMSP`)** : Gèrent les agriculteurs, les parcelles, et enregistrent les premières récoltes et les regroupements.
*   **🏭 Transformateurs (`OrgTransformateursMSP`)** : Gèrent la transformation du cacao (ex: fermentation, séchage).
*   **🚢 Exportateurs (`OrgExportateursMSP`)** : Gèrent les expéditions internationales et l'export.
*   **✅ Certificateurs (`OrgCertifMSP`)** : Valident la conformité (Bio, Fairtrade, EUDR) des lots.

## 2. Fonctionnalités du Smart Contract (Chaincode)
Le chaincode est développé en Node.js et suit une architecture modulaire avancée (Séparation de la logique : `ActorLogic`, `LotLogic`, `TraceabilityLogic`, `ParcelleLogic`, `AuditLogic`).

### 🧑‍💼 Gestion des Acteurs et Identités
*   `RegisterActor` : Enregistrement hiérarchique contrôlé (ex: Le Ministère valide les coopératives, les coopératives valident leurs producteurs).
*   `GetActor` : Récupération des informations d'un acteur.

### 🌍 Gestion des Parcelles (Conformité EUDR)
*   `RegisterParcelle` : Enregistrement d'une parcelle agricole avec ses coordonnées GPS (géolocalisation).
*   `GetFarmerParcelles` : Récupération de toutes les parcelles d'un producteur.

### 🍫 Gestion des Lots et Regroupements
*   `CreateLot` : Création d'un lot initial lié à un producteur, une parcelle spécifique, et une coopérative.
*   `CreateBundle` : Regroupement de plusieurs lots en un seul (ex: au niveau de la coopérative).
*   `UpdateLotStatus` : Mise à jour du statut logistique d'un lot.
*   `AddCertification` : Ajout d'une certification technique ou de conformité (EUDR) par un certificateur à un lot.

### 🚚 Traçabilité, Transport et Transformation
*   `CreateTransfer` : Enregistrement du passage d'un lot d'un acteur à un autre, avec désignation d'un transporteur.
*   `CreateTransportEvent` : Enregistrement des événements logistiques intermédiaires (avec points de contrôle GPS).
*   `CreateTransformation` : Altération du cacao (ex: de fèves fraîches à fèves séchées) par un transformateur ou exportateur.
*   `CreateShipment` : Création d'une expédition internationale pour le client final.

### 🔍 Audit et Transparence
*   `GetHistoryForAsset` : Récupération de la piste d'audit immuable (historique complet des modifications d'un actif).
*   `QueryLotsByStatus` / `QueryCertifications` : Requêtes avancées sur l'état global du réseau.

## 3. Contrôle d'Accès (RBAC) & Confidentialité
*   **Contrôle Strict** : Le contrat vérifie le `MSPID` de l'appelant via le module `AccessControl` pour garantir que seules les entités autorisées peuvent exécuter certaines fonctions (ex: Seul un `PRODUCTEUR` peut créer un lot, seul un `EXPORTATEUR` peut expédier).
*   **Private Data Collections (PDC)** : L'architecture supporte le stockage de données sensibles dans des collections privées (ex: `collectionPrivateLots`) afin que seules les organisations autorisées (comme le Ministère ou les Exportateurs) puissent y accéder en clair, tandis que le hash reste sur le registre public.
