DROP TABLE IF EXISTS contient CASCADE;
DROP TABLE IF EXISTS Evenement CASCADE;
DROP TABLE IF EXISTS Lieu CASCADE;
DROP TABLE IF EXISTS AdressEn CASCADE;
DROP TABLE IF EXISTS Reservation CASCADE;
DROP TABLE IF EXISTS Image CASCADE;
DROP TABLE IF EXISTS Groupe CASCADE;
DROP TABLE IF EXISTS Mots_cles CASCADE;

DROP TYPE IF EXISTS t_type_de_prix;
DROP TYPE IF EXISTS t_type_d_acces;



CREATE TABLE Mots_cles(
    mots_cles TEXT,
    PRIMARY KEY(mots_cles)
);


CREATE TABLE Groupe(
    groupe TEXT,
    PRIMARY KEY(groupe)
);


CREATE TABLE Image(
    url_de_l_image TEXT,
    texte_alternatif_de_l_image TEXT,
    credit_de_l_image TEXT,
    PRIMARY KEY(url_de_l_image)
);
CREATE INDEX dx_image ON Image USING HASH (url_de_l_image);

CREATE TABLE Reservation(
    url_de_reservation TEXT,
    url_de_reservation_texte TEXT,
    PRIMARY KEY(url_de_reservation)
);
CREATE INDEX dx_reservation ON Reservation USING HASH (url_de_reservation);

CREATE TABLE AdressEn(
    en_ligne_adress_url TEXT,
    en_ligne_adress_url_text TEXT,
    en_ligne_adress_text TEXT,
    PRIMARY KEY(en_ligne_adress_url)
);
CREATE INDEX dx_adress_en ON AdressEn USING HASH (en_ligne_adress_url);

CREATE TABLE Lieu(
    longitude TEXT,
    latitude TEXT,
    nom_du_lieu TEXT NOT NULL,
    adresse_du_lieu TEXT NOT NULL,
    code_postal TEXT NOT NULL,
    nom_ville TEXT NOT NULL,
    acces_pmr BOOLEAN,
    acces_mal_voyant BOOLEAN,
    acces_mal_entendant BOOLEAN,
    PRIMARY KEY(longitude, latitude)
);
CREATE INDEX dx_lieu_long ON Lieu USING HASH (longitude);
CREATE INDEX dx_lieu_lat ON Lieu USING HASH (latitude);
CREATE INDEX dx_lieu_nom_lieu ON Lieu USING HASH (nom_du_lieu);
CREATE INDEX dx_lieu_addresse ON Lieu USING HASH (adresse_du_lieu);
CREATE INDEX dx_lieu_code_postal ON Lieu USING HASH (code_postal);
CREATE INDEX dx_lieu_ville ON Lieu USING HASH (nom_ville);
CREATE INDEX dx_lieu_pmr ON Lieu USING HASH (acces_pmr);
CREATE INDEX dx_lieu_voyant ON Lieu USING HASH (acces_mal_voyant);
CREATE INDEX dx_lieu_entendant ON Lieu USING HASH (acces_mal_entendant);

CREATE TYPE t_type_d_acces AS ENUM ('conseillée', 'non', 'obligatoire', 'inconnu');
CREATE TYPE t_type_de_prix AS ENUM ('gratuit', 'gratuit sous condition', 'payant', 'inconnu');
CREATE TABLE Evenement(
    id INT,
    url TEXT NOT NULL,
    titre TEXT NOT NULL,
    chapeau TEXT,
    description TEXT,
    date_de_debut TIMESTAMP,
    date_de_fin TIMESTAMP,
    description_de_la_date TEXT,
    type_de_prix t_type_de_prix NOT NULL,
    detail_du_prix TEXT,
    type_d_acces t_type_d_acces NOT NULL,
    date_de_mise_a_jour TIMESTAMP,
    image_de_couverture TEXT,
    programme TEXT,
    title_event TEXT,
    childrens TEXT,
    audience TEXT,
    groupe TEXT NOT NULL,

    url_de_contact TEXT,
    telephone_de_contact TEXT,
    email_de_contact TEXT,
    url_facebook_associee TEXT,
    url_twitter_associee TEXT,

    url_de_reservation TEXT,
    url_de_l_image TEXT,
    en_ligne_adress_url TEXT,
    longitude TEXT NOT NULL,
    latitude TEXT NOT NULL,
    PRIMARY KEY(id)
);
CREATE INDEX dx_evenement_id ON Evenement USING HASH (id);
CREATE INDEX dx_evenement_titre ON Evenement USING HASH (titre);
CREATE INDEX dx_evenement_prix ON Evenement USING HASH (type_de_prix);
CREATE INDEX dx_evenement_acces ON Evenement USING HASH (type_d_acces);
CREATE INDEX dx_evenement_groupe ON Evenement USING HASH (groupe);
CREATE INDEX dx_evenement_programme ON Evenement USING HASH (programme);
CREATE INDEX dx_evenement_long ON Evenement USING HASH (longitude);
CREATE INDEX dx_evenement_lat ON Evenement USING HASH (latitude);
CREATE INDEX dx_evenement_image ON Evenement USING HASH (url_de_l_image);
CREATE INDEX dx_evenement_reservation ON Evenement USING HASH (url_de_reservation);
CREATE INDEX dx_evenement_adress_en ON Evenement USING HASH (en_ligne_adress_url);
CREATE INDEX dx_evenement_date_debut ON Evenement (date_de_debut);
CREATE INDEX dx_evenement_date_fin ON Evenement (date_de_fin);
CREATE INDEX dx_evenement_date_mise_a_jour ON Evenement (date_de_mise_a_jour);

CREATE TABLE contient(
    id INT,
    mots_cles TEXT,
    PRIMARY KEY(id, mots_cles)
);
CREATE INDEX dx_contient_mot_cle ON contient USING HASH (mots_cles);
CREATE INDEX dx_contient_id ON contient USING HASH (id);

-- CONTRAINTE
-- FOREIGN KEY
ALTER TABLE  Evenement
ADD CONSTRAINT fk_url_adress_en FOREIGN KEY(en_ligne_adress_url) REFERENCES AdressEn(en_ligne_adress_url),
ADD CONSTRAINT fk_url_reservation FOREIGN KEY(url_de_reservation) REFERENCES Reservation(url_de_reservation),
ADD CONSTRAINT fk_url_image FOREIGN KEY(url_de_l_image) REFERENCES Image(url_de_l_image),
ADD CONSTRAINT fk_groupe FOREIGN KEY(groupe) REFERENCES Groupe(groupe),
ADD CONSTRAINT fk_lieu FOREIGN KEY(longitude, latitude) REFERENCES Lieu(longitude, latitude);

ALTER TABLE contient
ADD CONSTRAINT fk_evenement FOREIGN KEY(id) REFERENCES Evenement(id),
ADD CONSTRAINT fk_mots_cles FOREIGN KEY(mots_cles) REFERENCES Mots_cles(mots_cles);

-- UNIQUE
ALTER TABLE Evenement ADD CONSTRAINT ck_unique_event UNIQUE (titre,date_de_debut,longitude,latitude);

-- REMPLIR TABLE
CREATE TEMP TABLE import (
    id INT,
    url TEXT,
    titre TEXT,
    chapeau TEXT,
    description TEXT,
    date_de_debut TIMESTAMP,
    date_de_fin TIMESTAMP,
    occurence TEXT, --TO DELETE
    description_de_la_date TEXT,
    url_de_l_image TEXT,
    texte_alternatif_de_l_image TEXT,
    credit_de_l_image TEXT,
    mots_cles TEXT,
    nom_du_lieu TEXT,
    adresse_du_lieu TEXT,
    code_postal TEXT,
    ville TEXT,
    coordonnees_geographiques TEXT,
    acces_pmr BOOLEAN,
    acces_mal_voyant BOOLEAN,
    acces_mal_entendant BOOLEAN,
    transport TEXT, --TO DELETE
    url_de_contact TEXT,
    telephone_de_contact TEXT,
    email_de_contact TEXT,
    url_facebook_associee TEXT,
    url_twitter_associee TEXT,
    type_de_prix TEXT,
    detail_du_prix TEXT,
    type_d_acces TEXT,
    url_de_reservation TEXT,
    url_de_reservation_texte TEXT,
    date_de_mise_a_jour TIMESTAMP,
    image_de_couverture TEXT,
    programme TEXT,
    en_ligne_adress_url TEXT,
    en_ligne_adress_url_text TEXT,
    en_ligne_adress_text TEXT,
    title_event TEXT,
    audience TEXT,
    childrens TEXT,
    groupe TEXT
);

\copy import FROM 'data/que-faire-a-paris-.csv' DELIMITER ';' CSV HEADER;


INSERT INTO Mots_cles (mots_cles)
SELECT DISTINCT TRIM(unnest(string_to_array(import.mots_cles, ','))) AS mots_cles
FROM import
WHERE import.mots_cles IS NOT NULL;


INSERT INTO Groupe (groupe)
SELECT DISTINCT groupe FROM import;


INSERT INTO Image (url_de_l_image, texte_alternatif_de_l_image, credit_de_l_image)
SELECT DISTINCT url_de_l_image, texte_alternatif_de_l_image, credit_de_l_image FROM import;


INSERT INTO Reservation (url_de_reservation, url_de_reservation_texte)
SELECT DISTINCT url_de_reservation, url_de_reservation_texte FROM import
WHERE url_de_reservation IS NOT NULL
ON CONFLICT DO NOTHING;


INSERT INTO AdressEn (en_ligne_adress_url, en_ligne_adress_url_text, en_ligne_adress_text)
SELECT DISTINCT en_ligne_adress_url, en_ligne_adress_url_text, en_ligne_adress_text FROM import
WHERE en_ligne_adress_url IS NOT NULL;


INSERT INTO Lieu (longitude, latitude, nom_du_lieu, adresse_du_lieu, code_postal, nom_ville, acces_pmr,
    acces_mal_voyant, acces_mal_entendant)
SELECT DISTINCT 
    COALESCE(SPLIT_PART(coordonnees_geographiques, ', ', 1), '') AS longitude, 
    COALESCE(SPLIT_PART(coordonnees_geographiques, ', ', 2), '') AS latitude, 
    COALESCE(nom_du_lieu, ''), COALESCE(adresse_du_lieu, ''),
    COALESCE(code_postal, ''), COALESCE(ville, ''), 
    acces_pmr, acces_mal_voyant, acces_mal_entendant
FROM import
ON CONFLICT DO NOTHING;


INSERT INTO Evenement (id, url, titre, chapeau, description, date_de_debut, date_de_fin, description_de_la_date,
    type_de_prix, detail_du_prix, type_d_acces, date_de_mise_a_jour, image_de_couverture, programme,
    title_event, childrens, audience, groupe, url_de_contact, telephone_de_contact, email_de_contact,
    url_facebook_associee, url_twitter_associee, url_de_reservation, url_de_l_image, en_ligne_adress_url,
    longitude, latitude)
SELECT
    id, COALESCE(url, ''), COALESCE(titre, ''), chapeau, description, date_de_debut, date_de_fin, description_de_la_date,
    CASE WHEN type_de_prix IS NULL THEN 'inconnu'::t_type_de_prix ELSE type_de_prix::t_type_de_prix END AS type_de_prix,
    detail_du_prix,
    CASE WHEN type_d_acces IS NULL THEN 'inconnu'::t_type_d_acces ELSE type_d_acces::t_type_d_acces END AS type_d_acces, 
    date_de_mise_a_jour, image_de_couverture, programme, title_event, childrens, audience, groupe,
    url_de_contact, telephone_de_contact, email_de_contact, url_facebook_associee, url_twitter_associee,
    url_de_reservation, url_de_l_image, en_ligne_adress_url,
    COALESCE(SPLIT_PART(coordonnees_geographiques, ', ', 1), '') AS longitude,
    COALESCE(SPLIT_PART(coordonnees_geographiques, ', ', 2), '') AS latitude
FROM import
ON CONFLICT DO NOTHING;


INSERT INTO contient (id, mots_cles)
SELECT e.id, t.mots_cles
FROM import t
JOIN Evenement e ON t.id = e.id
JOIN Mots_cles m ON t.mots_cles = m.mots_cles;


DROP TABLE import;
