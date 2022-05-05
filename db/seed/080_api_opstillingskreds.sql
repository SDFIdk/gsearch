CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.opstillingskreds CASCADE;
CREATE TYPE api.opstillingskreds AS (
  id TEXT,
  "name" TEXT,
  presentationstring TEXT,
  geometryWkt TEXT, -- same AS bbox
  geometryWkt_detail TEXT,
  valgkredsnr TEXT,
  storkredsnr TEXT,
  storkredsnavn TEXT,
  landsdelsnr TEXT,
  landsdelsnavn TEXT,
  geometri geometry,
  bbox box2d,
  rang1 double precision,
  rang2 double precision
);

COMMENT ON TYPE api.opstillingskreds IS 'Opstillingskreds';
COMMENT ON COLUMN api.opstillingskreds.presentationstring IS 'Præsentationsform for en opstillingskreds';
COMMENT ON COLUMN api.opstillingskreds."name" IS 'Navn på opstillingskreds';
COMMENT ON COLUMN api.opstillingskreds.id IS 'opstillingskredsnummer';
COMMENT ON COLUMN api.opstillingskreds.geometri IS 'Geometri i valgt koordinatsystem';
COMMENT ON COLUMN api.opstillingskreds.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';
COMMENT ON COLUMN api.opstillingskreds.geometryWkt IS 'Geometriens boundingbox i valgt koordinatsystem (som WKT)';
COMMENT ON COLUMN api.opstillingskreds.geometryWkt_detail IS 'Geometri i valgt koordinatsystem (som WKT)';

DROP TABLE IF EXISTS basic.opstillingskreds_mv;
WITH opstillingskredse AS
(
  SELECT
    o.opstillingskredsnummer,
    o.navn,
    o.valgkredsnummer,
    o.storkredsnummer,
    s.navn AS storkredsnavn,
    st_force2d(o.geometri) AS geometri
  FROM
    dagi_500m_nohist_l1.opstillingskreds o
    LEFT JOIN dagi_500m_nohist_l1.storkreds s on o.storkredsnummer = s.storkredsnummer
)
SELECT
  o.navn || 'kredsen' AS titel,
  o.opstillingskredsnummer,
  coalesce(o.navn, '') AS navn,
  o.valgkredsnummer AS valgkredsnr,
  o.storkredsnummer AS storkredsnr,
  o.storkredsnavn,
  st_multi(st_union(o.geometri)) AS geometri,
  st_extent(o.geometri) AS bbox
INTO
  basic.opstillingskreds_mv
FROM 
  opstillingskredse o
GROUP BY
  o.opstillingskredsnummer, o.navn, o.valgkredsnummer, storkredsnummer, storkredsnavn
;


ALTER TABLE basic.opstillingskreds_mv DROP COLUMN IF EXISTS textsearchable_plain_col;
ALTER TABLE basic.opstillingskreds_mv
ADD COLUMN textsearchable_plain_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', split_part(navn, ' ', 1)), 'A') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 2)), 'B') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 3)), 'C') ||
  	setweight(to_tsvector('simple', basic.split_and_endsubstring(navn, 4)), 'D') 
  ) STORED
;


ALTER TABLE basic.opstillingskreds_mv DROP COLUMN IF EXISTS textsearchable_unaccent_col;
ALTER TABLE basic.opstillingskreds_mv
ADD COLUMN textsearchable_unaccent_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 1)), 'A') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 2)), 'B') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 3)), 'C') ||
  	setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring(navn, 4)), 'D') 
  ) STORED
;


ALTER TABLE basic.opstillingskreds_mv DROP COLUMN IF EXISTS textsearchable_phonetic_col;
ALTER TABLE basic.opstillingskreds_mv
ADD COLUMN textsearchable_phonetic_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 1), 2)), 'A') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 2), 2)), 'B') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 3), 2)), 'C') ||
    setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik(coalesce(navn), 4)), 'D')
  ) STORED
;

CREATE INDEX ON basic.opstillingskreds_mv USING GIN (textsearchable_plain_col);
CREATE INDEX ON basic.opstillingskreds_mv USING GIN (textsearchable_unaccent_col);
CREATE INDEX ON basic.opstillingskreds_mv USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.opstillingskreds(text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.opstillingskreds(input_tekst text,filters text,sortoptions integer,rowlimit integer)
 RETURNS SETOF api.opstillingskreds
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE 
  max_rows integer;
  query_string TEXT;
  plain_query_string TEXT;
  stmt TEXT;
BEGIN
  -- Initialize
  max_rows = 100;
  IF rowlimit > max_rows THEN
    RAISE 'rowlimit skal være <= %', max_rows;
  END IF;
  if filters IS NULL THEN
    filters = '1=1';
  END IF;
  IF btrim(input_tekst) = Any('{.,-, '', \,}')  THEN
    input_tekst = '';
  END IF;  

  -- Build the query_string
  WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
  SELECT
    string_agg(fonetik.fnfonetik(t,2), ':* <-> ') || ':*' FROM tokens INTO query_string;
  
  -- build the plain version of the query string for ranking purposes
  WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
  SELECT
    string_agg(t, ':* <-> ') || ':*' FROM tokens INTO plain_query_string;
	
  -- Execute and return the result
  stmt = format(E'SELECT
    opstillingskredsnummer, navn, titel, ST_AStext(bbox), ST_AStext(geometri), 
    valgkredsnr, storkredsnr, storkredsnavn, '''' AS landsdelsnr, '''' AS landsdelsnavn, geometri, bbox,
    basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
    ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
  FROM
    basic.opstillingskreds_mv
  WHERE (
    textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
    OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
    AND %s
  ORDER BY
    rank1 desc, rank2 desc,
    navn
  LIMIT $3
;', filters);
  RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
END
$function$;


-- Test cases:
/*
SELECT (api.opstillingskreds('rønn',NULL, 1, 100)).*;
SELECT (api.opstillingskreds('hels',NULL, 1, 100)).*;
SELECT (api.opstillingskreds('åkir',NULL, 1, 100)).*;
SELECT (api.opstillingskreds('nord',NULL, 1, 100)).*;
SELECT (api.opstillingskreds('vest',NULL, 1, 100)).*;
*/
