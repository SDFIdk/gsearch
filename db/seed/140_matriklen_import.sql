SELECT '140_matriklen_import.sql ' || now();


-- DEBUG
DROP TABLE IF EXISTS g_options;

CREATE TEMPORARY TABLE g_options (
    maxrows int
);

--INSERT INTO g_options VALUES (1000);
-- MATRIKLEN
DROP TABLE IF EXISTS matriklen.jordstykke;

CREATE TABLE matriklen.jordstykke AS
SELECT
    *
FROM
    matriklen_fdw.jordstykke
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen.lodflade;

CREATE TABLE matriklen.lodflade AS
SELECT
    *
FROM
    matriklen_fdw.lodflade
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen.ejerlav;

CREATE TABLE matriklen.ejerlav AS
SELECT
    *
FROM
    matriklen_fdw.ejerlav
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen.centroide;

CREATE TABLE matriklen.centroide AS
SELECT
    *
FROM
    matriklen_fdw.centroide
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

DROP TABLE IF EXISTS matriklen.matrikelkommune;

CREATE TABLE matriklen.matrikelkommune AS
SELECT
    *
FROM
    matriklen_fdw.matrikelkommune
WHERE
    status = 'Gældende'
LIMIT (
    SELECT
        maxrows
    FROM
        g_options);

CREATE INDEX ON matriklen.jordstykke (id_lokalid);
CREATE INDEX ON matriklen.jordstykke (ejerlavlokalid);
CREATE INDEX ON matriklen.jordstykke (kommunelokalid);
CREATE INDEX ON matriklen.ejerlav (id_lokalid);
CREATE INDEX ON matriklen.ejerlav (ejerlavsnavn);
CREATE INDEX ON matriklen.centroide (jordstykkelokalid);
CREATE INDEX ON matriklen.matrikelkommune (id_lokalid);
CREATE INDEX ON matriklen.lodflade (jordstykkelokalid);
