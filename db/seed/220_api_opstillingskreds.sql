SELECT '220_api_opstillingskreds.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.opstillingskreds CASCADE;

CREATE TYPE api.opstillingskreds AS (
    opstillingskredsnummer text,
    opstillingskredsnavn text,
    visningstekst text,
    valgkredsnummer text,
    storkredsnummer text,
    storkredsnavn text,
    kommunekode text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.opstillingskreds IS 'Opstillingskreds';

COMMENT ON COLUMN api.opstillingskreds.opstillingskredsnummer IS 'Opstillingskredsnummer';

COMMENT ON COLUMN api.opstillingskreds.opstillingskredsnavn IS 'Navn på opstillingskreds';

COMMENT ON COLUMN api.opstillingskreds.visningstekst IS 'Præsentationsform for en opstillingskreds';

COMMENT ON COLUMN api.opstillingskreds.valgkredsnummer IS 'Unik nummer indenfor storkredsen';

COMMENT ON COLUMN api.opstillingskreds.storkredsnummer IS 'Unik nummer for storkreds, som opstillingskredsen tilhører';

COMMENT ON COLUMN api.opstillingskreds.storkredsnavn IS 'Storkredsens unikke navn';

COMMENT ON COLUMN api.opstillingskreds.kommunekode IS 'Kommunekode(r) for kommune(r) der ligger i eller optil opstillingskredsen';

COMMENT ON COLUMN api.opstillingskreds.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.opstillingskreds.bbox IS 'Geometriens boundingbox i EPSG:25832';

DROP TABLE IF EXISTS basic.opstillingskreds;

WITH kommunenumre AS (
    SELECT
        o.opstillingskredsnummer,
        string_agg(k.kommunekode, ',') AS kommunekode
    FROM
        dagi_10.opstillingskreds o
        LEFT JOIN dagi_10.kommuneinddeling k ON st_intersects(k.geometri, o.geometri)
    GROUP BY
        o.opstillingskredsnummer
),
    opstillingskredse AS (
    SELECT
        o.opstillingskredsnummer,
        o.navn,
        o.valgkredsnummer,
        s.storkredsnummer,
        s.navn AS storkredsnavn,
        st_force2d (o.geometri) AS geometri
    FROM
        dagi_500.opstillingskreds o
        JOIN dagi_500.storkreds s ON o.storkredslokalid = s.id_lokalid
    GROUP BY
        o.opstillingskredsnummer,
        o.navn,
        o.valgkredsnummer,
        storkredsnummer,
        storkredsnavn,
        o.geometri
)
SELECT
    o.navn || 'kredsen' AS visningstekst,
    o.opstillingskredsnummer,
    coalesce(o.navn, '') AS opstillingskredsnavn,
    o.valgkredsnummer,
    o.storkredsnummer,
    o.storkredsnavn,
    k.kommunekode,
    st_multi (st_union (o.geometri)) AS geometri,
    st_extent (o.geometri) AS bbox
INTO basic.opstillingskreds
FROM
    opstillingskredse o
LEFT JOIN kommunenumre k ON o.opstillingskredsnummer = k.opstillingskredsnummer
GROUP BY
    o.opstillingskredsnummer,
    o.navn,
    o.valgkredsnummer,
    storkredsnummer,
    storkredsnavn,
    k.kommunekode;

ALTER TABLE basic.opstillingskreds
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.opstillingskreds
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(opstillingskredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(opstillingskredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(opstillingskredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring (opstillingskredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.opstillingskreds
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.opstillingskreds
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', split_part(opstillingskredsnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(opstillingskredsnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(opstillingskredsnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (opstillingskredsnavn, 4)), 'D'))
    STORED;

ALTER TABLE basic.opstillingskreds
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.opstillingskreds
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(opstillingskredsnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(opstillingskredsnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(opstillingskredsnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (coalesce(opstillingskredsnavn), 4)), 'D'))
    STORED;

CREATE INDEX ON basic.opstillingskreds USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.opstillingskreds USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.opstillingskreds USING GIN (textsearchable_phonetic_col);

DROP FUNCTION IF EXISTS api.opstillingskreds (text, jsonb, int, int);

CREATE OR REPLACE FUNCTION api.opstillingskreds (input_tekst text, filters text, sortoptions integer, rowlimit integer)
    RETURNS SETOF api.opstillingskreds
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
                opstillingskredsnummer::text,
                opstillingskredsnavn::text,
                visningstekst,
                valgkredsnummer::text,
                storkredsnummer::text,
                storkredsnavn::text,
                kommunekode::text,
                geometri,
                bbox::geometry
            FROM
                basic.opstillingskreds
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
                    ''basic.septima_fts_config''::regconfig) desc,
                    ts_rank_cd(textsearchable_phonetic_col,
                    to_tsquery(''simple'',$1)
                )::double precision desc,
                opstillingskredsnavn
            LIMIT $3;', filters);
    RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
END
$function$;

-- Test cases:
/*
 SELECT (api.opstillingskreds('rønn',NULL, 1, 100)).*;
 SELECT (api.opstillingskreds('hels',NULL, 1, 100)).*;
 SELECT (api.opstillingskreds('åkir',NULL, 1, 100)).*;
 SELECT (api.opstillingskreds('nord',NULL, 1, 100)).*;
 SELECT (api.opstillingskreds('vest',NULL, 1, 100)).*;
 */
