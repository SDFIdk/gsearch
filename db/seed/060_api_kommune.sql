CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.kommune CASCADE;
CREATE TYPE api.kommune AS (
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

COMMENT ON TYPE api.kommune IS 'Kommune';
COMMENT ON COLUMN api.kommune.presentationstring IS 'Præsentationsform for en kommune';
COMMENT ON COLUMN api.kommune."name" IS 'Navn på kommune';
COMMENT ON COLUMN api.kommune.id IS 'kommunekode';
COMMENT ON COLUMN api.kommune.geometri IS 'Geometri i valgt koordinatsystem';
COMMENT ON COLUMN api.kommune.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';
COMMENT ON COLUMN api.kommune.geometryWkt IS 'Geometriens boundingbox i valgt koordinatsystem (som WKT)';
COMMENT ON COLUMN api.kommune.geometryWkt_detail IS 'Geometri i valgt koordinatsystem (som WKT)';

DROP TABLE IF EXISTS basic.kommune_mv;
WITH kommuner AS
(
  SELECT
    k.kommunekode,
    k.navn,
    k.regionskode,
    st_force2d(k.geometri) AS geometri
  FROM
    dagi_500m_nohist_l1.kommuneinddeling k
)
SELECT
  (CASE 
    WHEN k.kommunekode = '0101' THEN k.navn || 's kommune' 
    ELSE k.navn || ' kommune'
  END) AS titel,
  coalesce(k.kommunekode, '') AS kommunekode,
  coalesce(k.navn, '') AS navn,
  k.regionskode,
  st_multi(st_union(k.geometri)) AS geometri,
  st_extent(k.geometri) AS bbox
INTO
  basic.kommune_mv
FROM 
  kommuner k
GROUP BY
  k.kommunekode, k.navn, k.regionskode
;


ALTER TABLE basic.kommune_mv DROP COLUMN IF EXISTS textsearchable_plain_col;
ALTER TABLE basic.kommune_mv
ADD COLUMN textsearchable_plain_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', kommunekode), 'A') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 1)), 'B') ||
    setweight(to_tsvector('simple', split_part(navn, ' ', 2)), 'C') ||
  	setweight(to_tsvector('simple', basic.split_and_endsubstring(navn, 3)), 'D') 
  ) STORED
;

ALTER TABLE basic.kommune_mv DROP COLUMN IF EXISTS textsearchable_unaccent_col;
ALTER TABLE basic.kommune_mv
ADD COLUMN textsearchable_unaccent_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('basic.septima_fts_config', kommunekode), 'A') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 1)), 'B') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(navn, ' ', 2)), 'C') ||
  	setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring(navn, 3)), 'D') 
  ) STORED
;

ALTER TABLE basic.kommune_mv DROP COLUMN IF EXISTS textsearchable_phonetic_col;
ALTER TABLE basic.kommune_mv
ADD COLUMN textsearchable_phonetic_col tsvector
GENERATED ALWAYS AS
  (
    setweight(to_tsvector('simple', kommunekode), 'A') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 1), 2)), 'B') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(navn, ' ', 2), 2)), 'C') ||
	  setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik(navn, 3)), 'D') 
  ) STORED
;

CREATE INDEX ON basic.kommune_mv USING GIN (textsearchable_plain_col);
CREATE INDEX ON basic.kommune_mv USING GIN (textsearchable_unaccent_col);
CREATE INDEX ON basic.kommune_mv USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.kommune(text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.kommune(input_tekst text,filters text,sortoptions integer,rowlimit integer)
 RETURNS SETOF api.kommune
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE 
  max_rows integer;
  input_kommunenavn TEXT;
  input_kommunekode TEXT;
  kommunenavn_string TEXT;
  kommunenavn_string_plain TEXT;
  kommunekode_string TEXT;
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
  -- Build the query_string
  IF btrim(input_tekst) = Any('{.,-, '', \,}')  THEN
    input_tekst = '';
  END IF;

  SELECT btrim(regexp_replace(input_tekst, '(?<!\S)\d\S*', '', 'g')) INTO input_kommunenavn; -- matches non-digits
  SELECT btrim(regexp_replace(regexp_replace(input_tekst, '((?<!\S)\D\S*)', '', 'g'), '\s+', ' ')) INTO input_kommunekode; --matches digits
  
  
  WITH tokens AS (SELECT UNNEST(string_to_array(input_kommunenavn, ' ')) t)
  SELECT
    string_agg(fonetik.fnfonetik(t,2), ':BCD* <-> ') || ':BCD*' FROM tokens INTO kommunenavn_string;
	
  WITH tokens AS (SELECT UNNEST(string_to_array(input_kommunenavn, ' ')) t)
  SELECT
    string_agg(t, ':BCD* <-> ') || ':BCD*' FROM tokens INTO kommunenavn_string_plain;

  WITH tokens AS (SELECT UNNEST(string_to_array(input_kommunekode, ' ')) t)
    SELECT string_agg(t, ':A | ') || ':A' FROM tokens INTO kommunekode_string;
	
  CASE
    WHEN kommunenavn_string IS NULL THEN SELECT kommunekode_string INTO query_string;
    WHEN kommunekode_string IS NULL THEN SELECT kommunenavn_string INTO query_string;
    ELSE SELECT kommunenavn_string || ' | ' || kommunekode_string INTO query_string;
  END CASE;
	
	CASE
      WHEN kommunenavn_string_plain IS NULL THEN SELECT kommunekode_string INTO plain_query_string;
      WHEN kommunekode_string IS NULL THEN SELECT kommunenavn_string_plain INTO plain_query_string;
      ELSE SELECT kommunenavn_string_plain || ' | ' || kommunekode_string INTO plain_query_string;
  END CASE;
  
  -- Execute and return the result
  stmt = format(E'SELECT
    kommunekode, navn, titel, ST_AStext(bbox), ST_AStext(geometri), geometri, bbox,
    basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
	  ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
  FROM
    basic.kommune_mv
  WHERE (
    textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
    OR textsearchable_plain_col @@ to_tsquery(''simple'', $2) )
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
SELECT (api.kommune('køb',NULL, 1, 100)).*;
SELECT (api.kommune('ålborg',NULL, 1, 100)).*;
SELECT (api.kommune('nord',NULL, 1, 100)).*;
SELECT (api.kommune('0101 fred',NULL, 1, 100)).*;
*/
