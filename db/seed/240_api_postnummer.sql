SELECT '240_api_postnummer.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.postnummer CASCADE;

CREATE TYPE api.postnummer AS (
    postnummer text,
    postnummernavn text,
    visningstekst text,
    gadepostnummer bool,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.postnummer IS 'Postnummer';

COMMENT ON COLUMN api.postnummer.postnummer IS 'Postnummer';

COMMENT ON COLUMN api.postnummer.postnummernavn IS 'Navn på postnummernavn';

COMMENT ON COLUMN api.postnummer.visningstekst IS 'Præsentationsform for et postnummernavn';

COMMENT ON COLUMN api.postnummer.gadepostnummer IS 'Dækker postnummeret kun en gade';

COMMENT ON COLUMN api.postnummer.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.postnummer.bbox IS 'Geometriens boundingbox i EPSG:25832';

DROP TABLE IF EXISTS basic.postnummer;

WITH postnumre AS (
    SELECT
        COALESCE(p2.postnummer, p1.postnummer) AS postnummer,
        COALESCE(p2.navn, p1.navn) AS postnummernavn,
        COALESCE(p2.ergadepostnummer, p1.ergadepostnummer) AS ergadepostnummer,
        st_force2d (COALESCE(p2.geometri, p1.geometri)) AS geometri
    FROM
        dagi_10.postnummerinddeling p1
        LEFT JOIN dagi_500.postnummerinddeling p2 USING (postnummer))
SELECT
    p.postnummer || ' ' || p.postnummernavn AS visningstekst,
    coalesce(p.postnummer, '') AS postnummer,
    coalesce(p.postnummernavn, '') AS postnummernavn,
    (p.ergadepostnummer = 'true') AS ergadepostnummer,
    st_multi (st_union (p.geometri)) AS geometri,
    st_extent (p.geometri) AS bbox,
    array_agg(k.kommunekode) AS kommunekoder INTO basic.postnummer
FROM
    postnumre p
    LEFT JOIN dagi_500.kommuneinddeling k ON (st_intersects (k.geometri, p.geometri))
GROUP BY
    p.postnummer,
    p.postnummernavn,
    p.ergadepostnummer;

ALTER TABLE basic.postnummer
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.postnummer
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', postnummer), 'A') ||
                         setweight(to_tsvector('simple', split_part(postnummernavn, ' ', 1)), 'B') ||
                         setweight(to_tsvector('simple', split_part(postnummernavn, ' ', 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring (postnummernavn, 3)), 'D'))
    STORED;

ALTER TABLE basic.postnummer
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.postnummer
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', postnummer), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(postnummernavn, ' ', 1)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(postnummernavn, ' ', 2)), 'C') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (postnummernavn, 3)), 'D'))
    STORED;

ALTER TABLE basic.postnummer
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.postnummer
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', postnummer), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(postnummernavn, ' ', 1), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(postnummernavn, ' ', 2), 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (postnummernavn, 3)), 'D'))
    STORED;

CREATE INDEX ON basic.postnummer USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.postnummer USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.postnummer USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.postnummer (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.postnummer (input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.postnummer
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    input_postnummernavn text;
    input_postnummer text;
    postnummernavn_string text;
    postnummernavn_string_plain text;
    postnummer_string text;
    query_string text;
    plain_query_string text;
    stmt text;
BEGIN
    -- Initialize
    max_rows = 1000;
    IF rowlimit > max_rows THEN
        RAISE 'rowlimit skal være <= %', max_rows;
    END IF;
    IF filters IS NULL THEN
        filters = '1=1';
    END IF;
    -- Build the query_string
    IF btrim(input_tekst) = ANY ('{.,-, '', \,}') THEN
        input_tekst = '';
    END IF;
    SELECT
        -- matches non-digits
        btrim((REGEXP_MATCH(btrim(input_tekst), '([^\d]+)'))[1])
    INTO input_postnummernavn;
    SELECT
        -- Removes everything that starts with a letter or symbol (not digits) and then removes repeated whitespace.
        btrim(regexp_replace(regexp_replace(input_tekst, '((?<!\S)\D\S*)', '', 'g'), '\s+', ' '))
    INTO input_postnummer;
    --RAISE NOTICE 'input_postnummernavn: %', input_postnummernavn;
    --RAISE NOTICE 'input_postnummer: %', input_postnummer;
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_postnummernavn, ' ')) t
)
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO postnummernavn_string;
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_postnummernavn, ' ')) t
)
    SELECT
        string_agg(t, ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO postnummernavn_string_plain;
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_postnummer, ' ')) t
)
    SELECT
        string_agg(t, ':A | ') || ':A'
    FROM
        tokens INTO postnummer_string;
    --RAISE NOTICE 'postnummernavn_string: %', postnummernavn_string;
    --RAISE NOTICE 'postnummernavn_string_plain: %', postnummernavn_string_plain;
    --RAISE NOTICE 'postnummer_string: %', postnummer_string;
    CASE WHEN postnummernavn_string IS NULL THEN
        SELECT
            postnummer_string INTO query_string;
    WHEN postnummer_string IS NULL THEN
        SELECT
            postnummernavn_string INTO query_string;
        ELSE
            SELECT
                postnummernavn_string || ' | ' || postnummer_string INTO query_string;
    END CASE;
    CASE WHEN postnummernavn_string_plain IS NULL THEN
        SELECT
            postnummer_string INTO plain_query_string;
    WHEN postnummer_string IS NULL THEN
        SELECT
            postnummernavn_string_plain INTO plain_query_string;
        ELSE
            SELECT
                postnummernavn_string_plain || ' | ' || postnummer_string INTO plain_query_string;
    END CASE;
    --RAISE NOTICE 'query_string: %', query_string; RAISE NOTICE 'plain_query_string: %', plain_query_string;
    -- Execute and return the result
    stmt = format(E'SELECT
            postnummer::text, postnummernavn::text, visningstekst, ergadepostnummer, geometri, bbox::geometry
            FROM
                basic.postnummer
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
                basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) desc,
                ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision desc,
                postnummernavn
            LIMIT $3
            ;', filters); RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
    END
$function$;
-- Test cases:
/*
 SELECT (api.postnummer('lyn',NULL, 1, 100)).*;
 SELECT (api.postnummer('københavn s',NULL, 1, 100)).*;
 SELECT (api.postnummer('københavn k',NULL, 1, 100)).*;
 SELECT (api.postnummer('sø',NULL, 1, 100)).*;
 SELECT (api.postnummer('2300 søborg',NULL, 1, 100)).*;
 SELECT (api.postnummer('århus v',NULL, 1, 100)).*;
 SELECT (api.postnummer('ålborg øs',NULL, 1, 100)).*;
 SELECT (api.postnummer('køben ø',NULL, 1, 100)).*;
 SELECT (api.postnummer('Age',NULL, 1, 100)).*;
 SELECT (api.postnummer('.',NULL, 1, 100)).*;
 SELECT (api.postnummer(null,NULL, 1, 100)).*;

 SELECT	(api.postnummer('a 1 a',	NULL,	1,	100)).*;

 SELECT	(api.postnummer('Anholt 8961',	NULL,	1,	100)).*;

 SELECT	(api.postnummer('6753 Lyngby',	NULL,	1,	100)).*;

SELECT	(api.postnummer('Anholt Ans By Ansager Arden Asaa',	NULL,	1,	100)).*;

SELECT	(api.postnummer('5320 6753 6534 4244 2620 3450 3770 8961',	NULL,	1,	100)).*;

 */
