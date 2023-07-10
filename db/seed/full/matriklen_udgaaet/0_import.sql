DROP TABLE IF EXISTS matriklen_udgaaet.jordstykke;

CREATE TABLE matriklen_udgaaet.jordstykke AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.jordstykke;

DROP TABLE IF EXISTS matriklen_udgaaet.lodflade;

CREATE TABLE matriklen_udgaaet.lodflade AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.lodflade;

DROP TABLE IF EXISTS matriklen_udgaaet.centroide;

CREATE TABLE matriklen_udgaaet.centroide AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.centroide;

DROP TABLE IF EXISTS matriklen_udgaaet.samletfastejendom;

CREATE TABLE matriklen_udgaaet.samletfastejendom AS
SELECT
    *
FROM
    matriklen_udgaaet_fdw.samletfastejendom;

CREATE INDEX ON matriklen_udgaaet.jordstykke (id_lokalid);
CREATE INDEX ON matriklen_udgaaet.jordstykke (ejerlavlokalid);
CREATE INDEX ON matriklen_udgaaet.jordstykke (kommunelokalid);
CREATE INDEX ON matriklen_udgaaet.jordstykke (samletfastejendomlokalid);
CREATE INDEX ON matriklen_udgaaet.centroide (jordstykkelokalid);
CREATE INDEX ON matriklen_udgaaet.lodflade (jordstykkelokalid);
CREATE INDEX ON matriklen_udgaaet.samletfastejendom (id_lokalid);

VACUUM ANALYZE matriklen_udgaaet.jordstykke;
VACUUM ANALYZE matriklen_udgaaet.centroide;
VACUUM ANALYZE matriklen_udgaaet.lodflade;
VACUUM ANALYZE matriklen_udgaaet.samletfastejendom;
