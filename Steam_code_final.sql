
-- On supprime les tables existantes pour voir réexéctuer le code après chaque modification :

DROP TABLE IF EXISTS avis;
DROP TABLE IF EXISTS temps_jeu;
DROP TABLE IF EXISTS achat;
DROP TABLE IF EXISTS jeu_import;
DROP TABLE IF EXISTS jeu;
DROP TABLE IF EXISTS joueur;
DROP TABLE IF EXISTS genre;
DROP TABLE IF EXISTS editeur;

/*  1ère étape : on créé une table temporaire du même nom que le fichier .csv,
 pour y stocker les informations du dataset principal puis les acheminer vers les tables correspondantes 
 On importe le .csv  :
*/ 
 
 CREATE TABLE jeu_import (
    nom_jeu TEXT,
    editeur TEXT,
    genre_principal TEXT,
    mode_jeu TEXT,
    date_sortie TEXT,
    prix_euro REAL,
    evaluation_globale TEXT
);

-- 2ème étape : création des tables fondamentales (structure) :

CREATE TABLE editeur (
    id_editeur INTEGER PRIMARY KEY,
    nom_editeur TEXT NOT NULL UNIQUE
);

CREATE TABLE genre (
    id_genre INTEGER PRIMARY KEY,
    nom_genre TEXT NOT NULL UNIQUE
);

CREATE TABLE jeu (
    id_jeu INTEGER PRIMARY KEY,
    nom_jeu TEXT NOT NULL,
    id_editeur INTEGER NOT NULL,
    id_genre INTEGER NOT NULL,
    mode_jeu TEXT NOT NULL,
    date_sortie DATE,
    prix_euro REAL,
    evaluation_globale TEXT NOT NULL,
    FOREIGN KEY (id_editeur) REFERENCES editeur(id_editeur),
    FOREIGN KEY (id_genre) REFERENCES genre(id_genre)
);

CREATE TABLE joueur (
    id_joueur INTEGER PRIMARY KEY,
    nom_joueur TEXT NOT NULL,
    date_creation_compte DATE,
    pays TEXT
);

CREATE TABLE achat (
    id_achat INTEGER PRIMARY KEY,
    id_joueur INTEGER NOT NULL,
    id_jeu INTEGER NOT NULL,
    date_achat DATE NOT NULL,
    FOREIGN KEY (id_joueur) REFERENCES joueur(id_joueur),
    FOREIGN KEY (id_jeu) REFERENCES jeu(id_jeu),
    UNIQUE (id_joueur, id_jeu)
);

CREATE TABLE temps_jeu (
    id_temps INTEGER PRIMARY KEY,
    id_joueur INTEGER NOT NULL,
    id_jeu INTEGER NOT NULL,
    heures_jouees REAL NOT NULL,
    FOREIGN KEY (id_joueur) REFERENCES joueur(id_joueur),
    FOREIGN KEY (id_jeu) REFERENCES jeu(id_jeu),
    UNIQUE (id_joueur, id_jeu)
);

CREATE TABLE avis (
    id_avis INTEGER PRIMARY KEY,
    id_joueur INTEGER NOT NULL,
    id_jeu INTEGER NOT NULL,
    recommande INTEGER NOT NULL CHECK (recommande IN (0,1)),
    commentaire TEXT,
    date_avis DATE,
    FOREIGN KEY (id_joueur) REFERENCES joueur(id_joueur),
    FOREIGN KEY (id_jeu) REFERENCES jeu(id_jeu)
);

-- 3ème étape : On remplit les données des tables qui sont référencées (FK) :

INSERT INTO editeur (nom_editeur)
SELECT DISTINCT editeur
FROM jeu_import
WHERE editeur IS NOT NULL
  AND TRIM(editeur) <> '';

INSERT INTO genre (nom_genre)
SELECT DISTINCT genre_principal
FROM jeu_import
WHERE genre_principal IS NOT NULL
  AND TRIM(genre_principal) <> '';

 /* Etape 4 : On bascule vers la table principale jeu, en y intégrant les références aux autres tables (clés étrangères) :
 On vérifie que les id référencés correspondent bien aux éditeurs et genre des différents jeux :
*/

INSERT INTO jeu (
    nom_jeu,
    id_editeur,
    id_genre,
    mode_jeu,
    date_sortie,
    prix_euro,
    evaluation_globale
)
SELECT
    ji.nom_jeu,
    e.id_editeur,
    g.id_genre,
    ji.mode_jeu,
    ji.date_sortie,
    ji.prix_euro,
    ji.evaluation_globale
FROM jeu_import ji
JOIN editeur e
    ON ji.editeur = e.nom_editeur
JOIN genre g
    ON ji.genre_principal = g.nom_genre
WHERE ji.nom_jeu IS NOT NULL
  AND TRIM(ji.nom_jeu) <> '';

-- Vérifications utiles
SELECT * FROM editeur;
SELECT * FROM genre;

--On supprime la table temporaire
DROP TABLE IF EXISTS jeu_import;

SELECT
    j.id_jeu,
    j.nom_jeu,
    e.nom_editeur,
    g.nom_genre,
    j.mode_jeu,
    j.date_sortie,
    j.prix_euro,
    j.evaluation_globale
FROM jeu j
JOIN editeur e ON j.id_editeur = e.id_editeur
JOIN genre g ON j.id_genre = g.id_genre;

/*Etape 5 :
A l'aide de l'IA, génératons de données fictives plausibles (respectant les contraintes définies pour chaque table),
et implémentation dans toutes les tables ne disposant pas encore de données
*/

INSERT INTO joueur (nom_joueur, date_creation_compte, pays) VALUES
('ShadowFox', '2021-03-15', 'France'),
('NeonBlade', '2020-07-22', 'Canada'),
('PixelHunter', '2019-11-05', 'Belgique'),
('DarkRaven', '2022-01-10', 'France'),
('CrimsonWolf', '2023-06-18', 'Suisse'),
('SilentStorm', '2021-12-25', 'Allemagne'),
('IronGhost', '2022-02-14', 'France'),
('NovaStrike', '2024-09-09', 'Espagne'),
('FrostByte', '2023-04-30', 'Italie'),
('VortexX', '2020-08-19', 'France'),

('NightCrawler', '2024-03-22', 'Pays-Bas'),
('AlphaZero', '2021-05-05', 'Royaume-Uni'),
('CyberKnight', '2022-10-10', 'France'),
('OmegaPulse', '2023-07-07', 'Suède'),
('BlazeRunner', '2020-02-29', 'France'),
('GoldenEagle', '2015-03-03', 'États-Unis'),
('RedShadow', '2021-01-21', 'France'),
('DarkKnight', '2019-06-06', 'Allemagne'),
('NovaPlayer', '2018-08-18', 'Canada'),
('ZeroCool', '2016-12-24', 'Australie');

INSERT INTO achat (id_joueur, id_jeu, date_achat) VALUES
(1, 45, '2021-03-15'),
(2, 78, '2022-07-21'),
(3, 12, '2020-11-05'),
(4, 63, '2023-01-10'),
(5, 17, '2024-06-18'),
(6, 89, '2021-12-25'),
(7, 34, '2022-02-14'),
(8, 90, '2025-09-09'),
(9, 51, '2023-04-30'),
(10, 11, '2020-08-19'),

(11, 66, '2024-03-22'),
(12, 25, '2021-05-05'),
(13, 88, '2022-10-10'),
(14, 42, '2023-07-07'),
(15, 72, '2020-02-29'),
(16, 30, '2025-01-01'),
(17, 94, '2021-09-13'),
(18, 16, '2022-12-12'),
(19, 70, '2023-06-06'),
(20, 7, '2024-11-11'),

(1, 85, '2022-03-03'),
(2, 19, '2023-08-08'),
(3, 61, '2021-04-04'),
(4, 13, '2020-10-10'),
(5, 24, '2025-02-02'),
(6, 97, '2024-05-05'),
(7, 6, '2023-09-09'),
(8, 28, '2022-06-06'),
(9, 83, '2021-01-01'),
(10, 99, '2020-12-12'),

(11, 8, '2024-07-07'),
(12, 54, '2023-03-03'),
(13, 5, '2022-08-18'),
(14, 77, '2021-11-11'),
(15, 9, '2020-06-06'),
(16, 20, '2025-03-15'),
(17, 31, '2024-01-20'),
(18, 2, '2023-02-02'),
(19, 86, '2022-04-04'),
(20, 12, '2021-07-07'),

(3, 47, '2024-09-09'),
(6, 1, '2023-05-05'),
(9, 18, '2022-01-15'),
(12, 30, '2025-04-01'),
(15, 93, '2020-09-09'),
(18, 21, '2021-10-10'),
(2, 4, '2023-11-11'),
(5, 10, '2024-08-08'),
(7, 95, '2022-12-24'),
(10, 16, '2021-06-30');


INSERT INTO temps_jeu (id_joueur, id_jeu, heures_jouees) VALUES
(1, 45, 412.5),
(2, 78, 96.0),
(3, 12, 1287.4),
(4, 63, 54.5),
(5, 17, 221.8),
(6, 89, 1733.2),
(7, 34, 88.7),
(8, 90, 640.9),
(9, 51, 311.6),
(10, 11, 27.4),

(11, 66, 145.2),
(12, 25, 903.7),
(13, 88, 67.1),
(14, 42, 284.0),
(15, 72, 4921.3),
(16, 30, 16.8),
(17, 94, 775.6),
(18, 16, 39.5),
(19, 70, 118.2),
(20, 7, 2504.1),

(1, 85, 73.9),
(2, 19, 4120.0),
(3, 61, 205.7),
(4, 13, 14.2),
(5, 24, 682.6),
(6, 97, 91.4),
(7, 6, 1577.9),
(8, 28, 43.0),
(9, 83, 352.8),
(10, 99, 4999.0),

(11, 8, 8.5),
(12, 54, 244.3),
(13, 5, 1322.6),
(14, 77, 59.9),
(15, 9, 401.2),
(16, 20, 2999.7),
(17, 31, 120.6),
(18, 2, 6.0),
(19, 86, 845.4),
(20, 12, 188.9),

(3, 47, 71.3),
(6, 1, 2560.2),
(9, 18, 97.8),
(12, 30, 11.4),
(15, 93, 4300.6),
(18, 21, 62.7),
(2, 4, 1405.5),
(5, 10, 24.8),
(7, 95, 319.4),
(10, 16, 212.1);

INSERT INTO avis (id_joueur, id_jeu, recommande, commentaire, date_avis) VALUES
(1, 45, 1, 'Très bon', '2021-04-01'),
(2, 78, 0, 'Bof', '2022-08-01'),
(3, 12, 1, 'Excellent', '2020-12-01'),
(5, 17, 1, 'Addictif', '2024-07-01'),
(7, 34, 0, 'Décevant', '2022-03-01');

/* Il peut être utile de représenter les achats enregistrés sur la plateforme,
grâce à un groupement par joueur :
*/
SELECT
    id_joueur,
    id_jeu,	
    date_achat
FROM achat
ORDER BY id_joueur, date_achat;

-- Phase de requêtes afin d'analyser les données, et répondre à nos problématiques :

/*ANALYSE : Performance des Éditeurs
-- Objectif : Identifier l'entreprise qui domine le marché en volume de ventes.
   Quel éditeur a vendu le plus de jeux (en volume) ?
*/

SELECT 
    E.nom_editeur, 
    COUNT(A.id_achat) AS nombre_ventes
FROM EDITEUR E
JOIN JEU J ON E.id_editeur = J.id_editeur
JOIN ACHAT A ON J.id_jeu = A.id_jeu
GROUP BY E.id_editeur
ORDER BY nombre_ventes DESC
LIMIT 1;

-- Quel jeu a accumulé le plus d'heures de jeu au total ?
SELECT 
    J.nom_jeu, 
    SUM(T.heures_jouees) AS total_heures
FROM JEU J
JOIN TEMPS_JEU T ON J.id_jeu = T.id_jeu
GROUP BY J.id_jeu
ORDER BY total_heures DESC
LIMIT 1;

-- Quel genre de jeu a la moyenne de temps de jeu la plus élevée par joueur ?
SELECT 
    G.nom_genre, 
    ROUND(AVG(T.heures_jouees), 1) AS moyenne_heures_par_jeu
FROM GENRE G
JOIN JEU J ON G.id_genre = J.id_genre
JOIN TEMPS_JEU T ON J.id_jeu = T.id_jeu
GROUP BY G.nom_genre
ORDER BY moyenne_heures_par_jeu DESC;