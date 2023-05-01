SELECT '250_api_region.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.region CASCADE;

CREATE TYPE api.region AS (
    regionskode text,
    regionsnavn text,
    visningstekst text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.region IS 'Region';

COMMENT ON COLUMN api.region.regionskode IS 'Regionskode';

COMMENT ON COLUMN api.region.regionsnavn IS 'Navn på region';

COMMENT ON COLUMN api.region.visningstekst IS 'Præsentationsform for en region';

COMMENT ON COLUMN api.region.kommunekode IS 'Kommunekoder inden og opad region';

COMMENT ON COLUMN api.region.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.region.bbox IS 'Geometriens boundingbox i EPSG:25832';

DROP TABLE IF EXISTS basic.region;

WITH regioner AS (
    SELECT
        r.regionskode,
        r.navn,
        string_agg(k.kommunekode,',') AS kommunekode,
        st_force2d (r.geometri) AS geometri
    FROM
        dagi_500.regionsinddeling r
        JOIN dagi_500.kommuneinddeling k ON (st_intersects (k.geometri, r.geometri))
    GROUP BY
        r.regionskode,
        r.navn,
        r.geometri
)
SELECT
    r.navn AS visningstekst,
    r.regionskode,
    coalesce(r.navn, '') AS regionsnavn,
    r.kommunekode,
    st_multi (st_union (r.geometri)) AS geometri,
    st_extent (r.geometri) AS bbox INTO basic.region
FROM
    regioner r
GROUP BY
    r.regionskode,
    r.navn,
    r.kommunekode;

ALTER TABLE basic.region
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.region
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(regionsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(regionsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(regionsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring (regionsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.region
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.region
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', split_part(regionsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(regionsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(regionsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (regionsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.region
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.region
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(regionsnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(regionsnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(regionsnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (regionsnavn, 4)), 'D'))
    STORED;

CREATE INDEX ON basic.region USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.region USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.region USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.region (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.region (input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.region
    LANGUAGE plpgsql
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

    SELECT
        -- removes repeated whitespace and '-'
        regexp_replace(input_tekst, '[- \s]+', ' ', 'g')
    INTO input_tekst;

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
            regionskode::text,
            regionsnavn::text,
            visningstekst::text,
            kommunekode::text,
            geometri,
            bbox::geometry
        FROM
            basic.region
        WHERE (
            textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
            OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
            OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
        AND %s
        ORDER BY
            basic.combine_rank(
                $2,
                $2,
                textsearchable_plain_col,
                textsearchable_unaccent_col,
                ''simple''::regconfig,
                ''basic.septima_fts_config''::regconfig
            ) desc,
                ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision desc,
                regionsnavn
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
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
