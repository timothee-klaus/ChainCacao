#!/bin/bash
# ChainCacao - Script de Lancement Production (Cross-Platform)

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=== Lancement de l'Infrastructure ChainCacao ===${NC}"

# Détection de l'OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    CYGWIN*|MINGW*|MSYS*) MACHINE=Windows;;
    *)          MACHINE="UNKNOWN:${OS}"
esac

echo -e "${BLUE}OS détecté : ${MACHINE}${NC}"

# Gestion de l'arrêt propre
cleanup() {
    echo -e "\n${BLUE}Arrêt des services...${NC}"
    if [ ! -z "$GATEWAY_PID" ]; then kill $GATEWAY_PID 2>/dev/null; fi
    if [ ! -z "$BACKEND_PID" ]; then kill $BACKEND_PID 2>/dev/null; fi
    echo -e "${GREEN}Services arrêtés proprement.${NC}"
    exit 0
}
trap cleanup SIGINT SIGTERM

# Installation des dépendances Docker si absentes
echo -e "${BLUE}Vérification des dépendances (Docker, Docker Compose)...${NC}"
if ! command -v docker &> /dev/null; then
    if [ "$MACHINE" == "Linux" ]; then
        echo -e "${BLUE}Docker introuvable. Installation en cours...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        rm get-docker.sh
        sudo usermod -aG docker $USER
        echo -e "${GREEN}Docker installé.${NC}"
        sudo systemctl start docker || true
        sudo systemctl enable docker || true
    else
        echo -e "${RED}Docker est introuvable. Sous Windows/Mac, veuillez installer Docker Desktop manuellement.${NC}"
        exit 1
    fi
fi

if ! command -v docker-compose &> /dev/null; then
    if [ "$MACHINE" == "Linux" ]; then
        echo -e "${BLUE}Docker Compose introuvable. Installation en cours...${NC}"
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        echo -e "${GREEN}Docker Compose installé.${NC}"
    else
        echo -e "${RED}Docker Compose est introuvable. Assurez-vous que Docker Desktop est lancé et installé.${NC}"
        exit 1
    fi
fi

# 0. Nettoyage des ports
echo -e "${BLUE}0. Libération des ports 3000 et 8000...${NC}"
if [ "$MACHINE" == "Linux" ] || [ "$MACHINE" == "Mac" ]; then
    fuser -k 3000/tcp 2>/dev/null || true
    fuser -k 8000/tcp 2>/dev/null || true
elif [ "$MACHINE" == "Windows" ]; then
    for port in 3000 8000; do
        # Trouver le PID utilisant le port
        PID=$(netstat -ano | grep ":$port " | awk '{print $5}' | head -n 1 | tr -d '\r')
        if [ ! -z "$PID" ] && [ "$PID" != "0" ]; then
            taskkill -F -PID $PID 2>/dev/null || true
        fi
    done
fi
sleep 1

# 1. Démarrage du Réseau Blockchain
echo -e "${GREEN}1. Initialisation du réseau Fabric (Enterprise Mode)...${NC}"
cd blockchain/scripts || { echo -e "${RED}Erreur: Dossier blockchain/scripts introuvable.${NC}"; exit 1; }
./reset-network.sh > setup.log 2>&1
if [ $? -ne 0 ]; then echo -e "${RED}Erreur réseau (voir blockchain/scripts/setup.log)${NC}"; exit 1; fi

# 2. Création du Canal
echo -e "${GREEN}2. Configuration du canal...${NC}"
./create-channel.sh >> setup.log 2>&1
if [ $? -ne 0 ]; then echo -e "${RED}Erreur canal (voir blockchain/scripts/setup.log)${NC}"; exit 1; fi

# 3. Déploiement du Smart Contract
echo -e "${GREEN}3. Déploiement du Smart Contract...${NC}"
./deploy-chaincode.sh >> setup.log 2>&1
if [ $? -ne 0 ]; then echo -e "${RED}Erreur déploiement (voir blockchain/scripts/setup.log)${NC}"; exit 1; fi

# 4. Lancement de la Gateway Node.js
echo -e "${GREEN}4. Lancement de la Gateway API...${NC}"
cd ../gateway || { echo -e "${RED}Erreur: Dossier gateway introuvable.${NC}"; exit 1; }
npm install --quiet
npm start > gateway.log 2>&1 &
GATEWAY_PID=$!
sleep 2 # Laisser quelques secondes à la gateway pour initialiser la connexion

# 5. Lancement du Backend FastAPI (Mode Production)
echo -e "${GREEN}5. Lancement du Backend FastAPI...${NC}"
cd ../../backend || { echo -e "${RED}Erreur: Dossier backend introuvable.${NC}"; exit 1; }

# Activation de l'environnement virtuel
if [ -d "../env" ]; then
    if [ "$MACHINE" == "Windows" ]; then
        source ../env/Scripts/activate
    else
        source ../env/bin/activate
    fi
else
    echo -e "${BLUE}Création de l'environnement virtuel Python...${NC}"
    if [ "$MACHINE" == "Windows" ]; then
        python -m venv ../env
        source ../env/Scripts/activate
    else
        python3 -m venv ../env
        source ../env/bin/activate
    fi
fi

# Installation des dépendances et lancement
if [ "$MACHINE" == "Windows" ]; then
    python -m pip install -r requirements.txt --quiet
    python -m uvicorn main:app --host 0.0.0.0 --port 8000 > backend.log 2>&1 &
else
    python3 -m pip install -r requirements.txt --quiet
    python3 -m uvicorn main:app --host 0.0.0.0 --port 8000 > backend.log 2>&1 &
fi
BACKEND_PID=$!

echo -e "${BLUE}=== Système opérationnel ===${NC}"
echo -e "API Swagger : ${GREEN}http://localhost:8000/docs${NC}"
echo -e "PIDs -> Gateway: $GATEWAY_PID | Backend: $BACKEND_PID"
echo -e "${RED}Appuyez sur Ctrl+C pour arrêter proprement tous les services.${NC}"

# Garder le script en vie pour intercepter Ctrl+C
wait
