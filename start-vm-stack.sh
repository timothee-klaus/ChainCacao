#!/bin/bash
# ChainCacao - Script de Lancement pour Serveur (VM)
# Déploie la Blockchain Fabric ET la Gateway Node.js

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Lancement de la Stack VM ChainCacao (Blockchain + Gateway) ===${NC}"

# Vérification de l'OS (La VM est normalement sous Linux)
if [ "$(uname -s)" != "Linux" ]; then
    echo -e "${RED}Attention: Ce script est optimisé pour être exécuté sur un serveur Linux (VM).${NC}"
fi

# Nettoyage du port 3000 (Gateway) si déjà utilisé
echo -e "${BLUE}Libération du port 3000...${NC}"
fuser -k 3000/tcp 2>/dev/null || true

# 1. Démarrage du Réseau Blockchain
echo -e "${GREEN}1. Initialisation du réseau Fabric...${NC}"
cd blockchain/scripts || { echo -e "${RED}Erreur: Dossier blockchain/scripts introuvable.${NC}"; exit 1; }
./reset-network.sh > setup-blockchain.log 2>&1
if [ $? -ne 0 ]; then echo -e "${RED}Erreur réseau (voir blockchain/scripts/setup-blockchain.log)${NC}"; exit 1; fi

# 2. Création du Canal
echo -e "${GREEN}2. Configuration du canal...${NC}"
./create-channel.sh >> setup-blockchain.log 2>&1
if [ $? -ne 0 ]; then echo -e "${RED}Erreur canal (voir blockchain/scripts/setup-blockchain.log)${NC}"; exit 1; fi

# 3. Déploiement du Smart Contract
echo -e "${GREEN}3. Déploiement du Smart Contract...${NC}"
./deploy-chaincode.sh >> setup-blockchain.log 2>&1
if [ $? -ne 0 ]; then echo -e "${RED}Erreur déploiement (voir blockchain/scripts/setup-blockchain.log)${NC}"; exit 1; fi

# 4. Lancement de la Gateway Node.js
echo -e "${GREEN}4. Lancement de la Gateway Node.js...${NC}"
cd ../gateway || { echo -e "${RED}Erreur: Dossier gateway introuvable.${NC}"; exit 1; }
npm install --quiet

# Utilisation de nohup pour que la Gateway tourne en tâche de fond même si tu quittes le terminal SSH
nohup npm start > gateway.log 2>&1 &
GATEWAY_PID=$!

echo -e "${BLUE}=== Stack VM Opérationnelle ===${NC}"
echo -e "✓ Blockchain déployée avec succès"
echo -e "✓ Gateway API en cours d'exécution (Port 3000, PID: $GATEWAY_PID)"
echo -e "${GREEN}Tu peux maintenant lier ton FastAPI (Railway) à http://[IP_DE_TA_VM]:3000${NC}"
