#!/bin/bash

# Script pour lancer la Gateway sur le réseau de TEST
echo "🚀 Lancement de la Gateway ChainCacao sur le réseau TEST (Port 3001)..."

# Chemin vers le dossier de la gateway
cd "$(dirname "$0")"

# Chargement des variables .env.test et lancement de node
# On utilise -r dotenv/config pour forcer le chargement de .env.test au démarrage
DOTENV_CONFIG_PATH=.env.test node index.js
