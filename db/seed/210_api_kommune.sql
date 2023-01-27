SELECT '210_api_kommune.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.kommune CASCADE;

CREATE TYPE api.kommune AS (
    kommunekode text,
    kommunenavn text,
    visningstekst text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.kommune IS 'Kommune';

COMMENT ON COLUMN api.kommune.kommunekode IS 'Kommunekode';

COMMENT ON COLUMN api.kommune.kommunenavn IS 'Navn på kommune';

COMMENT ON COLUMN api.kommune.visningstekst IS 'Præsentationsform for en kommune';

COMMENT ON COLUMN api.kommune.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.kommune.bbox IS 'Geometriens boundingbox i EPSG:25832';

DROP TABLE IF EXISTS basic.kommune;

WITH kommuner AS (
    SELECT
        k.kommunekode,
        k.navn,
        r.regionskode,
        st_force2d (k.geometri) AS geometri
    FROM
        dagi_500.kommuneinddeling k
        LEFT JOIN dagi_500.regionsinddeling r ON k.regionlokalid = r.id_lokalid
)
SELECT
    (
        CASE
            WHEN
                k.kommunekode = '0101'
            THEN
                k.navn || 's Kommune'
            WHEN
                k.kommunekode = '0411'
            THEN
                k.navn
        ELSE
            k.navn || ' Kommune'
        END) AS visningstekst,
    coalesce(k.kommunekode, '') AS kommunekode,
    coalesce(k.navn, '') AS kommunenavn,
    k.regionskode,
    st_multi (st_union (k.geometri)) AS geometri,
    st_extent (k.geometri) AS bbox INTO basic.kommune
FROM
    kommuner k
GROUP BY
    k.kommunekode,
    k.navn,
    k.regionskode;

ALTER TABLE basic.kommune
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.kommune
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', kommunekode), 'A') ||
                         setweight(to_tsvector('simple', split_part(visningstekst, ' ', 1)), 'B') ||
                         setweight(to_tsvector('simple', split_part(visningstekst, ' ', 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring (visningstekst, 3)), 'D'))
    STORED;

ALTER TABLE basic.kommune
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.kommune
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', kommunekode), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(visningstekst, ' ', 1)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(visningstekst, ' ', 2)), 'C') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (visningstekst, 3)), 'D'))
    STORED;

ALTER TABLE basic.kommune
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.kommune
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', kommunekode), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(visningstekst, ' ', 1), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(visningstekst, ' ', 2), 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (visningstekst, 3)), 'D'))
    STORED;

CREATE INDEX ON basic.kommune USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.kommune USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.kommune USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.kommune (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.kommune (input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.kommune
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    input_kommunenavn text;
    input_kommunekode text;
    kommunenavn_string text;
    kommunenavn_string_plain text;
    kommunekode_string text;
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
        -- matches non-digits and removes repeated whitespace and '-'
       regexp_replace(btrim((REGEXP_MATCH(btrim(input_tekst), '([^\d]+)'))[1]), '[- \s]+', ' ', 'g')
    INTO input_kommunenavn;

    SELECT
        -- Removes everything that starts with a letter or symbol (not digits) and then removes repeated whitespace.
        regexp_replace(btrim(regexp_replace(regexp_replace(input_tekst, '((?<!\S)\D\S*)', '', 'g'), '\s+', ' ')) , '\s+', ' ', 'g')
    INTO input_kommunekode;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_kommunenavn, ' ')) t
            )
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':BCD* <-> ') || ':BCD*'
    FROM
        tokens
    INTO kommunenavn_string;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_kommunenavn, ' ')) t
            )
    SELECT
        string_agg(t, ':BCD* <-> ') || ':BCD*'
    FROM
        tokens INTO kommunenavn_string_plain;
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_kommunekode, ' ')) t
            )
    SELECT
        string_agg(t, ':A | ') || ':A'
    FROM
        tokens INTO kommunekode_string;
    CASE WHEN kommunenavn_string IS NULL THEN
        SELECT
            kommunekode_string INTO query_string;
    WHEN kommunekode_string IS NULL THEN
        SELECT
            kommunenavn_string INTO query_string;
        ELSE
            SELECT
                kommunenavn_string || ' | ' || kommunekode_string INTO query_string;
    END CASE;
    CASE WHEN kommunenavn_string_plain IS NULL THEN
        SELECT
            kommunekode_string INTO plain_query_string;
    WHEN kommunekode_string IS NULL THEN
        SELECT
            kommunenavn_string_plain INTO plain_query_string;
        ELSE
            SELECT
                kommunenavn_string_plain || ' | ' || kommunekode_string INTO plain_query_string;
    END CASE;
    -- Execute and return the result
    stmt = format(E'SELECT
            kommunekode::text,
            kommunenavn::text,
            visningstekst,
            geometri,
            bbox::geometry
        FROM
            basic.kommune
        WHERE (
            textsearchable_phonetic_col @@ to_tsquery(''''simple'''', $1)
            OR textsearchable_plain_col @@ to_tsquery(''''simple'''', $2) )
        AND
            %s
        ORDER BY
            basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''''simple''''::regconfig, ''''basic.septima_fts_config''''::regconfig) desc,
            ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''''simple'''',$1))::double precision desc,
        kommunenavn
        LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
    END
$function$;
-- Test cases:
/*
 SELECT (api.kommune('køb',NULL, 1, 100)).*;
 SELECT (api.kommune('ålborg',NULL, 1, 100)).*;
 SELECT (api.kommune('nord',NULL, 1, 100)).*;
 SELECT (api.kommune('0101 fred',NULL, 1, 100)).*;
 SELECT(api.kommune('a 1 a',NULL,1,100)).*;
 SELECT(api.kommune('Lyngby-Tårbæk 0851',NULL,1,100)).*;
 SELECT(api.kommune('0851 Lyngby',NULL,1,100)).*;
 SELECT(api.kommune('0760 0730 0840 0329 0265 0230 0175',NULL,1,100)).*;
 */
