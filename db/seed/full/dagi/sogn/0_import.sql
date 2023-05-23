DROP TABLE IF EXISTS dagi_500.sogneinddeling;

CREATE TABLE dagi_500.sogneinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.sogneinddeling;

CREATE INDEX ON dagi_500.sogneinddeling USING gist (geometri);
VACUUM ANALYZE dagi_500.sogneinddeling;


DROP TABLE IF EXISTS dagi_10.sogneinddeling;

CREATE TABLE dagi_10.sogneinddeling AS
SELECT
    *
FROM
    dagi_10_fdw.sogneinddeling;

CREATE INDEX ON dagi_10.sogneinddeling USING gist (geometri);
VACUUM ANALYZE dagi_10.sogneinddeling;
