SELECT '260_api_retskreds.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.retskreds CASCADE;

CREATE TYPE api.retskreds AS (
    retskredsnummer text,
    retkredsnavn text,
    visningstekst text,
    myndighedskode text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.retskreds IS 'Retskreds';

COMMENT ON COLUMN api.retskreds.retskredsnummer IS 'Retskredsnummer';

COMMENT ON COLUMN api.retskreds.retkredsnavn IS 'Navn på retskreds';

COMMENT ON COLUMN api.retskreds.visningstekst IS 'Præsentationsform for en retskreds';

COMMENT ON COLUMN api.retskreds.myndighedskode IS 'Retskredsens myndighedskode. Er unik for hver retskreds. 4 cifre.';

COMMENT ON COLUMN api.retskreds.kommunekode IS 'Kommunekode(r) for retskredsen';

COMMENT ON COLUMN api.retskreds.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.retskreds.bbox IS 'Geometriens boundingbox i EPSG:25832';

DROP TABLE IF EXISTS basic.retskreds;

WITH retskredse AS (
    SELECT
        r.retskredsnummer,
        r.navn,
        r.myndighedskode,
        string_agg(k.kommunekode, ',') AS kommunekode,
        st_force2d (r.geometri) AS geometri
    FROM
        dagi_500.retskreds r
        JOIN dagi_500.kommuneinddeling k ON (st_intersects (k.geometri, r.geometri))
    GROUP BY
        r.retskredsnummer,
        r.navn,
        r.myndighedskode,
        r.geometri
    )
SELECT
    r.navn AS visningstekst,
    r.retskredsnummer,
    coalesce(r.navn, '') AS retkredsnavn,
    r.myndighedskode,
    r.kommunekode,
    st_multi (st_union (r.geometri)) AS geometri,
    st_extent (r.geometri) AS bbox INTO basic.retskreds
FROM
    retskredse r
GROUP BY
    r.retskredsnummer,
    r.navn,
    r.myndighedskode,
    r.kommunekode;

ALTER TABLE basic.retskreds
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.retskreds
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(retkredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring (retkredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.retskreds
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.retskreds
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(retkredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (retkredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.retskreds
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.retskreds
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(retkredsnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(retkredsnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(retkredsnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (retkredsnavn, 4)), 'D'))
    STORED;

CREATE INDEX ON basic.retskreds USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.retskreds USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.retskreds USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.retskreds (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.retskreds (input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.retskreds
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
                retskredsnummer::text,
                retkredsnavn::text,
                visningstekst::text,
                myndighedskode::text,
                kommunekode::text,
                geometri,
                bbox::geometry
            FROM
                basic.retskreds
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
                retkredsnavn
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
END
$function$;

-- Test cases:
/*
 SELECT (api.retskreds('hjør',NULL, 1, 100)).*;
 SELECT (api.retskreds('køben',NULL, 1, 100)).*;
 SELECT (api.retskreds('ret',NULL, 1, 100)).*;
 SELECT (api.retskreds('i he',NULL, 1, 100)).*;
 */
