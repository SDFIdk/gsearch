DROP TABLE IF EXISTS dagi_500.kommuneinddeling;

CREATE TABLE dagi_500.kommuneinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.kommuneinddeling;

CREATE INDEX ON dagi_500.kommuneinddeling USING gist (geometri);
CREATE INDEX ON dagi_500.kommuneinddeling (navn);
CREATE INDEX ON dagi_500.kommuneinddeling (kommunekode);

VACUUM ANALYZE dagi_500.kommuneinddeling;


DROP TABLE IF EXISTS dagi_10.kommuneinddeling;

CREATE TABLE dagi_10.kommuneinddeling AS
SELECT
    *
FROM
    dagi_10_fdw.kommuneinddeling;

CREATE INDEX ON dagi_10.kommuneinddeling USING gist (geometri);
CREATE INDEX ON dagi_10.kommuneinddeling (navn);
CREATE INDEX ON dagi_10.kommuneinddeling (kommunekode);

VACUUM ANALYZE dagi_10.kommuneinddeling;
