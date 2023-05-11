DROP TABLE IF EXISTS dagi_500.politikreds;

CREATE TABLE dagi_500.politikreds AS
SELECT
    *
FROM
    dagi_500_fdw.politikreds;

CREATE INDEX ON dagi_500.politikreds USING gist (geometri);
VACUUM ANALYZE dagi_500.politikreds;


DROP TABLE IF EXISTS dagi_10.politikreds;

CREATE TABLE dagi_10.politikreds AS
SELECT
    *
FROM
    dagi_10_fdw.politikreds;

CREATE INDEX ON dagi_10.politikreds USING gist (geometri);
VACUUM ANALYZE dagi_10.politikreds;
