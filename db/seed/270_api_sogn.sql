SELECT '270_api_sogn.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.sogn CASCADE;

CREATE TYPE api.sogn AS (
    sognekode text,
    sognenavn text,
    praesentation text,
    geometri geometry,
    bbox geometry,
    rang1 double precision,
    rang2 double precision
);

COMMENT ON TYPE api.sogn IS 'Sogn';

COMMENT ON COLUMN api.sogn.sognekode IS 'Sognekode';

COMMENT ON COLUMN api.sogn.sognenavn IS 'Navn på sogn';

COMMENT ON COLUMN api.sogn.praesentation IS 'Præsentationsform for et sogn';

COMMENT ON COLUMN api.sogn.geometri IS 'Geometri i valgt koordinatsystem';

COMMENT ON COLUMN api.sogn.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';

DROP TABLE IF EXISTS basic.sogn;

WITH sogne AS (
    SELECT
        s.sognekode,
        s.navn,
        st_force2d (s.geometri) AS geometri
    FROM
        dagi_500.sogneinddeling s
)
SELECT
    s.navn || ' sogn' AS praesentation,
    s.sognekode,
    coalesce(s.navn, '') AS sognenavn,
    st_multi (st_union (s.geometri)) AS geometri,
    st_extent (s.geometri) AS bbox INTO basic.sogn
FROM
    sogne s
GROUP BY
    s.sognekode,
    s.navn;

ALTER TABLE basic.sogn
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.sogn
    ADD COLUMN textsearchable_plain_col tsvector GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(sognenavn, ' ', 1)), 'A') || setweight(to_tsvector('simple', split_part(sognenavn, ' ', 2)), 'B') || setweight(to_tsvector('simple', split_part(sognenavn, ' ', 3)), 'C') || setweight(to_tsvector('simple', basic.split_and_endsubstring (sognenavn, 4)), 'D')) STORED;

ALTER TABLE basic.sogn
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.sogn
    ADD COLUMN textsearchable_unaccent_col tsvector GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', split_part(sognenavn, ' ', 1)), 'A') || setweight(to_tsvector('basic.septima_fts_config', split_part(sognenavn, ' ', 2)), 'B') || setweight(to_tsvector('basic.septima_fts_config', split_part(sognenavn, ' ', 3)), 'C') || setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (sognenavn, 4)), 'D')) STORED;

ALTER TABLE basic.sogn
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.sogn
    ADD COLUMN textsearchable_phonetic_col tsvector GENERATED ALWAYS AS (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(sognenavn, ' ', 1), 2)), 'A') || setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(sognenavn, ' ', 2), 2)), 'B') || setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(sognenavn, ' ', 3), 2)), 'C') || setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (sognenavn, 4)), 'D')) STORED;

CREATE INDEX ON basic.sogn USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.sogn USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.sogn USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.sogn (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.sogn (input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.sogn
    LANGUAGE plpgsql
    SECURITY DEFINER
    STABLE
    AS $function$
DECLARE
    max_rows integer;
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
    IF btrim(input_tekst) = ANY ('{.,-, '', \,}') THEN
        input_tekst = '';
    END IF;
    -- Build the query_string
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
)
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':* <-> ') || ':*'
    FROM
        tokens INTO query_string;
    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
)
    SELECT
        string_agg(t, ':* <-> ') || ':*'
    FROM
        tokens INTO plain_query_string;
    -- Execute and return the result
    stmt = format(E'SELECT
            sognekode::text, sognenavn::text, praesentation, geometri, bbox::geometry,
            basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
            ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
            FROM
            basic.sogn
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
            rank1 desc, rank2 desc,
            praesentation
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
END
$function$;

-- Test cases:
/*
 SELECT (api.sogn('fars',NULL, 1, 100)).*;
 SELECT (api.sogn('ege',NULL, 1, 100)).*;
 SELECT (api.sogn('århus',NULL, 1, 100)).*;
 */
