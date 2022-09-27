CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.husnummer CASCADE;
CREATE TYPE api.husnummer AS (
  id TEXT,
  municpalityCode TEXT,
  municipalityName TEXT,
  streetCode TEXT,
  streetName TEXT,
  streetBuildingIdentifier TEXT,
  postcodeIdentifier TEXT,
  districtName TEXT,
  presentationstring TEXT,
  adgangspunkt_geometri geometry,
  vejpunkt_geometri geometry,
  rang1 double precision,
  rang2 double precision
);  

COMMENT ON TYPE api.husnummer IS 'Husnummer';
COMMENT ON COLUMN api.husnummer.id IS 'Id på husnummer';
COMMENT ON COLUMN api.husnummer.municpalityCode IS 'Kommunekode for et husnummer';
COMMENT ON COLUMN api.husnummer.municipalityName IS 'Kommunenavn for et husnummer';
COMMENT ON COLUMN api.husnummer.streetCode IS 'vejkode for et husnummer';
COMMENT ON COLUMN api.husnummer.streetName is 'vejnavn for et husnummer';
COMMENT ON COLUMN api.husnummer.streetBuildingIdentifier is 'husnummertekst på husnummer';
COMMENT ON COLUMN api.husnummer.postcodeIdentifier IS 'postnummer på husnummer';
COMMENT ON COLUMN api.husnummer.districtName IS 'Postnummer navn på husnummer';
COMMENT ON COLUMN api.husnummer.presentationstring IS 'Præsentationsform for et husnummer';
COMMENT ON COLUMN api.husnummer.vejpunkt_geometri IS 'Geometri for vejpunkt i valgt koordinatsystem';
COMMENT ON COLUMN api.husnummer.adgangspunkt_geometri IS 'Geometri for adgangspunkt i valgt koordinatsystem';

-- Husnummer script requires navngivenvej script to be executed first

DROP TABLE IF EXISTS basic.husnummer;
WITH husnumre AS 
(
  SELECT
    h.id,
    h.adgangsadressebetegnelse,
    h.husnummertekst AS husnummertekst,
    h.navngivenvej AS vejid,
    n.vejnavn,
    h.vejkode,
    h.kommunekode,
    k.navn as kommunenavn,
    p.postnr as postnr,
    p.navn as postdistrikt,
    st_force2d(COALESCE(ap.geometri)) as adgangspunkt_geometri,
    st_force2d(COALESCE(ap2.geometri)) as vejpunkt_geometri
  FROM
    dar.husnummer h
    JOIN dar.navngivenvej n ON n.id = h.navngivenvej::uuid
    JOIN dar.postnummer p ON p.id = h.postnummer::uuid
    JOIN dar.adressepunkt ap ON ap.id = h.adgangspunkt
    JOIN dar.adressepunkt ap2 ON ap2.id = h.vejpunkt
    JOIN dagi_500.kommuneinddeling k ON k.kommunekode = h.kommunekode
)
SELECT
  h.id,
  h.adgangsadressebetegnelse as titel,
  h.husnummertekst,
  h.vejnavn,
  h.vejkode,
  h.kommunekode,
  h.kommunenavn,
  h.postnr AS postnummer,
  h.postdistrikt,
  h.vejid,
  nv.textsearchable_plain_col AS textsearchable_plain_col_vej,
  nv.textsearchable_unaccent_col AS textsearchable_unaccent_col_vej,
  nv.textsearchable_phonetic_col AS textsearchable_phonetic_col_vej,
  ROW_NUMBER() OVER
    (PARTITION BY h.vejid ORDER BY
    (substring(h.husnummertekst::text FROM '[0-9]*')),
     substring(h.husnummertekst::text FROM '[0-9]*([A-Z])') NULLS FIRST
    ) AS sortering,
  st_multi(h.adgangspunkt_geometri) as adgangspunkt_geometri,
  st_multi(h.vejpunkt_geometri) as vejpunkt_geometri
INTO
  basic.husnummer
FROM 
  husnumre h
  JOIN basic.navngivenvej nv ON h.vejid = nv.id
;

-- USE TEXTSEARCHABLE COLUMNS FROM NAVNGIVENVEJ INSTEAD OF RECOMPUTING THEM

-- ALTER TABLE api.husnummer DROP COLUMN IF EXISTS textsearchable_index_col_vej;
-- ALTER TABLE api.husnummer
-- ADD COLUMN textsearchable_index_col_vej tsvector
-- GENERATED ALWAYS AS
--   (
--    setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 1)), 'A') ||
--     setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 2)), 'B') ||
--     setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 3)), 'C') ||
--     setweight(to_tsvector('api.septima_fts_config', api.split_and_endsubstring(vejnavn, 4)), 'D')
--   ) STORED
-- ;

-- ALTER TABLE api.husnummer DROP COLUMN IF EXISTS textsearchable_rank_col_vej;
-- ALTER TABLE api.husnummer
-- ADD COLUMN textsearchable_rank_col_vej tsvector
-- GENERATED ALWAYS AS
--   (
--    setweight(to_tsvector('simple', split_part(coalesce(vejnavn, ''), ' ', 1)), 'A') ||
--     setweight(to_tsvector('simple', split_part(coalesce(vejnavn, ''), ' ', 2)), 'B') ||
--     setweight(to_tsvector('simple', split_part(coalesce(vejnavn, ''), ' ', 3)), 'C') ||
--     setweight(to_tsvector('simple', api.split_and_endsubstring(vejnavn, 4)), 'D')
--   ) STORED
-- ;

CREATE INDEX ON basic.husnummer USING GIN (textsearchable_plain_col_vej);
CREATE INDEX ON basic.husnummer USING GIN (textsearchable_unaccent_col_vej);
CREATE INDEX ON basic.husnummer USING GIN (textsearchable_phonetic_col_vej);
CREATE INDEX ON basic.husnummer (lower(vejnavn), vejid, sortering);

DROP FUNCTION IF EXISTS api.husnummer(text, text, int, int);
CREATE OR REPLACE FUNCTION api.husnummer(input_tekst text, filters text, sortoptions int, rowlimit int)
 RETURNS SETOF api.husnummer
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE 
  max_rows integer;
  query_string TEXT;
  plain_query_string TEXT;
  husnummer TEXT := '1=1';
  stmt TEXT;
BEGIN
  -- Initialize
  max_rows = 100;
  IF rowlimit > max_rows THEN
    RAISE 'rowlimit skal være <= %', max_rows;
  END IF;
  
  IF filters IS NULL THEN
    filters = '1=1';
  END IF;

  IF btrim(input_tekst) = Any('{.,-, '', \,}')  THEN
    input_tekst = '';
  END IF;
  
  -- If husnummer at end of input then store it and query rest on vejnavn
  IF regexp_replace(btrim(coalesce(input_tekst, '')), '^.* ', '') ~* '^[0-9]' THEN

    -- Get husnummer from input
    SELECT regexp_replace(btrim(coalesce(input_tekst)), '^.* ', '') INTO husnummer; 

    -- Build the query_string (converting vejnavn of input to phonetic)
    WITH tokens AS (
      SELECT UNNEST(
        string_to_array(
          btrim(
            replace(btrim(input_tekst), husnummer, '')
        ), 
        ' ')
      )
    t)
    SELECT string_agg(fonetik.fnfonetik(t,2), ':* <-> ') || ':*' FROM tokens INTO query_string;

    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
      SELECT UNNEST(
        string_to_array(
          btrim(
            replace(btrim(input_tekst), husnummer, '')
        ), 
        ' ')
      )
    t)
    SELECT string_agg(t, ':* <-> ') || ':*' FROM tokens INTO plain_query_string;
    
    husnummer := 'husnummertekst ilike ''' || husnummer || ''''; -- Set husnummer where statement to stored husnummer after it's been used to replace in inputstring

  -- If no husnummer at end of input query as if it was just vejnavn  
  ELSE
    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
    SELECT string_agg(fonetik.fnfonetik(t,2), ':* <-> ') || ':*' FROM tokens INTO query_string;
    
  
    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
    SELECT string_agg(t, ':* <-> ') || ':*' FROM tokens INTO plain_query_string;

  END IF;

  -- Execute and return the result
  IF (SELECT COALESCE(forekomster, 0) FROM basic.tekst_forekomst WHERE ressource = 'adresse' AND lower(input_tekst) = tekstelement) > 1000 
      AND filters = '1=1' THEN
    stmt = format(E'SELECT
      id::text, kommunekode::text, kommunenavn::text, vejkode::text, vejnavn::text, 
      husnummertekst::text, postnummer::text, postdistrikt::text, titel::text, 
      vejpunkt_geometri, adgangspunkt_geometri,
      0::float AS rank1,
      0::float AS rank2
    FROM
      basic.husnummer
    WHERE
      lower(vejnavn) >= ''%s'' AND lower(vejnavn) <= ''%s'' || ''å''
    ORDER BY
      lower(vejnavn), vejid, sortering
    LIMIT $3;', input_tekst, input_tekst);
--   RAISE notice '%', stmt;
    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
  ELSE
    stmt = format(E'SELECT
      id::text, kommunekode::text, kommunenavn::text, vejkode::text, vejnavn::text, 
      husnummertekst::text, postnummer::text, postdistrikt::text, titel::text, 
      vejpunkt_geometri, adgangspunkt_geometri,
      basic.combine_rank($2, $2, textsearchable_plain_col_vej, textsearchable_unaccent_col_vej, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
      ts_rank_cd(textsearchable_phonetic_col_vej, to_tsquery(''simple'',$1))::double precision AS rank2
    FROM
      basic.husnummer
    WHERE
      (textsearchable_phonetic_col_vej @@ to_tsquery(''simple'', $1)
      OR textsearchable_plain_col_vej @@ to_tsquery(''simple'', $2))
      AND %s
    ORDER BY
      rank1 desc, rank2 desc,
      titel
    LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
  END IF;
END
$function$
;


-- Test cases:
/*
SELECT (api.husnummer('park allé 2',NULL, 1, 100)).*;
SELECT (api.husnummer('ålbor 5',NULL, 1, 100)).*;
SELECT (api.husnummer('søborg h 100',NULL, 1, 100)).*;
SELECT (api.husnummer('holbæk',NULL, 1, 100)).*;
SELECT (api.husnummer('vinkel 3',NULL, 1, 100)).*;
SELECT (api.husnummer('frederik 7',NULL, 1, 100)).*;
SELECT (api.husnummer('san',NULL, 1, 100)).*;
SELECT (api.husnummer('s',NULL, 1, 100)).*;
*/
