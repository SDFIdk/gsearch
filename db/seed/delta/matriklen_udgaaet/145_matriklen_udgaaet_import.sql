SELECT '145_matriklen_udgaaet_import.sql ' || now();


-- DEBUG
DROP TABLE IF EXISTS g_options;

CREATE TEMPORARY TABLE g_options (
    maxrows int
);

--INSERT INTO g_options VALUES (1000);
-- MATRIKLEN_UDGAAET
DROP TABLE IF EXISTS matriklen_udgaaet.jordstykke;

CREATE TABLE matriklen_udgaaet.jordstykke AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.jordstykke
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen_udgaaet.lodflade;

CREATE TABLE matriklen_udgaaet.lodflade AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.lodflade
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen_udgaaet.ejerlav;

CREATE TABLE matriklen_udgaaet.ejerlav AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.ejerlav
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen_udgaaet.centroide;

CREATE TABLE matriklen_udgaaet.centroide AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.centroide
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen_udgaaet.matrikelkommune;

CREATE TABLE matriklen_udgaaet.matrikelkommune AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.matrikelkommune
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen_udgaaet.samletfastejendom;

CREATE TABLE matriklen_udgaaet.samletfastejendom AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.samletfastejendom
WHERE
        status = 'Gældende'
    LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON matriklen_udgaaet.jordstykke (id_lokalid);
CREATE INDEX ON matriklen_udgaaet.jordstykke (ejerlavlokalid);
CREATE INDEX ON matriklen_udgaaet.jordstykke (kommunelokalid);
CREATE INDEX ON matriklen_udgaaet.jordstykke (samletfastejendomlokalid);
CREATE INDEX ON matriklen_udgaaet.ejerlav (id_lokalid);
CREATE INDEX ON matriklen_udgaaet.ejerlav (ejerlavsnavn);
CREATE INDEX ON matriklen_udgaaet.centroide (jordstykkelokalid);
CREATE INDEX ON matriklen_udgaaet.matrikelkommune (id_lokalid);
CREATE INDEX ON matriklen_udgaaet.lodflade (jordstykkelokalid);
CREATE INDEX ON matriklen_udgaaet.samletfastejendom (id_lokalid);
