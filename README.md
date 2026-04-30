# ChainCacao - Plateforme de Traçabilité Blockchain de la Filière Café-Cacao au Togo

## Présentation du Projet
Le projet ChainCacao répond à une problématique critique pour l'économie togolaise : l'incapacité actuelle à prouver l'origine et la conformité de la production de café et de cacao. Cette filière soutient plus de 40 000 familles et contribue à 1,4% du PIB national. L'entrée en vigueur du règlement européen EUDR (EU Deforestation Regulation) en 2025 impose désormais une traçabilité géographique obligatoire pour maintenir l'accès au marché de l'Union Européenne.

## Problématique Centrale
Le système actuel souffre d'un manque de transparence dû à une chaîne fragmentée comportant 4 à 6 intermédiaires non tracés. Cette opacité entraîne plusieurs conséquences majeures :
- Les agriculteurs ne perçoivent que 15% à 25% de la valeur finale du produit.
- Les fraudes sur les pesées génèrent des pertes estimées entre 30 et 40 millions USD par an.
- Moins de 5% des exportations sont actuellement certifiées (Bio, Fairtrade) faute de preuves de traçabilité.

## Solution Technique
ChainCacao utilise la blockchain permissionnée Hyperledger Fabric pour créer un registre immuable et transparent. Le système garantit l'intégrité absolue des données de provenance et de certification sans dépendre d'une autorité centrale unique.

### Architecture du Dépôt (Monorepo)
Le projet est structuré pour permettre une collaboration fluide entre les différentes couches techniques :
- /blockchain : Chaincodes (Smart Contracts) développés en Java et configuration du réseau Hyperledger Fabric.
- /backend : API REST développée avec FastAPI (Python) assurant le lien entre les applications et la blockchain.
- /mobile : Application de collecte terrain développée avec Flutter pour les agriculteurs et coopératives.
- /web : Interface d'administration et de consultation développée avec React/Next.js pour les exportateurs et autorités.
- /scripts : Scripts d'automatisation pour le déploiement et la gestion des conteneurs Docker.
- /docs : Documentation technique, schémas d'architecture et livrables du hackathon.

## Fonctionnalités Principales
- Enregistrement des lots : Saisie de l'origine GPS, du poids, de l'espèce et de la date de récolte.
- Suivi logistique : Traçabilité des transferts entre producteurs, coopératives, transporteurs et exportateurs.
- Conformité EUDR : Génération de preuves géographiques et de certificats de non-déforestation immuables.
- Vérification instantanée : Consultation de l'historique complet d'un lot via un QR Code unique.

## Stack Technologique
- Blockchain : Hyperledger Fabric (Consensus Raft, Infrastructure PKI).
- Backend : FastAPI, PostgreSQL (Données hors-chaîne), Docker.
- Frontend : Flutter (Mobile), React/Next.js (Web).
- Langages : Java, Python, Dart, JavaScript.

## Installation et Déploiement
Les instructions détaillées pour lancer le réseau blockchain et les services applicatifs se trouvent dans les fichiers README respectifs de chaque dossier. Pour un lancement rapide de l'environnement de développement :
1. Cloner le dépôt.
2. Exécuter le script de démarrage global : `./scripts/start_all.sh`.

## Équipe TG-23 (BeGeek)
Projet développé dans le cadre du MIABE HACKATHON 2026.
- Développeur Blockchain : KPATOU Pierre-Paul
- Développeur Backend : NOVIVO Othniella Leatitia
- Développeur Web : DIMON Oyetounde Ange
- Développeur Mobile : KOUMONDJI H. Timothée Klaus
