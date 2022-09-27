DROP TYPE IF EXISTS api.matrikelnummer CASCADE;
CREATE TYPE api.matrikelnummer AS (
  elavsnavn TEXT,
  elavskode TEXT,
  matrNr TEXT,
  presentationstring TEXT,
  centroid_x TEXT,
  centroid_y TEXT,
  geometri geometry,
  rang1 double precision,
  rang2 double precision
);  

COMMENT ON TYPE api.matrikelnummer IS 'Matrikelnummer';
COMMENT ON COLUMN api.matrikelnummer.elavsnavn IS 'Elavsnavn for matrikel';
COMMENT ON COLUMN api.matrikelnummer.elavskode IS 'Elavskode for matrikel';
COMMENT ON COLUMN api.matrikelnummer.matrNr IS 'Matrikelnummer';
COMMENT ON COLUMN api.matrikelnummer.presentationstring IS 'Præsentationsform for et matrikelnummer';
COMMENT ON COLUMN api.matrikelnummer.centroid_x IS 'Centroide X for matriklens geometri';
COMMENT ON COLUMN api.matrikelnummer.centroid_y IS 'Centroide Y for matriklens geometri';
COMMENT ON COLUMN api.matrikelnummer.geometri IS 'Geometri i valgt koordinatsystem';



DROP TABLE IF EXISTS basic.matrikelnummer;
with matrikelnumre AS 
(
	SELECT
    coalesce(j.elavsnavn, '') AS elavsnavn,
    coalesce(j.elavskode::text, '') AS elavskode,
    coalesce(j.komnavn, '') AS komnavn,
    coalesce(j.matrnr, '') AS matrnr,
    c.wkb_geometry AS centroide_geometri,
    st_force2d(COALESCE(j.wkb_geometry)) as geometri
  	FROM
		-- mat.jordstykke j
    --JOIN mat.ejerlav e ON j.ejerlavlokalid = e.id_lokalid
    mat_kf.jordstykke j
    JOIN mat_kf.centroide c ON c.elavskode = j.elavskode AND c.matrnr = j.matrnr
)
, elavsnavn_dups AS 
(
	select 
		count(1) elavsnavn_count, 
		elavsnavn,  
		(setweight(to_tsvector('simple', split_part(elavsnavn, ' ', 1)), 'B') ||
		setweight(to_tsvector('simple', split_part(elavsnavn, ' ', 2)), 'C') ||
    	setweight(to_tsvector('simple', basic.split_and_endsubstring(elavsnavn, 3)), 'D')) 
		AS textsearchable_plain_col_elavsnavn,
		(setweight(to_tsvector('basic.septima_fts_config', split_part(elavsnavn, ' ', 1)), 'B') ||
		setweight(to_tsvector('basic.septima_fts_config', split_part(elavsnavn, ' ', 2)), 'C') ||
    	setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring(elavsnavn, 3)), 'D')) 
		AS textsearchable_unaccent_col_elavsnavn,
		(setweight(to_tsvector('simple',  fonetik.fnfonetik(split_part(elavsnavn, ' ', 1), 2)), 'B') ||
		setweight(to_tsvector('simple',  fonetik.fnfonetik(split_part(elavsnavn, ' ', 2), 2)), 'C') ||
    	setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik(elavsnavn, 3)), 'D'))
		AS textsearchable_phonetic_col_elavsnavn
	from ( 
		SELECT distinct elavsnavn, elavskode, komnavn
		FROM matrikelnumre
	) x GROUP by elavsnavn
)

SELECT
  m.elavsnavn || CASE
                  WHEN elavsnavn_count > 1 THEN ' (' || m.komnavn || ')' || ' - ' || m.matrnr 
                  ELSE '' || ' - ' || m.matrnr END AS titel,
  m.elavsnavn,
  m.elavskode,
  m.matrnr,
  m.centroide_geometri,
  e.textsearchable_plain_col_elavsnavn,
  e.textsearchable_unaccent_col_elavsnavn,
  e.textsearchable_phonetic_col_elavsnavn,
  st_multi(m.geometri) as geometri
INTO
  basic.matrikelnummer
FROM 
  matrikelnumre m
  JOIN elavsnavn_dups e ON e.elavsnavn = m.elavsnavn
;

ALTER TABLE basic.matrikelnummer DROP COLUMN IF EXISTS textsearchable_plain_col;
ALTER TABLE basic.matrikelnummer
ADD COLUMN textsearchable_plain_col tsvector
GENERATED ALWAYS AS
   (
	  textsearchable_plain_col_elavsnavn ||
    setweight(to_tsvector('simple', elavskode), 'A') ||
    setweight(to_tsvector('simple', matrnr), 'A')
   ) STORED
;

ALTER TABLE basic.matrikelnummer DROP COLUMN IF EXISTS textsearchable_unaccent_col;
ALTER TABLE basic.matrikelnummer
ADD COLUMN textsearchable_unaccent_col tsvector
GENERATED ALWAYS AS
   (
	  textsearchable_unaccent_col_elavsnavn ||
    setweight(to_tsvector('simple', elavskode), 'A') ||
    setweight(to_tsvector('simple', matrnr), 'A')
   ) STORED
;

ALTER TABLE basic.matrikelnummer DROP COLUMN IF EXISTS textsearchable_phonetic_col;
ALTER TABLE basic.matrikelnummer
ADD COLUMN textsearchable_phonetic_col tsvector
GENERATED ALWAYS AS
   (
	  textsearchable_phonetic_col_elavsnavn ||
    setweight(to_tsvector('simple', elavskode), 'A') ||
    setweight(to_tsvector('simple', matrnr), 'A')
   ) STORED
;

CREATE INDEX ON basic.matrikelnummer USING GIN (textsearchable_plain_col);
CREATE INDEX ON basic.matrikelnummer USING GIN (textsearchable_unaccent_col);
CREATE INDEX ON basic.matrikelnummer USING GIN (textsearchable_phonetic_col);



DROP FUNCTION IF EXISTS api.matrikelnummer(text, text, int, int);
CREATE OR REPLACE FUNCTION api.matrikelnummer(input_tekst text, filters text, sortoptions int, rowlimit int)
  RETURNS SETOF api.matrikelnummer
  LANGUAGE plpgsql
  STABLE
AS $function$
DECLARE 
  max_rows integer;
  input_elavsnavn TEXT;
  input_elavskode_matrnr TEXT;
  elavsnavn_string TEXT;
  elavsnavn_string_plain TEXT;
  elavskode_matrnr_string TEXT;
  query_string TEXT;
	plain_query_string TEXT;
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

  SELECT btrim(regexp_replace(input_tekst, '(?<!\S)\d\S*', '', 'g')) INTO input_elavsnavn; -- matches non-digits
  SELECT btrim(regexp_replace(regexp_replace(input_tekst, '((?<!\S)\D\S*)', '', 'g'), '\s+', ' ')) INTO input_elavskode_matrnr; --matches digits
  
  WITH tokens AS (SELECT UNNEST(string_to_array(input_elavsnavn, ' ')) t)
  SELECT string_agg(t, ':* <-> ') || ':*' FROM tokens INTO elavsnavn_string_plain;
	
	WITH tokens AS (SELECT UNNEST(string_to_array(input_elavsnavn, ' ')) t)
    SELECT string_agg(fonetik.fnfonetik(t,2), ':* <-> ') || ':*' FROM tokens INTO elavsnavn_string;

  WITH tokens AS (SELECT UNNEST(string_to_array(input_elavskode_matrnr, ' ')) t)
    SELECT string_agg(t, ' & ') FROM tokens INTO elavskode_matrnr_string;

  CASE
    WHEN elavsnavn_string IS NULL THEN SELECT elavskode_matrnr_string INTO query_string;
    WHEN elavskode_matrnr_string IS NULL THEN SELECT elavsnavn_string INTO query_string;
    ELSE SELECT elavsnavn_string || ' | ' || elavskode_matrnr_string INTO query_string;
  END CASE;
	
	CASE
      WHEN elavsnavn_string_plain IS NULL THEN SELECT elavskode_matrnr_string INTO plain_query_string;
      WHEN elavskode_matrnr_string IS NULL THEN SELECT elavsnavn_string_plain INTO plain_query_string;
      ELSE SELECT elavsnavn_string_plain || ' | ' || elavskode_matrnr_string INTO plain_query_string;
  END CASE;


  -- Execute and return the result
  stmt = format(E'SELECT
    elavsnavn::text, elavskode::text, matrnr::text, titel::text, 
    ST_X((ST_DUMP(centroide_geometri)).geom)::text, ST_Y((ST_DUMP(centroide_geometri)).geom)::text,
    geometri,
    basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
    ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2    
  FROM
    basic.matrikelnummer
  WHERE (
    textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
    OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
    AND %s
  ORDER BY
    rank1 desc, rank2 desc,
    matrnr, titel
  LIMIT $3
  ;', filters);
  RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
END
$function$
;

-- Test cases:
/*
SELECT (api.matrikelnummer('søby',NULL, 1, 100)).*;
SELECT (api.matrikelnummer('11aa',NULL, 1, 100)).*;
SELECT (api.matrikelnummer('1320452',NULL, 1, 100)).*;
SELECT (api.matrikelnummer('11aa 1320452',NULL, 1, 100)).*;
SELECT (api.matrikelnummer('1320452 11aa kobbe',NULL, 1, 100)).*;
SELECT (api.matrikelnummer('11aa søby',NULL, 1, 100)).*;
SELECT (api.matrikelnummer('s',NULL, 1, 100)).*;
*/
