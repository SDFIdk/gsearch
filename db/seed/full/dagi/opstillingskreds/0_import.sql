DROP TABLE IF EXISTS dagi_500.opstillingskreds;

CREATE TABLE dagi_500.opstillingskreds AS
SELECT
    *
FROM
    dagi_500_fdw.opstillingskreds;

CREATE INDEX ON dagi_500.opstillingskreds USING gist (geometri);
VACUUM ANALYZE dagi_500.opstillingskreds;


DROP TABLE IF EXISTS dagi_500.storkreds;

CREATE TABLE dagi_500.storkreds AS
SELECT
    *
FROM
    dagi_500_fdw.storkreds;

CREATE INDEX ON dagi_500.storkreds USING gist (geometri);
VACUUM ANALYZE dagi_500.storkreds;


DROP TABLE IF EXISTS dagi_10.opstillingskreds;

CREATE TABLE dagi_10.opstillingskreds AS
SELECT
    *
FROM
    dagi_10_fdw.opstillingskreds;

CREATE INDEX ON dagi_10.opstillingskreds USING gist (geometri);
VACUUM ANALYZE dagi_10.opstillingskreds;


DROP TABLE IF EXISTS dagi_10.storkreds;

CREATE TABLE dagi_10.storkreds AS
SELECT
    *
FROM
    dagi_10_fdw.storkreds;

CREATE INDEX ON dagi_10.storkreds USING gist (geometri);
VACUUM ANALYZE dagi_10.storkreds;
