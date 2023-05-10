
DROP TABLE IF EXISTS dagi_500.postnummerinddeling;

CREATE TABLE dagi_500.postnummerinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.postnummerinddeling;

CREATE INDEX ON dagi_500.postnummerinddeling USING gist (geometri);
VACUUM ANALYZE dagi_500.postnummerinddeling;


DROP TABLE IF EXISTS dagi_10.postnummerinddeling;

CREATE TABLE dagi_10.postnummerinddeling AS
SELECT
    *
FROM
    dagi_10_fdw.postnummerinddeling;

CREATE INDEX ON dagi_10.postnummerinddeling USING gist (geometri);
VACUUM ANALYZE dagi_10.postnummerinddeling;
