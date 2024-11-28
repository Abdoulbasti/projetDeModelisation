\prompt '1ere Requete : Evenement donnees manquante.' i
SELECT id, titre, type_de_prix, type_d_acces, longitude, latitude
FROM Evenement
WHERE url = '' OR titre = '' OR type_de_prix = 'inconnu' OR type_d_acces = 'inconnu' OR longitude = '' OR latitude = '';

\prompt '2eme Requete : Evenement probleme de date.' i
SELECT id, date_de_debut, date_de_fin, date_de_mise_a_jour
FROM Evenement
WHERE date_de_debut IS NULL OR date_de_fin IS NULL OR date_de_debut > date_de_fin OR date_de_mise_a_jour > CURRENT_DATE;

\prompt '3eme Requete : Lieu donnees manquante (1/2).' i
SELECT longitude, latitude, nom_du_lieu, adresse_du_lieu, code_postal, nom_ville
FROM Lieu
WHERE nom_du_lieu = '' OR adresse_du_lieu = '' OR code_postal = '' OR nom_ville = '';

\prompt '4eme Requete : Lieu donnees manquante (2/2).' i
SELECT longitude, latitude, acces_pmr, acces_mal_voyant, acces_mal_entendant
FROM Lieu
WHERE acces_pmr IS NULL OR acces_mal_voyant IS NULL OR acces_mal_entendant IS NULL;

\prompt '5eme Requete : Groupe verification.' i
SELECT id, groupe
FROM Evenement
WHERE groupe NOT IN (SELECT groupe FROM GROUPE);

\prompt '6eme Requete : Check telephone.' i
SELECT id, telephone_de_contact
FROM Evenement
WHERE 
    (telephone_de_contact <> '' AND NOT telephone_de_contact ~ '^\+[0-9]{1,3}[0-9]{9,14}$');

\prompt '7eme Requete : Check email.' i
SELECT id, email_de_contact
FROM Evenement
WHERE 
    (email_de_contact <> '' AND NOT email_de_contact ~* '^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

\prompt '8eme Requete : Check url  (1/3).' i
SELECT id, url, url_de_contact
FROM Evenement
WHERE 
    (url <> '' AND NOT url ~* '^https:\/\/www\.paris\.fr\/evenements\/.*$')
    OR (url_de_contact <> '' AND NOT url_de_contact ~* '^https?:\/\/.*$');

\prompt '9eme Requete : Check url  (2/3).' i
SELECT id, url_facebook_associee, url_twitter_associee
FROM Evenement
WHERE 
    ((url_facebook_associee IS NOT NULL AND url_facebook_associee <> '' AND NOT url_facebook_associee ~* '^(https:\/\/)(.*)(facebook|fb).*$')
    OR (url_twitter_associee IS NOT NULL AND url_twitter_associee <> '' AND NOT url_twitter_associee ~* '^(https:\/\/)(www\.)?((twitter\.com\/)|(x\.com\/)).*$'));

\prompt '10eme Requete : Check url  (3/3).' i
SELECT id, url_de_l_image, url_de_reservation
FROM Evenement
WHERE 
    (url_de_l_image <> '' AND NOT url_de_l_image ~* '^https:\/\/cdn\.paris\.fr\/qfapv4\/.*$')
    OR (url_de_reservation IS NOT NULL AND url_de_reservation <> '' AND NOT url_de_reservation ~* '^https?:\/\/.*$');
    
    
