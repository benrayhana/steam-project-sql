# 🏗️ Conception de la base de données — Projet Steam

## 📌 Vue d’ensemble

Ce document présente les choix de conception de la base de données Steam.

L’objectif est de modéliser une plateforme de jeux vidéo sous forme relationnelle, en garantissant la cohérence des données, en évitant les redondances et en permettant des analyses SQL pertinentes.

---

## 🧱 Entités principales

### 🎮 JEU

Entité centrale de la base.

Contient :
- nom du jeu
- éditeur (clé étrangère)
- genre (clé étrangère)
- mode de jeu
- date de sortie
- prix
- évaluation globale

👉 Chaque jeu est associé à un seul éditeur et un seul genre.

---

### 👤 JOUEUR

Contient :
- nom du joueur
- date de création du compte
- pays

Représente les utilisateurs de la plateforme.

---

### 🏢 EDITEUR

Table de référence contenant les éditeurs uniques.

👉 Permet d’éviter la duplication des noms d’éditeurs.

---

### 🏷️ GENRE

Table de référence pour les catégories de jeux (FPS, RPG, etc.).

---

## 🔗 Tables de liaison

### 🛒 ACHAT

Relie un joueur à un jeu acheté.

**Champs :**
- id_achat (PK)
- id_joueur (FK)
- id_jeu (FK)
- date_achat

**Contrainte :**
- `UNIQUE (id_joueur, id_jeu)`  
→ Un joueur ne peut acheter un jeu qu’une seule fois

---

### ⏱️ TEMPS_JEU

Stocke le temps de jeu par joueur et par jeu.

**Champs :**
- id_temps (PK)
- id_joueur (FK)
- id_jeu (FK)
- heures_jouees

**Contraintes :**
- `UNIQUE (id_joueur, id_jeu)`  
→ Une seule ligne par joueur et par jeu

**Règle métier :**
- Un temps de jeu ne devrait exister que si le joueur possède le jeu  
→ Doit correspondre à un couple `(id_joueur, id_jeu)` présent dans `ACHAT`

---

### ⭐ AVIS

Stocke les avis des joueurs.

**Champs :**
- id_avis (PK)
- id_joueur (FK)
- id_jeu (FK)
- recommande (0 ou 1)
- commentaire
- date_avis

**Contrainte :**
- `CHECK (recommande IN (0,1))`  
→ Assure une valeur booléenne cohérente

---

## 🧩 Schéma relationnel

La base contient 7 tables, dont l'interdépendance peut être représentée à l'aide d'un diagramme Entite-Relation ci-dessus (créé à l'aide du site Mermaid Viewer) :

<img width="740" height="517" alt="image" src="https://github.com/user-attachments/assets/ebf83afe-9464-4885-a9ff-080d7d9fc13a" />

Les annotations (flèches) permettent de mieux comprendre la logique de ces interdépendances.


