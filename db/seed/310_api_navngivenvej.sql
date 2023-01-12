SELECT '310_api_navngivenvej.sql ' || now();


CREATE SCHEMA IF NOT EXISTS api;

DROP TYPE IF EXISTS api.navngivenvej CASCADE;

CREATE TYPE api.navngivenvej AS (
    id text,
    vejnavn text,
    visningstekst text,
    postnummer text,
    postnummernavne text,
    geometri geometry,
    bbox geometry,
    rang1 double precision,
    rang2 double precision
);

COMMENT ON TYPE api.navngivenvej IS 'Navngivenvej';

COMMENT ON COLUMN api.navngivenvej.id IS 'ID på navngiven vej';

COMMENT ON COLUMN api.navngivenvej.vejnavn IS 'Navn på vej';

COMMENT ON COLUMN api.navngivenvej.visningstekst IS 'Præsentationsform for et navngiven vej';

COMMENT ON COLUMN api.navngivenvej.postnummer IS 'Postnummer for navngiven vej';

COMMENT ON COLUMN api.navngivenvej.postnummernavne IS 'Alle postnummernavne den navngiven vej befinder sig i';

COMMENT ON COLUMN api.navngivenvej.geometri IS 'Geometri for den navngivne vej. Kan enten være en linje eller en polygon';

COMMENT ON COLUMN api.navngivenvej.bbox IS 'Geometriens boundingbox';

DROP TABLE IF EXISTS basic.navngivenvej;

WITH vejnavne AS (
    SELECT
        n.id AS id,
        n.vejnavn,
        p.postnr AS postnummer,
        p.navn AS postnummernavne,
        n.geometri AS geometri
    FROM
        dar.navngivenvej n
        JOIN dar.navngivenvejpostnummer nvp ON (nvp.navngivenvej_id = n.id)
        JOIN dar.postnummer p ON (nvp.postnummer_id = p.id))
    --SELECT v.vejnavn || '(' || v.postnummer[1] || ' - ' || v.postnummer[-1] || ')' AS visningstekst,
    SELECT
        v.vejnavn AS visningstekst,
        v.id,
        coalesce(v.vejnavn, '') AS vejnavn,
    array_agg(DISTINCT v.postnummer) AS postnumre,
    array_agg(DISTINCT v.postnummernavne) AS postnummernavne,
    st_multi (st_union (geometri)) AS geometri,
    st_envelope (st_collect (v.geometri)) AS bbox
INTO basic.navngivenvej
FROM
    vejnavne v
GROUP BY
    v.id,
    v.vejnavn;

-- textsearchable column using predefined custom config consisting of a collection of FTS dictionaries - see 012_init_configuration.sql
-- use either this or one below.
-- ALTER TABLE api.navngivenvej DROP COLUMN IF EXISTS textsearchable_index_col;
-- ALTER TABLE api.navngivenvej
-- ADD COLUMN textsearchable_index_col tsvector
-- GENERATED ALWAYS AS
--   (
--    setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 1)), 'A') ||
--     setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 2)), 'B') ||
--     setweight(to_tsvector('api.septima_fts_config', split_part(coalesce(vejnavn, ''), ' ', 3)), 'C') ||
--     setweight(to_tsvector('api.septima_fts_config', api.split_and_endsubstring_fonetik(vejnavn, 4)), 'D')
--   ) STORED
-- ;
-- plain textsearchable column
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_plain_col_vej;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_plain_col_vej tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(vejnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(vejnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', split_part(vejnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring (vejnavn, 4)), 'D'))
    STORED;

-- unaccented textsearchable column: å -> aa, é -> e, ect.
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_unaccent_col_vej;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_unaccent_col_vej tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', split_part(vejnavn, ' ', 1)), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(vejnavn, ' ', 2)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(vejnavn, ' ', 3)), 'C') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (vejnavn, 4)), 'D'))

    STORED;

-- phonetic textsearchable column: christian -> kristian, k
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_phonetic_col_vej;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_phonetic_col_vej tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(vejnavn, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(vejnavn, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(vejnavn, ' ', 3), 2)), 'C') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (vejnavn, 4)), 'D'))

    STORED;

ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (textsearchable_plain_col_vej ||
                         setweight(to_tsvector('simple', basic.array_to_string_immutable(postnumre)), 'D') ||
                         setweight(to_tsvector('simple', basic.array_to_string_immutable(postnummernavn)), 'D'))
    STORED;

-- unaccented textsearchable column: å -> aa, é -> e, ect.
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (textsearchable_unaccent_col_vej  ||
                         setweight(to_tsvector('simple', basic.array_to_string_immutable(postnumre)), 'D') ||
                         setweight(to_tsvector('simple', basic.array_to_string_immutable(postnummernavn)), 'D'))

    STORED;

-- phonetic textsearchable column: christian -> kristian, k
ALTER TABLE basic.navngivenvej
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.navngivenvej
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (textsearchable_phonetic_col_vej ||
                         setweight(to_tsvector('simple', basic.array_to_string_immutable(postnumre)), 'D') ||
                         setweight(to_tsvector('simple', basic.array_to_string_immutable(postnummernavn)), 'D'))

    STORED;

CREATE INDEX ON basic.navngivenvej USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.navngivenvej USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.navngivenvej USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.navngivenvej (lower(vejnavn));

DROP FUNCTION IF EXISTS api.navngivenvej (text, text, int, int);

CREATE OR REPLACE FUNCTION api.navngivenvej (input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.navngivenvej
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
    -- Build the query_string
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
)
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':* & ') || ':*'
    FROM
        tokens INTO query_string;
    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
)
    SELECT
        string_agg(t, ':* & ') || ':*'
    FROM
        tokens INTO plain_query_string;

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
            ressource = 'adresse' AND lower(input_tekst) = tekstelement) > 1000 AND filters = '1=1' THEN
        stmt = format(E'SELECT
            id::text, vejnavn::text, visningstekst::text, array_to_string(postnumre, '','', ''*''), array_to_string(postnummernavne, '',''), geometri, bbox,
            0::float AS rang1,
            0::float AS rang2
            FROM
            basic.navngivenvej
            WHERE
            lower(vejnavn) >= lower(''%s'') AND lower(vejnavn) <= lower(''%s'') || ''å''
            ORDER BY
            lower(vejnavn)
            LIMIT $3;', input_tekst, input_tekst);
        --RAISE NOTICE '%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    ELSE
        stmt = format(E'SELECT
            id::text, vejnavn::text, visningstekst::text, array_to_string(postnumre, '','', ''*''), array_to_string(postnummernavne, '',''), geometri, bbox,
            basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) AS rang1,
            ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision AS rang2
            FROM
            basic.navngivenvej
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
            rang1 desc, rang2 desc,
            vejnavn
            LIMIT $3;', filters);
        --RAISE NOTICE '%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    END IF;
END
$function$;

-- Test cases:
/*
 SELECT (api.navngivenvej('park allé',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('ålbor',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('søborg h',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('holbæk',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('vinkel',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('nord',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('-',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('allesø-no',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('over-holluf væ',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('Palle Juul-jensen',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('frederik 7',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('vilhelm becks',NULL, 1, 100)).*;
 SELECT (api.navngivenvej('sadd',NULL, 1, 100)).*;
 */
