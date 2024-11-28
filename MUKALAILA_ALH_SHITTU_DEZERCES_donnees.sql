DEALLOCATE event_par_nom;
DEALLOCATE event_par_mot_cle;
DEALLOCATE event_par_nom_lieu;
DEALLOCATE event_par_ville;
DEALLOCATE event_par_acces_pmr;
DEALLOCATE event_par_programme;
DEALLOCATE event_par_groupe;
DEALLOCATE event_par_dates;

-- Rechercher des evenements par leur nom
PREPARE event_par_nom(text) AS
SELECT id, titre FROM Evenement WHERE titre = $1;

-- Rechercher des evenements par mot cle
PREPARE event_par_mot_cle(text) AS
SELECT id, titre FROM Evenement WHERE id IN (SELECT id FROM contient WHERE mots_cles = $1);

-- Rechercher des evenements par le nom du lieu
PREPARE event_par_nom_lieu(text) AS
SELECT id, titre FROM Lieu NATURAL JOIN Evenement WHERE nom_du_lieu = $1;

-- Rechercher des evenements par ville
PREPARE event_par_ville(text) AS
SELECT id, titre FROM Lieu NATURAL JOIN Evenement WHERE nom_ville = $1;

-- Rechercher des evenements par acces p:r
PREPARE event_par_acces_pmr(BOOLEAN) AS
SELECT id, titre FROM Lieu NATURAL JOIN Evenement WHERE acces_pmr = $1;

-- Rechercher des evenements par programme
PREPARE event_par_programme(text) AS
SELECT id, titre FROM Evenement WHERE programme = $1;

-- Rechercher des evenements par groupe
PREPARE event_par_groupe(text) AS
SELECT id, titre FROM Evenement WHERE groupe = $1;

-- Rechercher des evenements dans une tranche de dates
PREPARE event_par_dates(TIMESTAMP, TIMESTAMP) AS
SELECT id, titre FROM Evenement WHERE date_de_debut BETWEEN $1 AND $2 OR date_de_fin BETWEEN $1 AND $2;


\prompt 'Nom de l evenement : Amina Mezaache & Maracuja' event_nom
EXECUTE event_par_nom('Amina Mezaache & Maracuja');

\prompt 'Mot cle : Cinéma' event_mot_cle
EXECUTE event_par_mot_cle('Cinéma');

\prompt 'Nom du lieu : Bibliothèque Claude Lévi-Strauss' lieu_nom
EXECUTE event_par_nom_lieu('Bibliothèque Claude Lévi-Strauss');

\prompt 'Nom de la ville : Montreuil' lieu_ville
EXECUTE event_par_ville('Montreuil');

\prompt 'Acces pmr : false' event_acces
EXECUTE event_par_acces_pmr(0::BOOLEAN);

\prompt 'Programme : 16h04 (https://www.paris.fr/evenements/16h04-25301)' event_programme
EXECUTE event_par_programme('16h04 (https://www.paris.fr/evenements/16h04-25301)');

\prompt 'Nom du groupe : Activités DJS' event_groupe
EXECUTE event_par_groupe('Activités DJS');

\prompt 'Date debut et fin : 2024-02-25 / 2024-02-27' event_date_debut
EXECUTE event_par_dates('2024-02-25'::TIMESTAMP, '2024-02-27'::TIMESTAMP);