-- MATRIKLEN


DROP TABLE IF EXISTS matriklen.jordstykke;

CREATE TABLE matriklen.jordstykke AS
    SELECT *
    FROM matriklen_fdw.jordstykke
    LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS matriklen.lodflade;

CREATE TABLE matriklen.lodflade AS
    SELECT *
    FROM matriklen_fdw.lodflade
    LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS matriklen.ejerlav;

CREATE TABLE matriklen.ejerlav AS
    SELECT *
    FROM matriklen_fdw.ejerlav
    LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS matriklen.centroide;

CREATE TABLE matriklen.centroide AS
    SELECT *
    FROM matriklen_fdw.centroide
    LIMIT (SELECT maxrows FROM g_options);

DROP TABLE IF EXISTS matriklen.matrikelkommune;

CREATE TABLE matriklen.matrikelkommune AS
    SELECT *
    FROM matriklen_fdw.matrikelkommune
    LIMIT (SELECT maxrows FROM g_options);

--CREATE INDEX ON matriklen.jordstykke (elavskode, matrnr);
--CREATE INDEX ON matriklen.centroide (elavskode, matrnr);
