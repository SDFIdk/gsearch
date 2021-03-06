CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.region CASCADE;
CREATE TYPE api.region AS (
  id TEXT,
  "name" TEXT,
  presentationstring TEXT,
  geometryWkt TEXT, -- same AS bbox
  geometryWkt_detail TEXT,
  geometri geometry,
  bbox box2d,
  rang1 double precision,
  rang2 double precision
);  

COMMENT ON TYPE api.region IS 'Region';
COMMENT ON COLUMN api.region.presentationstring IS 'Præsentationsform for en region';
COMMENT ON COLUMN api.region."name" IS 'Navn på region';
COMMENT ON COLUMN api.region.id IS 'kommunekredsnummer';
COMMENT ON COLUMN api.region.geometri IS 'Geometri i valgt koordinatsystem';
COMMENT ON COLUMN api.region.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';
COMMENT ON COLUMN api.region.geometryWkt IS 'Geometriens boundingbox i valgt koordinatsystem (som WKT)';
COMMENT ON COLUMN api.region.geometryWkt_detail IS 'Geometri i valgt koordinatsystem (som WKT)';

DROP TABLE IF EXISTS basic.region_mv;
WITH regioner AS
(
  SELECT
    r.regionskode,
    r.navn,
    st_force2d(r.geometri) AS geometri
  FROM
    dagi_500m_nohist_l1.regionsinddeling r
)
SELECT
  r.navn AS titel,
  r.regionskode,
  coalesce(r.navn, '') AS navn,
  st_multi(st_union(r.geometri)) AS geometri,
  st_extent(r.geometri) AS bbox
INTO
  basic.region_mv
FROM 
  regioner r
GROUP BY
  r.regionskode, r.navn
;


ALTER TABLE basic.region_mv DROP COLUMN IF EXISTS textsearchable_plain_col;
ALTER TABLE basic.region_mv
ADD COLUMN textsearchable_plain_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', split_part(navn, ' ', 1)), 'A') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 2)), 'B') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 3)), 'C') ||
	  setweight(to_tsvector('simple', basic.split_and_endsubstring(navn, 4)), 'D') 
  ) STORED
;

ALTER TABLE basic.region_mv DROP COLUMN IF EXISTS textsearchable_unaccent_col;
ALTER TABLE basic.region_mv
ADD COLUMN textsearchable_unaccent_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 1)), 'A') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 2)), 'B') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 3)), 'C') ||
	  setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring(navn, 4)), 'D') 
  ) STORED
;

ALTER TABLE basic.region_mv DROP COLUMN IF EXISTS textsearchable_phonetic_col;
ALTER TABLE basic.region_mv
ADD COLUMN textsearchable_phonetic_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 1), 2)), 'A') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 2), 2)), 'B') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 3), 2)), 'C') ||
    setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik(navn, 4)), 'D') 
  ) STORED
;

CREATE INDEX ON basic.region_mv USING GIN (textsearchable_plain_col);
CREATE INDEX ON basic.region_mv USING GIN (textsearchable_unaccent_col);
CREATE INDEX ON basic.region_mv USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.region(text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.region(input_tekst text,filters text,sortoptions integer,rowlimit integer)
 RETURNS SETOF api.region
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
    regionskode, navn, titel, ST_AStext(bbox), ST_AStext(geometri), geometri, bbox,
	  basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
    ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
  FROM
    basic.region_mv
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
SELECT (api.region('region',NULL, 1, 100)).*;
SELECT (api.region('nord',NULL, 1, 100)).*;
SELECT (api.region('hoved',NULL, 1, 100)).*;
SELECT (api.region('midt',NULL, 1, 100)).*;
SELECT (api.region('sje',NULL, 1, 100)).*;
SELECT (api.region('syd',NULL, 1, 100)).*;
*/
