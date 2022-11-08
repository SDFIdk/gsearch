SELECT '240_api_postdistrikt.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.postdistrikt CASCADE;

CREATE TYPE api.postdistrikt AS (
    postnummer text,
    postdistrikt text,
    praesentation text,
    gadepostnummer bool,
    geometri geometry,
    bbox geometry,
    rang1 double precision,
    rang2 double precision
);

COMMENT ON TYPE api.postdistrikt IS 'Postdistrikt';

COMMENT ON COLUMN api.postdistrikt.postnummer IS 'Postnummer';

COMMENT ON COLUMN api.postdistrikt.postdistrikt IS 'Navn på postdistrikt';

COMMENT ON COLUMN api.postdistrikt.praesentation IS 'Præsentationsform for et postdistrikt';

COMMENT ON COLUMN api.postdistrikt.gadepostnummer IS 'Dækker postnummeret kun en gade';

COMMENT ON COLUMN api.postdistrikt.geometri IS 'Geometri i valgt koordinatsystem';

COMMENT ON COLUMN api.postdistrikt.bbox IS 'Geometriens boundingbox i valgt koordinatsystem';

DROP TABLE IF EXISTS basic.postdistrikt;

WITH postnumre AS (
    SELECT
        COALESCE(p2.postnummer, p1.postnummer) AS postnummer,
        COALESCE(p2.navn, p1.navn) AS postdistrikt,
        COALESCE(p2.ergadepostnummer, p1.ergadepostnummer) AS ergadepostnummer,
        st_force2d (COALESCE(p2.geometri, p1.geometri)) AS geometri
    FROM
        dagi_10.postnummerinddeling p1
        LEFT JOIN dagi_500.postnummerinddeling p2 USING (postnummer))
SELECT
    p.postnummer || ' ' || p.postdistrikt AS praesentation,
    coalesce(p.postnummer, '') AS postnummer,
    coalesce(p.postdistrikt, '') AS postdistrikt,
    (p.ergadepostnummer = 'true') AS ergadepostnummer,
    st_multi (st_union (p.geometri)) AS geometri,
    st_extent (p.geometri) AS bbox,
    array_agg(k.kommunekode) AS kommunekoder INTO basic.postdistrikt
FROM
    postnumre p
    LEFT JOIN dagi_500.kommuneinddeling k ON (st_intersects (k.geometri, p.geometri))
GROUP BY
    p.postnummer,
    p.postdistrikt,
    p.ergadepostnummer;

ALTER TABLE basic.postdistrikt
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.postdistrikt
    ADD COLUMN textsearchable_plain_col tsvector GENERATED ALWAYS AS (setweight(to_tsvector('simple', postnummer), 'A') || setweight(to_tsvector('simple', split_part(postdistrikt, ' ', 1)), 'B') || setweight(to_tsvector('simple', split_part(postdistrikt, ' ', 2)), 'C') || setweight(to_tsvector('simple', basic.split_and_endsubstring (postdistrikt, 3)), 'D')) STORED;

ALTER TABLE basic.postdistrikt
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.postdistrikt
    ADD COLUMN textsearchable_unaccent_col tsvector GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', postnummer), 'A') || setweight(to_tsvector('basic.septima_fts_config', split_part(postdistrikt, ' ', 1)), 'B') || setweight(to_tsvector('basic.septima_fts_config', split_part(postdistrikt, ' ', 2)), 'C') || setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (postdistrikt, 3)), 'D')) STORED;

ALTER TABLE basic.postdistrikt
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.postdistrikt
    ADD COLUMN textsearchable_phonetic_col tsvector GENERATED ALWAYS AS (setweight(to_tsvector('simple', postnummer), 'A') || setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(postdistrikt, ' ', 1), 2)), 'B') || setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(postdistrikt, ' ', 2), 2)), 'C') || setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (postdistrikt, 3)), 'D')) STORED;

CREATE INDEX ON basic.postdistrikt USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.postdistrikt USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.postdistrikt USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.postdistrikt (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.postdistrikt (input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.postdistrikt
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    input_postdistrikt text;
    input_postnummer text;
    postdistrikt_string text;
    postdistrikt_string_plain text;
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
        btrim(regexp_replace(input_tekst, '(?<!\S)\d\S*', '', 'g')) INTO input_postdistrikt;
    -- matches non-digits
    SELECT
        btrim(regexp_replace(regexp_replace(input_tekst, '((?<!\S)\D\S*)', '', 'g'), '\s+', ' ')) INTO input_postnummer;
    --matches digits
    --RAISE NOTICE 'input_postdistrikt: %', input_postdistrikt;
    --RAISE NOTICE 'input_postnummer: %', input_postnummer;
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_postdistrikt, ' ')) t
)
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO postdistrikt_string;
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_postdistrikt, ' ')) t
)
    SELECT
        string_agg(t, ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO postdistrikt_string_plain;
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_postnummer, ' ')) t
)
    SELECT
        string_agg(t, ':A | ') || ':A'
    FROM
        tokens INTO postnummer_string;
    --RAISE NOTICE 'postdistrikt_string: %', postdistrikt_string;
    --RAISE NOTICE 'postdistrikt_string_plain: %', postdistrikt_string_plain;
    --RAISE NOTICE 'postnummer_string: %', postnummer_string;
    CASE WHEN postdistrikt_string IS NULL THEN
        SELECT
            postnummer_string INTO query_string;
    WHEN postnummer_string IS NULL THEN
        SELECT
            postdistrikt_string INTO query_string;
        ELSE
            SELECT
                postdistrikt_string || ' | ' || postnummer_string INTO query_string;
    END CASE;
    CASE WHEN postdistrikt_string_plain IS NULL THEN
        SELECT
            postnummer_string INTO plain_query_string;
    WHEN postnummer_string IS NULL THEN
        SELECT
            postdistrikt_string_plain INTO plain_query_string;
        ELSE
            SELECT
                postdistrikt_string_plain || ' | ' || postnummer_string INTO plain_query_string;
    END CASE;
    --RAISE NOTICE 'query_string: %', query_string; RAISE NOTICE 'plain_query_string: %', plain_query_string;
    -- Execute and return the result
    stmt = format(E'SELECT
            postnummer::text, postdistrikt::text, praesentation, ergadepostnummer, geometri, bbox::geometry,
            basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rank1,
            ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rank2
            FROM
            basic.postdistrikt
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
            rank1 desc, rank2 desc,
            postdistrikt
            LIMIT $3
            ;', filters); RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
    END
$function$;
-- Test cases:
/*
 SELECT (api.postdistrikt('lyn',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('københavn s',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('københavn k',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('sø',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('2300 søborg',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('århus v',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('ålborg øs',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('køben ø',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('Age',NULL, 1, 100)).*;
 SELECT (api.postdistrikt('.',NULL, 1, 100)).*;
 SELECT (api.postdistrikt(null,NULL, 1, 100)).*;
 */
