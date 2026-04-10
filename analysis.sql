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
