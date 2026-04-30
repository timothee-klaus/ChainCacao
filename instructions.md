# Guide de Collaboration Interne - Groupe TG-23 (BeGeek)

Ce document définit les règles de développement et de collaboration pour le projet ChainCacao. Chaque membre de l'équipe est tenu de respecter ces consignes pour garantir la stabilité du système avant les échéances de la Phase 2 et de la Phase 3.

## 1. Organisation du Monorepo
Le dépôt est divisé en quatre zones techniques distinctes. Chaque membre est responsable de son répertoire :

- `/blockchain` : Smart Contracts (Java) et configuration réseau Hyperledger Fabric.
- `/backend` : API FastAPI, modèles de données PostgreSQL et logique métier.
- `/mobile` : Application de saisie terrain développée avec Flutter.
- `/web` : Tableau de bord de suivi développé avec React/Next.js.

## 2. Protocole Git et Workflow
Pour protéger la branche principale (main), nous utilisons le flux de travail suivant :

### Branchement
- La branche `main` contient uniquement du code fonctionnel et testé pour les démonstrations.
- Toute nouvelle fonctionnalité doit être développée sur une branche dédiée : `feature/nom-de-la-tache`.

### Cycle de travail quotidien
1. Mise à jour locale : `git checkout main` suivi de `git pull origin main`.
2. Création de branche : `git checkout -b feature/votre-tache`.
3. Développement : Travaillez exclusivement dans votre répertoire assigné.
4. Publication : `git push origin feature/votre-tache`.
5. Intégration : Ouvrez une Pull Request (PR) sur GitHub. La fusion dans `main` doit être validée par le responsable technique.

## 3. Initialisation des Projets
Chaque membre doit initialiser son framework à l'intérieur de son dossier respectif :
- Développeur Backend : Initialiser l'environnement virtuel Python dans `/backend`.
- Développeur Mobile : Créer le projet Flutter dans `/mobile`.
- Développeur Web : Initialiser le projet Next.js dans `/web`.
- Développeur Blockchain : Configurer le SDK Java dans `/blockchain`.

## 4. Objectifs pour la Phase 2 (Demi-finale)
Pour réussir cette phase, les composants suivants doivent être interconnectés :
- Prototype fonctionnel permettant l'enregistrement et le transfert d'un lot.
- Dépôt de code complet et documenté sur GitHub.
- Vidéo de démonstration montrant le flux complet (Producteur -> Coopérative -> Exportateur).

## 5. Communication et Suivi
- Utilisation de l'onglet "Projects" sur GitHub pour le suivi des tâches (Kanban).
- Points de synchronisation quotidiens pour identifier les blocages techniques.
- Les fichiers lourds (maquettes, documentation) doivent être placés dans le dossier `/docs`.

## 6. Scripts d'Automatisation
Toute commande complexe (lancement de conteneurs Docker, migration de base de données) doit être ajoutée sous forme de script dans le dossier `/scripts` afin que l'ensemble de l'équipe puisse reproduire l'environnement de test à l'identique.
