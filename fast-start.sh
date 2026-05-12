#!/bin/bash
# ChainCacao - Fast Restart Script (Keep Data)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Redémarrage Rapide ChainCacao (Conservation des données) ===${NC}"

# 1. Démarrer Docker
echo -e "${GREEN}1. Démarrage des conteneurs Docker...${NC}"
docker-compose -f blockchain/network/docker-compose.yaml up -d

# 2. Lancement Gateway
echo -e "${GREEN}2. Lancement de la Gateway API...${NC}"
cd blockchain/gateway
npm start > gateway.log 2>&1 &
GATEWAY_PID=$!

# 3. Lancement Backend
echo -e "${GREEN}3. Lancement du Backend FastAPI...${NC}"
cd ../../backend
# Utilisation du venv .venv
.\/.venv\/Scripts\/python.exe -m uvicorn main:app --host 0.0.0.0 --port 8000 > backend.log 2>&1 &
BACKEND_PID=$!

echo -e "${BLUE}=== Système opérationnel (Mode Persistant) ===${NC}"
echo -e "API Swagger : ${GREEN}http://localhost:8000/docs${NC}"
echo -e "PIDs -> Gateway: $GATEWAY_PID | Backend: $BACKEND_PID"
echo -e "Utilisez 'docker-compose -f blockchain/network/docker-compose.yaml stop' pour arrêter sans effacer."
