DROP TYPE IF EXISTS api.stednavn CASCADE;
CREATE TYPE api.stednavn AS (
  id TEXT,
  praesentation TEXT,
  skrivemaade TEXT,
  skrivemaade_officiel TEXT,
  skrivemaade_uofficiel TEXT,
  stednavn_type TEXT,
  stednavn_subtype TEXT,
  bbox geometry,
  geometri geometry,
  rang1 double precision,
  rang2 double precision
);  

COMMENT ON TYPE api.stednavn IS 'Stednavn';
COMMENT ON COLUMN api.stednavn.praesentation IS 'Præsentationsform for stednavn';
COMMENT ON COLUMN api.stednavn.id IS 'Id for stednavn';
COMMENT ON COLUMN api.stednavn.skrivemaade IS 'Skrivemaade for stednavn';
COMMENT ON COLUMN api.stednavn.skrivemaade_officiel IS 'Officiel skrivemaade for stednavn';
COMMENT ON COLUMN api.stednavn.skrivemaade_uofficiel IS 'Uofficiel skrivemaade for stednavn';
COMMENT ON COLUMN api.stednavn.stednavn_type IS 'Type på stednavn';
COMMENT ON COLUMN api.stednavn.stednavn_subtype IS 'Subtype på stednavn';
COMMENT ON COLUMN api.stednavn.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';
COMMENT ON COLUMN api.stednavn.geometri IS 'Geometri i valgt koordinatsystem';

DROP TABLE IF EXISTS basic.stednavn_mv;
with stednavne AS (
	SELECT
		objectid,
		id_lokalid,
		coalesce(presentationstring, '') AS presentationstring,
		navnestatus,
		skrivemaade,
		type,
		subtype,
		municipality_filter,
		st_force2d(geometri_udtyndet) AS geometri
  	FROM
		stednavne_udstil.stednavn_udstilling
), 
agg_stednavne AS (
	SELECT 
		s.*, 
		u.uofficielle_skrivemaader
	FROM ( 
		SELECT * 
		FROM stednavne
		WHERE navnestatus <> 'uofficielt'
	) s
	LEFT JOIN (
		SELECT string_agg(skrivemaade, ';') uofficielle_skrivemaader, objectid
		FROM stednavne
		where navnestatus = 'uofficielt'
		group by objectid
	) u ON u.objectid = s.objectid
)
SELECT 
	id_lokalid AS id,
	presentationstring,
	replace(presentationstring, '-', ' ') AS presentationstring_nohyphen,
	skrivemaade,
	(
		CASE 
			WHEN uofficielle_skrivemaader IS NULL THEN ''
			ELSE uofficielle_skrivemaader
		END
	) as skrivemaade_uofficiel,
	(
		CASE 
			WHEN uofficielle_skrivemaader IS NULL THEN ''
			ELSE replace(uofficielle_skrivemaader, '-', ' ')
		END
	) as skrivemaade_uofficiel_nohyphen,
	type AS stednavn_type,
	subtype AS stednavn_subtype,
	st_multi(st_union(geometri)) AS geometri,
	st_envelope(st_collect(geometri)) AS bbox
INTO basic.stednavn_mv
FROM agg_stednavne
GROUP BY id,presentationstring, presentationstring_nohyphen, skrivemaade, skrivemaade_uofficiel, skrivemaade_uofficiel_nohyphen, type, subtype
;

ALTER TABLE basic.stednavn_mv DROP COLUMN IF EXISTS textsearchable_plain_col;
ALTER TABLE basic.stednavn_mv
ADD COLUMN textsearchable_plain_col tsvector
GENERATED ALWAYS AS
   (
	setweight(to_tsvector('simple', split_part(presentationstring, ' ', 1)), 'A') ||
    setweight(to_tsvector('simple', split_part(presentationstring, ' ', 2)), 'B') ||
    setweight(to_tsvector('simple', basic.split_and_endsubstring((presentationstring), 3)), 'C') ||
	basic.stednavne_uofficielle_tsvector(skrivemaade_uofficiel) 
   ) STORED
;

ALTER TABLE basic.stednavn_mv DROP COLUMN IF EXISTS textsearchable_unaccent_col;
ALTER TABLE basic.stednavn_mv
ADD COLUMN textsearchable_unaccent_col tsvector
GENERATED ALWAYS AS
   (
	setweight(to_tsvector('basic.septima_fts_config', split_part(presentationstring, ' ', 1)), 'A') ||
    setweight(to_tsvector('basic.septima_fts_config', split_part(presentationstring, ' ', 2)), 'B') ||
    setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring(presentationstring, 3)), 'C') ||
	basic.stednavne_uofficielle_tsvector(skrivemaade_uofficiel) 
   ) STORED
;

ALTER TABLE basic.stednavn_mv DROP COLUMN IF EXISTS textsearchable_phonetic_col;
ALTER TABLE basic.stednavn_mv
ADD COLUMN textsearchable_phonetic_col tsvector
GENERATED ALWAYS AS
   (
	setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(presentationstring_nohyphen, ' ', 1), 2)), 'A') ||
    setweight(to_tsvector('simple', fonetik.fnfonetik(split_part(presentationstring_nohyphen, ' ', 2), 2)), 'B') ||
    setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik(presentationstring_nohyphen, 3)), 'C') ||
	basic.stednavne_uofficielle_tsvector_phonetic(skrivemaade_uofficiel_nohyphen) 
   ) STORED
;



CREATE INDEX ON basic.stednavn_mv USING GIN (textsearchable_plain_col);
CREATE INDEX ON basic.stednavn_mv USING GIN (textsearchable_unaccent_col);
CREATE INDEX ON basic.stednavn_mv USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.stednavn(text, text, int, int);
CREATE OR REPLACE FUNCTION api.stednavn(input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.stednavn
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
    
    IF filters IS NULL THEN
        filters = '1=1';
    END IF;

    IF btrim(input_tekst) = Any('{.,-, '', \,}')  THEN
        input_tekst = '';
    END IF;
  
    WITH tokens AS (SELECT UNNEST(string_to_array(btrim(replace(input_tekst, '-', ' ')), ' ')) t)
  	SELECT
    	string_agg(fonetik.fnfonetik(t,2), ':* <-> ') || ':*' FROM tokens INTO query_string;
      
	-- build the plain version of the query string for ranking purposes
	WITH tokens AS (SELECT UNNEST(string_to_array(btrim(input_tekst), ' ')) t)
	SELECT
		string_agg(t, ':* <-> ') || ':*' FROM tokens INTO plain_query_string;

    -- Execute and return the result
    stmt = format(E'SELECT
        id::text, presentationstring::text, skrivemaade::text, skrivemaade::text AS skrivemaade_officiel, 
		skrivemaade_uofficiel::text, stednavn_type::text, stednavn_subtype::text, bbox, geometri,
        basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
	    ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
    FROM
        basic.stednavn_mv
    WHERE (
        textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
        OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
        AND %s
    ORDER BY
        rank1 desc, rank2 desc,
        presentationstring
    LIMIT $3
    ;', filters);
    RETURN QUERY EXECUTE stmt using query_string, plain_query_string, rowlimit;
END
$function$
;

-- Test cases:
/*
SELECT (api.stednavn('tivoli',NULL, 1, 100)).*;
SELECT (api.stednavn('tivoli forlys',NULL, 1, 100)).*;
SELECT (api.stednavn('vuc ringkøb',NULL, 1, 100)).*;
SELECT (api.stednavn('grøngård slot',NULL, 1, 100)).*;
SELECT (api.stednavn('slotsruin',NULL, 1, 100)).*;
SELECT (api.stednavn('uch',NULL, 1, 100)).*;
SELECT (api.stednavn('hc andersen slot',NULL, 1, 100)).*;
SELECT (api.stednavn('s',NULL, 1, 100)).*;
*/
