CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.politikreds CASCADE;
CREATE TYPE api.politikreds AS (
  id TEXT,
  "name" TEXT,
  presentationstring TEXT,
  geometryWkt TEXT, -- same AS bbox
  geometryWkt_detail TEXT,
  myndighedskode TEXT,
  geometri geometry,
  bbox box2d,
  rang1 double precision,
  rang2 double precision
);  

COMMENT ON TYPE api.politikreds IS 'politikreds';
COMMENT ON COLUMN api.politikreds.presentationstring IS 'Præsentationsform for en politikreds';
COMMENT ON COLUMN api.politikreds."name" IS 'Navn på politikreds';
COMMENT ON COLUMN api.politikreds.id IS 'politikredsnummer';
COMMENT ON COLUMN api.politikreds.geometri IS 'Geometri i valgt koordinatsystem';
COMMENT ON COLUMN api.politikreds.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';
COMMENT ON COLUMN api.politikreds.geometryWkt IS 'Geometriens boundingbox i valgt koordinatsystem (som WKT)';
COMMENT ON COLUMN api.politikreds.geometryWkt_detail IS 'Geometri i valgt koordinatsystem (som WKT)';

DROP TABLE IF EXISTS basic.politikreds_mv;
WITH politikredse AS
(
  SELECT
    politikredsnummer,
    navn,
    myndighedskode,
    st_force2d(p.geometri) AS geometri
  FROM
    dagi_500m_nohist_l1.politikreds p
)
SELECT
  REPLACE(p.navn, 'Politi', 'Politikreds') AS titel,
  p.politikredsnummer,
  coalesce(p.navn, '') AS navn,
  p.myndighedskode,
  st_multi(st_union(p.geometri)) AS geometri,
  st_extent(p.geometri) AS bbox
INTO
  basic.politikreds_mv
FROM 
  politikredse p
GROUP BY
  p.politikredsnummer, p.navn, p.myndighedskode
;


ALTER TABLE basic.politikreds_mv DROP COLUMN IF EXISTS textsearchable_plain_col;
ALTER TABLE basic.politikreds_mv
ADD COLUMN textsearchable_plain_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', split_part(navn, ' ', 1)), 'A') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 2)), 'B') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 3)), 'C') ||
    setweight(to_tsvector('simple', basic.split_and_endsubstring(navn, 4)), 'D') 
  ) STORED
;


ALTER TABLE basic.politikreds_mv DROP COLUMN IF EXISTS textsearchable_unaccent_col;
ALTER TABLE basic.politikreds_mv
ADD COLUMN textsearchable_unaccent_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 1)), 'A') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 2)), 'B') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 3)), 'C') ||
    setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring(navn, 4)), 'D') 
  ) STORED
;

ALTER TABLE basic.politikreds_mv DROP COLUMN IF EXISTS textsearchable_phonetic_col;
ALTER TABLE basic.politikreds_mv
ADD COLUMN textsearchable_phonetic_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 1), 2)), 'A') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 2), 2)), 'B') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 3), 2)), 'C') ||
    setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik(navn, 4)), 'D') 
  ) STORED
;

CREATE INDEX ON basic.politikreds_mv USING GIN (textsearchable_plain_col);
CREATE INDEX ON basic.politikreds_mv USING GIN (textsearchable_unaccent_col);
CREATE INDEX ON basic.politikreds_mv USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.politikreds(text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.politikreds(input_tekst text,filters text,sortoptions integer,rowlimit integer)
 RETURNS SETOF api.politikreds
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
    politikredsnummer, navn, titel, ST_AStext(bbox), ST_AStext(geometri), myndighedskode, geometri, bbox,
	  basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
    ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
  FROM
    basic.politikreds_mv
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
SELECT (api.politikreds('østjyl',NULL, 1, 100)).*;
SELECT (api.politikreds('køben','myndighedskode=''1470''', 1, 100)).*;
SELECT (api.politikreds('falster',NULL, 1, 100)).*;
SELECT (api.politikreds('midt',NULL, 1, 100)).*;
*/
