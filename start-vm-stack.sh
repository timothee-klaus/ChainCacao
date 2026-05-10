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

# Installation des dépendances Docker si absentes
echo -e "${BLUE}Vérification des dépendances (Docker, Docker Compose)...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${BLUE}Docker introuvable. Installation en cours...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    rm get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "${GREEN}Docker installé.${NC}"
    sudo systemctl start docker || true
    sudo systemctl enable docker || true
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${BLUE}Docker Compose introuvable. Installation en cours...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}Docker Compose installé.${NC}"
fi

# 1. Démarrage du Réseau Blockchain
echo -e "${GREEN}1. Initialisation du réseau Fabric...${NC}"
cd blockchain/scripts || { echo -e "${RED}Erreur: Dossier blockchain/scripts introuvable.${NC}"; exit 1; }
./reset-network.sh 2>&1 | tee setup-blockchain.log
if [ ${PIPESTATUS[0]} -ne 0 ]; then echo -e "${RED}Erreur réseau${NC}"; exit 1; fi

# 2. Création du Canal
echo -e "${GREEN}2. Configuration du canal...${NC}"
./create-channel.sh 2>&1 | tee -a setup-blockchain.log
if [ ${PIPESTATUS[0]} -ne 0 ]; then echo -e "${RED}Erreur canal${NC}"; exit 1; fi

# 3. Déploiement du Smart Contract
echo -e "${GREEN}3. Déploiement du Smart Contract...${NC}"
# Téléchargement manuel de l'image de compilation Node.js requise par le Peer
echo -e "${BLUE}Téléchargement de l'environnement de compilation Node.js pour le Smart Contract...${NC}"
sudo docker pull hyperledger/fabric-nodeenv:2.5

./deploy-chaincode.sh 2>&1 | tee -a setup-blockchain.log
if [ ${PIPESTATUS[0]} -ne 0 ]; then echo -e "${RED}Erreur déploiement${NC}"; exit 1; fi

# 4. Lancement de la Gateway Node.js
echo -e "${GREEN}4. Lancement de la Gateway Node.js...${NC}"
cd ../gateway || { echo -e "${RED}Erreur: Dossier gateway introuvable.${NC}"; exit 1; }
npm install --quiet

# Utilisation de nohup pour que la Gateway tourne en tâche de fond même si tu quittes le terminal SSH
nohup npm start > gateway.log 2>&1 &
GATEWAY_PID=$!

echo -e "\n${BLUE}=== Stack VM Opérationnelle ===${NC}"
echo -e "✓ Blockchain déployée avec succès"
echo -e "✓ Gateway API en cours d'exécution (Port 3000, PID: $GATEWAY_PID)"
echo -e "${GREEN}Tu peux maintenant lier ton FastAPI (Railway) à http://[IP_DE_TA_VM]:3000${NC}"
echo -e "${BLUE}Affichage des logs en direct (Appuie sur Ctrl+C pour quitter l'affichage, la Gateway continuera de tourner)...${NC}\n"

# Affiche les logs de la gateway en direct dans le terminal
tail -f gateway.log
