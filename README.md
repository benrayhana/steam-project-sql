# 🎮 Projet SQL — Modélisation d’une base de données Steam

## 📌 Présentation du projet

Ce projet a été réalisé dans le cadre d’un cours de SQL en Master 1 (parcours DS2E) à l'Université de Strasbourg. 
Il consiste en la conception et l'implémentation d'une base de données relationnelle en SQL (SQLite), cherchant à représenter une version simplifiée de la plateforme Steam.

Steam est une plateforme majeure de distribution de jeux vidéo sur PC, avec des millions d’utilisateurs et des dizaines de milliers de jeux.  
L’objectif est de modéliser les différentes entités y intéragissant ainsi que les fonctionnalités principales de la plateforme : jeux, joueurs, éditeurs, achats, temps de jeu et avis.

---

## 🎯 Objectifs

- Concevoir un schéma de base de données relationnelle cohérent
- Implémenter ce schéma en SQLite avec des contraintes d’intégrité
- Importer des données réelles via un fichier CSV
- Générer des données fictives réalistes
- Exploiter les données via des requêtes SQL, servant ainsi de prémice à des analyses variées (études de marché, comportement des joueurs, ...)

---

## 👥 Utilisateurs cibles

Cette base de données peut être utilisée par :

- Des analystes de données → analyser le comportement des joueurs
- Des éditeurs de jeux → suivre les ventes et l’engagement de leurs jeux commercialisés
- Des gestionnaires de plateforme → comprendre l’usage global et stocker les données de manière cohérente et structurée

---

## 📊 Sources de données

Données réelles issues d’un fichier CSV relatant des différents jeux et éditeurs présents sur le marché ainsi qu'un certain nombre de leurs différentes caractérstiques.
Le fichier originel (steam_db_original) a ensuite été nettoyé, ordonné, simplifié, sous-échantillonné et traduit (jeu_import) afin d'en faciliter l'utilisation et la présentation dans le cadre du projet 

Données fictives générées à l'aide de requêtes LLM pour comptabiliser et modéliser de manière réaliste (contraintes explicitées) :
les joueurs (profils), les achats, le temps de jeu, les avis

---

## ⚙️ Fonctionnement global

1. Import du CSV dans une table temporaire (`jeu_import`)
2. Extraction des valeurs uniques (éditeurs, genres)
3. Insertion des données dans la table principale (`JEU`) via des jointures
4. Ajout de données fictives dans les autres tables
5. Analyse via requêtes SQL

---

## 🗂️ Structure du projet

- `schema.sql` → création et remplissage de la base
- `README.md` → présentation du projet
- `DESIGN.md` → document de conception

---

## 👨‍💻 Auteurs

- Antoine Pacchioni  
- Yaye Fatou Gnigue  
- Rayhana Ben Him  
(M1 DS2E — Université de Strasbourg)

---

## ⚠️ Remarques

- Base de données réalisée sous SQLite
- Certaines contraintes métier (ex : lien achat → temps de jeu) sont définies conceptuellement mais non entièrement implémentées en SQL

---
