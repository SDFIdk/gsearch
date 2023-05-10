
DROP TABLE IF EXISTS dagi_500.regionsinddeling;

CREATE TABLE dagi_500.regionsinddeling AS
SELECT
    *
FROM
    dagi_500_fdw.regionsinddeling

CREATE INDEX ON dagi_500.regionsinddeling USING gist (geometri);
VACUUM ANALYZE dagi_500.regionsinddeling;


CREATE INDEX ON dagi_10.regionsinddeling USING gist (geometri);
VACUUM ANALYZE dagi_10.regionsinddeling;


DROP TABLE IF EXISTS dagi_10.retskreds;

CREATE TABLE dagi_10.retskreds AS
SELECT
    *
FROM
    dagi_10_fdw.retskreds

CREATE INDEX ON dagi_10.retskreds USING gist (geometri);
VACUUM ANALYZE dagi_10.retskreds;
