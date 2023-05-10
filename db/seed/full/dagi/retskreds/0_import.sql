DROP TABLE IF EXISTS dagi_500.retskreds;

CREATE TABLE dagi_500.retskreds AS
SELECT
    *
FROM
    dagi_500_fdw.retskreds;

CREATE INDEX ON dagi_500.retskreds USING gist (geometri);
VACUUM ANALYZE dagi_500.retskreds;


DROP TABLE IF EXISTS dagi_10.retskreds;

CREATE TABLE dagi_10.retskreds AS
SELECT
    *
FROM
    dagi_10_fdw.retskreds;

CREATE INDEX ON dagi_10.retskreds USING gist (geometri);
VACUUM ANALYZE dagi_10.retskreds;
