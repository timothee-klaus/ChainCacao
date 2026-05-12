#!/bin/bash
# Script utilitaire pour ajouter du SWAP à une VM Linux (Ubuntu/Debian)

if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root (utilisez sudo ./setup-swap.sh)"
  exit 1
fi

echo "Configuration de 4 Go de mémoire SWAP supplémentaire..."

# Vérifier si /swapfile existe déjà
if [ -f /swapfile ]; then
    echo "Le fichier /swapfile existe déjà. Suppression de l'ancien swap..."
    swapoff /swapfile
    rm /swapfile
fi

# Création du fichier
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile

# Ajout à fstab si absent
if ! grep -q "/swapfile" /etc/fstab; then
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

echo "SWAP configuré avec succès ! Voici l'état de votre mémoire :"
free -h
