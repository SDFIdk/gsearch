SELECT '330_api_husnummer.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.husnummer CASCADE;

CREATE TYPE api.husnummer AS (
    id text,
    kommunekode text,
    kommunenavn text,
    vejkode text,
    vejnavn text,
    husnummer text,
    postnummer text,
    postdistrikt text,
    adgangsadressebetegnelse text,
    adgangspunkt_geometri geometry,
    vejpunkt_geometri geometry,
    rang1 double precision,
    rang2 double precision
);

COMMENT ON TYPE api.husnummer IS 'Husnummer';

COMMENT ON COLUMN api.husnummer.id IS 'ID på husnummer';

COMMENT ON COLUMN api.husnummer.kommunekode IS 'Kommunekode for et husnummer';

COMMENT ON COLUMN api.husnummer.kommunenavn IS 'Kommunenavn for et husnummer';

COMMENT ON COLUMN api.husnummer.vejkode IS 'Vejkode for et husnummer';

COMMENT ON COLUMN api.husnummer.vejnavn IS 'Vejnavn for et husnummer';

COMMENT ON COLUMN api.husnummer.husnummer IS 'Husnummer';

COMMENT ON COLUMN api.husnummer.postnummer IS 'Postnummer for et husnummer';

COMMENT ON COLUMN api.husnummer.postdistrikt IS 'Postdistrikt for et husnummer';

COMMENT ON COLUMN api.husnummer.adgangsadressebetegnelse IS 'Adgangsadresse for et husnummer';

COMMENT ON COLUMN api.husnummer.vejpunkt_geometri IS 'Geometri for vejpunkt i valgt koordinatsystem';

COMMENT ON COLUMN api.husnummer.adgangspunkt_geometri IS 'Geometri for adgangspunkt i valgt koordinatsystem';

CREATE COLLATION IF NOT EXISTS husnummer_collation (provider = icu, locale = 'en@colNumeric=yes');

-- Husnummer script requires navngivenvej script to be executed first
DROP TABLE IF EXISTS basic.husnummer;

WITH husnumre AS (
    SELECT
        h.id AS id,
        h.adgangsadressebetegnelse,
        h.husnummertekst AS husnummer,
        h.navngivenvej_id,
        n.vejnavn,
        h.vejkode,
        h.kommunekode,
        k.navn AS kommunenavn,
        p.postnr AS postnummer,
        p.navn AS postdistrikt,
        st_force2d (COALESCE(ap.geometri)) AS adgangspunkt_geometri,
        st_force2d (COALESCE(ap2.geometri)) AS vejpunkt_geometri
    FROM
        dar.husnummer h
        JOIN dar.navngivenvej n ON n.id = h.navngivenvej_id::uuid
        JOIN dar.postnummer p ON p.id = h.postnummer_id::uuid
        JOIN dar.adressepunkt ap ON ap.id = h.adgangspunkt_id
        JOIN dar.adressepunkt ap2 ON ap2.id = h.vejpunkt_id
        JOIN dagi_500.kommuneinddeling k ON k.kommunekode = h.kommunekode
)
SELECT
    h.id,
    h.adgangsadressebetegnelse,
    h.husnummer,
    h.vejnavn,
    h.vejkode,
    h.kommunekode,
    h.kommunenavn,
    h.postnummer,
    h.postdistrikt,
    h.navngivenvej_id,
    nv.textsearchable_plain_col AS textsearchable_plain_col_vej,
    nv.textsearchable_unaccent_col AS textsearchable_unaccent_col_vej,
    nv.textsearchable_phonetic_col AS textsearchable_phonetic_col_vej,
    ROW_NUMBER() OVER (PARTITION BY h.navngivenvej_id ORDER BY NULLIF ((substring(h.husnummer::text FROM '[0-9]*')), '')::int,
        substring(h.husnummer::text FROM '[0-9]*([A-Z])') NULLS FIRST) AS sortering,
        st_multi (h.adgangspunkt_geometri) AS adgangspunkt_geometri,
    st_multi (h.vejpunkt_geometri) AS vejpunkt_geometri
INTO basic.husnummer
FROM
    husnumre h
    JOIN basic.navngivenvej nv ON h.navngivenvej_id = nv.id;

ALTER TABLE basic.husnummer
    ALTER COLUMN husnummer TYPE TEXT COLLATE husnummer_collation;

ALTER TABLE basic.husnummer
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.husnummer
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (textsearchable_plain_col_vej || setweight(to_tsvector('simple', husnummer), 'D'))
    STORED;

ALTER TABLE basic.husnummer
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.husnummer
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (textsearchable_unaccent_col_vej || setweight(to_tsvector('simple', husnummer), 'D'))
    STORED;

ALTER TABLE basic.husnummer
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.husnummer
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (textsearchable_phonetic_col_vej || setweight(to_tsvector('simple', husnummer), 'D'))
    STORED;


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

CREATE INDEX ON basic.husnummer USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.husnummer USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.husnummer USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.husnummer (lower(vejnavn), navngivenvej_id, sortering);

DROP FUNCTION IF EXISTS api.husnummer (text, text, int, int);

CREATE OR REPLACE FUNCTION api.husnummer (input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.husnummer
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    input_vejnavn text;
    input_husnummer text := '1=1';
    vej_query_string text;
    plain_vej_query_string text;
    husnummer_query_string text;
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

    -- Get vejnavn from input
    SELECT
        btrim((REGEXP_MATCH(btrim(input_tekst), '([^\d]+) ?(.*)'))[1])
    INTO input_vejnavn;

    -- Get husnummer from input
    SELECT
        btrim((REGEXP_MATCH(btrim(input_tekst), '([^\d]+) ?(.*)'))[2])
    INTO input_husnummer;

    -- Build the query_string (converting vejnavn of input to phonetic)
    WITH tokens AS (
        SELECT
            -- Fjerner husnummer fra input_tekst og splitter op i temp-tabel hver hvert vejnavn-ord i
            -- hver sin raekke.
            UNNEST(string_to_array(btrim(input_vejnavn), ' ')) t
    )
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':* <-> ') || ':*'
    FROM
        tokens
    INTO vej_query_string;


    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
        SELECT
            -- Splitter op i temp-tabel hver hvert vejnavn-ord i hver sin raekke.
            UNNEST(string_to_array(btrim(input_vejnavn), ' ')) t
    )
    SELECT
        string_agg(t, ':* <-> ') || ':*'
    FROM
        tokens
    INTO plain_vej_query_string;


    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_husnummer), ' ')) t
    )
    SELECT
        string_agg(t, ' <-> ') || ':*'
    FROM
        tokens
    INTO husnummer_query_string;


    IF husnummer_query_string IS NOT NULL THEN
        SELECT
            vej_query_string || ' <-> ' || husnummer_query_string
        INTO query_string;
    ELSE
        SELECT
            vej_query_string
        INTO query_string;
    END IF;


    IF husnummer_query_string IS NOT NULL THEN
        SELECT
            plain_vej_query_string || ' <-> ' || husnummer_query_string
        INTO plain_query_string;
    ELSE
        SELECT
            plain_vej_query_string
        INTO plain_query_string;
    END IF;

-- Hvis en input_tekst kun indeholder bogstaver og har over 1000 resultater, kan soegningen tage lang tid.
-- Dette er dog ofte soegninger, som ikke noedvendigvis giver mening. (fx. husnummer = 's'
-- eller adresse = 'od').
-- Saa for at goere api'et hurtigere ved disse soegninger, er der to forskellige queries
-- i denne funktion. Den ene bliver brugt, hvis der er over 1000 forekomster.
-- Vi har hardcoded antal forekomster i tabellen: `tekst_forekomst`.
-- Dette gaelder for:
-- - husnummer
-- - adresse
-- - navngivenvej
-- - stednavn

-- Et par linjer nede herfra, tilfoejes der et `|| ''å''`. Det er et hack,
-- for at representere den alfanumerisk sidste vej, der starter med `%s`

    IF (
        SELECT
            COALESCE(forekomster, 0)
        FROM
            basic.tekst_forekomst
        WHERE
            ressource = 'husnummer'
        AND lower(input_tekst) = tekstelement) > 1000
        AND filters = '1=1'
    THEN
        stmt = format(E'SELECT
                id::text,
                kommunekode::text,
                kommunenavn::text,
                vejkode::text,
                vejnavn::text,
                husnummer::text,
                postnummer::text,
                postdistrikt::text,
                adgangsadressebetegnelse::text,
                vejpunkt_geometri,
                adgangspunkt_geometri,
                0::float AS rank1,
                0::float AS rank2
            FROM
                basic.husnummer
            WHERE
                lower(vejnavn) >= ''%s''
            AND
                lower(vejnavn) <= ''%s'' || ''å''
            ORDER BY
                lower(vejnavn),
                navngivenvej_id,
                sortering
            LIMIT $3;', input_tekst, input_tekst);

        --RAISE NOTICE 'stmt=%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;

    ELSE
        stmt = format(E'SELECT
                id::text,
                kommunekode::text,
                kommunenavn::text,
                vejkode::text,
                vejnavn::text,
                husnummer::text,
                postnummer::text,
                postdistrikt::text,
                adgangsadressebetegnelse::text,
                vejpunkt_geometri,
                adgangspunkt_geometri,
                basic.combine_rank(
                    $2,
                    $2,
                    textsearchable_plain_col,
                    textsearchable_unaccent_col,
                    ''simple''::regconfig,
                    ''basic.septima_fts_config''::regconfig
                ) AS rank1,
                ts_rank_cd(
                    textsearchable_phonetic_col,
                    to_tsquery(''simple'',$1)
                )::double precision AS rank2
            FROM
                basic.husnummer
            WHERE
                (textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                 OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND
                %s
            ORDER BY
                husnummer,
                rank1 desc,
                rank2 desc,
                adgangsadressebetegnelse
            LIMIT $3;', filters);
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    END IF;
END
$function$;

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
