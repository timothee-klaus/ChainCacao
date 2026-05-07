#!/bin/bash
# Script pour forcer l'arrêt de tous les services ChainCacao (Nettoyage complet)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Arrêt d'urgence et nettoyage ChainCacao ===${NC}"

# Détection OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*|MINGW*|MSYS*) MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo -e "${BLUE}1. Arrêt des serveurs Node (Gateway) et Python (Backend)...${NC}"
if [ "$MACHINE" == "Linux" ] || [ "$MACHINE" == "Mac" ]; then
    fuser -k 3000/tcp 2>/dev/null || true
    fuser -k 8000/tcp 2>/dev/null || true
elif [ "$MACHINE" == "Windows" ]; then
    for port in 3000 8000; do
        PID=$(netstat -ano | grep ":$port " | awk '{print $5}' | head -n 1 | tr -d '\r')
        if [ ! -z "$PID" ] && [ "$PID" != "0" ]; then
            taskkill -F -PID $PID 2>/dev/null || true
        fi
    done
fi
echo -e "${GREEN}Serveurs API arrêtés.${NC}"

echo -e "${BLUE}2. Arrêt du réseau Blockchain Docker...${NC}"
if [ -d "blockchain/network" ]; then
    cd blockchain/network
    docker-compose down -v 2>/dev/null || docker compose down -v 2>/dev/null || true
    cd ../..
fi

# Nettoyage forcé des conteneurs récalcitrants
echo -e "${BLUE}3. Nettoyage final des conteneurs isolés...${NC}"
docker rm -f ca_producteurs ca_exportateurs ca_certif ca_ministere ca_transformateurs ca_orderer 2>/dev/null || true
docker rm -f orderer.example.com peer0.producteurs.example.com peer0.exportateurs.example.com peer0.certif.example.com peer0.ministere.example.com peer0.transformateurs.example.com 2>/dev/null || true
docker rm -f cli 2>/dev/null || true

# Suppression des conteneurs de chaincode (Smart Contracts)
CC_CONTAINERS=$(docker ps -a | grep dev-peer0 | awk '{print $1}')
if [ ! -z "$CC_CONTAINERS" ]; then
    docker rm -f $CC_CONTAINERS 2>/dev/null || true
fi

echo -e "${GREEN}Réseau Blockchain arrêté et nettoyé.${NC}"
echo -e "${BLUE}=== Tous les processus sont arrêtés proprement ! ===${NC}"
