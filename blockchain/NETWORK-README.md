# 🌐 ChainCacao Network - Enterprise Architecture

Ce document détaille l'architecture et les procédures de déploiement de l'infrastructure Hyperledger Fabric (v2.5) pour le réseau ChainCacao.

## 🚀 Démarrage Rapide (Recommandé)

Pour déployer l'intégralité de l'infrastructure (Blockchain + Gateway + Backend) de manière automatisée, un script d'orchestration global *cross-platform* (Linux, Mac, Windows) est fourni à la racine du projet :

```bash
# Depuis la racine du projet ChainCacao
./start-all.sh
```

Ce script s'occupe de :
1. Installer les dépendances Docker si nécessaire.
2. Nettoyer et initialiser le réseau Fabric complet.
3. Créer le canal (`chaincacao-channel`).
4. Déployer le Smart Contract.
5. Lancer la Gateway Node.js et le Backend Python FastAPI.

Pour arrêter proprement l'ensemble des services :
```bash
./stop-all.sh
```

---

## 🛠️ Déploiement Granulaire (Mode Manuel)

Si vous souhaitez manipuler uniquement la blockchain pour le débogage, voici les commandes disponibles dans le dossier `blockchain/scripts` :

### 1. Téléchargement des binaires Fabric (Pré-requis)
```bash
cd blockchain/scripts
./bootstrap-fabric.sh 2.5.0 1.5.0
```

### 2. Réinitialisation Complète et Démarrage du Réseau
Démarre les conteneurs Docker (Orderer, Peers, CAs) et génère les certificats.
```bash
cd blockchain/scripts
./reset-network.sh
```

### 3. Étapes d'initialisation du Ledger
Une fois le réseau démarré, exécutez séquentiellement :
1. **Création du canal** : `./create-channel.sh`
2. **Déploiement du chaincode** : `./deploy-chaincode.sh`
3. **Vérification (Santé)** : `./health-check.sh` ou `./verify-network.sh`

---

## 🏗️ Architecture du Réseau

L'infrastructure est conçue pour la production avec **1 Orderer** (etcdraft) et **5 Organisations** représentant les acteurs clés de la filière :

*   **Orderer Node** : `orderer.chaincacao.com:7050`
*   **🏢 Ministère (`OrgMinistereMSP`)** : `peer0.ministere.chaincacao.com:10051`
*   **🧑‍🌾 Producteurs (`OrgProducteursMSP`)** : `peer0.producteurs.chaincacao.com:7051`
*   **🏭 Transformateurs (`OrgTransformateursMSP`)** : `peer0.transformateurs.chaincacao.com:11051`
*   **🚢 Exportateurs (`OrgExportateursMSP`)** : `peer0.exportateurs.chaincacao.com:8051`
*   **✅ Certificateurs (`OrgCertifMSP`)** : `peer0.certif.chaincacao.com:9051`

*(Chaque organisation possède 1 peer dans cette configuration).*

---

## 🔐 Gestion des Certificats et Identités

Contrairement aux environnements de développement classiques (utilisant `cryptogen`), ce réseau génère les certificats via des conteneurs **Fabric CA** :
- Chaque organisation possède son propre conteneur CA (`ca_producteurs`, `ca_ministere`, etc.).
- Les identités sont enregistrées et enrôlées de manière dynamique via `fabric-ca-client`.
- L'arborescence MSP est créée automatiquement.
- Les certificats TLS sont inclus dans le processus d'enrôlement.

---

## 🚨 Dépannage (Troubleshooting)

*   **Problème de bloc de Genèse (Genesis block)** : Vérifiez la configuration de consensus `etcdraft` dans `configtx.yaml`.
*   **Certificats manquants** : Les conteneurs CA doivent terminer leur initialisation. Vérifiez leurs logs : `docker logs ca_producteurs`.
*   **Échec de connexion entre les pairs** : Assurez-vous que les variables d'environnement dans les conteneurs pointent vers les bons certificats TLS. Vérifiez avec `docker logs <nom_du_peer>`.
*   **Ports indisponibles** : Assurez-vous que les ports 7050, 7051, 8051, 9051, 10051, 11051 ne sont pas déjà utilisés.
