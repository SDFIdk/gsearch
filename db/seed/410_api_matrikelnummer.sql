SELECT '410_api_matrikelnummer.sql ' || now();


DROP TYPE IF EXISTS api.matrikelnummer CASCADE;

CREATE TYPE api.matrikelnummer AS (
    ejerlavsnavn text,
    ejerlavskode text,
    matrikelnummer text,
    visningstekst text,
    centroid_x text,
    centroid_y text,
    geometri geometry
);

COMMENT ON TYPE api.matrikelnummer IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikelnummer.ejerlavsnavn IS 'Ejerlavsnavn for matrikel';

COMMENT ON COLUMN api.matrikelnummer.ejerlavskode IS 'Ejerlavskode for matrikel';

COMMENT ON COLUMN api.matrikelnummer.matrikelnummer IS 'Matrikelnummer';

COMMENT ON COLUMN api.matrikelnummer.visningstekst IS 'Præsentationsform for et matrikelnummer';

COMMENT ON COLUMN api.matrikelnummer.centroid_x IS 'Centroide X for matriklens geometri';

COMMENT ON COLUMN api.matrikelnummer.centroid_y IS 'Centroide Y for matriklens geometri';

COMMENT ON COLUMN api.matrikelnummer.geometri IS 'Geometri i valgt koordinatsystem';

DROP TABLE IF EXISTS basic.matrikelnummer;

WITH matrikelnumre AS (
    SELECT
        coalesce(e.ejerlavsnavn, '') AS ejerlavsnavn,
        coalesce(e.ejerlavskode::text, '') AS ejerlavskode,
        coalesce(k.kommunenavn, '') AS kommunenavn,
        coalesce(j.matrikelnummer, '') AS matrikelnummer,
        c.geometri AS centroide_geometri,
        st_force2d (COALESCE(l.geometri)) AS geometri
    FROM
        -- mat.jordstykke j
        --JOIN mat.ejerlav e ON j.ejerlavlokalid = e.id_lokalid
        matriklen.jordstykke j
        JOIN matriklen.ejerlav e ON e.id_lokalid = j.ejerlavlokalid
        JOIN matriklen.centroide c ON c.jordstykkelokalid = j.id_lokalid
        JOIN matriklen.matrikelkommune k ON k.id_lokalid = j.kommunelokalid
        JOIN matriklen.lodflade l ON l.jordstykkelokalid = j.id_lokalid
),
ejerlavsnavn_dups AS (
    SELECT
        count(1) ejerlavsnavn_count,
        ejerlavsnavn,
        (setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 1)), 'B') || setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 2)), 'C') || setweight(to_tsvector('simple', basic.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_plain_col_ejerlavsnavn,
        (setweight(to_tsvector('basic.septima_fts_config', split_part(ejerlavsnavn, ' ', 1)), 'B') || setweight(to_tsvector('basic.septima_fts_config', split_part(ejerlavsnavn, ' ', 2)), 'C') || setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_unaccent_col_ejerlavsnavn,
        (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(ejerlavsnavn, ' ', 1), 2)), 'B') || setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(ejerlavsnavn, ' ', 2), 2)), 'C') || setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (ejerlavsnavn, 3)), 'D')) AS textsearchable_phonetic_col_ejerlavsnavn
    FROM ( SELECT DISTINCT
            ejerlavsnavn,
            ejerlavskode,
            kommunenavn
        FROM
            matrikelnumre) x
    GROUP BY
        ejerlavsnavn
)
SELECT
    m.ejerlavsnavn || CASE WHEN ejerlavsnavn_count > 1 THEN
        ' (' || m.kommunenavn || ')' || ' - ' || m.matrikelnummer
    ELSE
        '' || ' - ' || m.matrikelnummer
    END AS visningstekst,
    m.ejerlavsnavn,
    m.ejerlavskode,
    m.matrikelnummer,
    m.centroide_geometri,
    e.textsearchable_plain_col_ejerlavsnavn,
    e.textsearchable_unaccent_col_ejerlavsnavn,
    e.textsearchable_phonetic_col_ejerlavsnavn,
    st_multi (m.geometri) AS geometri INTO basic.matrikelnummer
FROM
    matrikelnumre m
    JOIN ejerlavsnavn_dups e ON e.ejerlavsnavn = m.ejerlavsnavn;

ALTER TABLE basic.matrikelnummer
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.matrikelnummer
    ADD COLUMN textsearchable_plain_col tsvector
        GENERATED ALWAYS AS (textsearchable_plain_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;

ALTER TABLE basic.matrikelnummer
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.matrikelnummer
    ADD COLUMN textsearchable_unaccent_col tsvector
        GENERATED ALWAYS AS (textsearchable_unaccent_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;

ALTER TABLE basic.matrikelnummer
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.matrikelnummer
    ADD COLUMN textsearchable_phonetic_col tsvector
        GENERATED ALWAYS AS (textsearchable_phonetic_col_ejerlavsnavn ||
                             setweight(to_tsvector('simple', ejerlavskode), 'A') ||
                             setweight(to_tsvector('simple', matrikelnummer), 'A'))
        STORED;


CREATE INDEX ON basic.matrikelnummer USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.matrikelnummer USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.matrikelnummer USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.matrikelnummer (matrikelnummer, visningstekst);

DROP FUNCTION IF EXISTS api.matrikelnummer (text, text, int, int);

CREATE OR REPLACE FUNCTION api.matrikelnummer (input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.matrikelnummer
    LANGUAGE plpgsql
    STABLE
    AS $function$
DECLARE
    max_rows integer;
    input_ejerlavsnavn text;
    input_ejerlavskode_matrikelnummer text;
    ejerlavsnavn_string text;
    ejerlavsnavn_string_plain text;
    ejerlavskode_matrikelnummer_string text;
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
        -- matches non-digits
        btrim((REGEXP_MATCH(btrim(input_tekst), '([^\d]+)'))[1])
    INTO input_ejerlavsnavn;

    SELECT
        -- Removes everything that starts with a letter or symbol (not digits) and then removes repeated whitespace.
        btrim(regexp_replace(regexp_replace(input_tekst, '((?<!\S)\D\S*)', '', 'g'), '\s+', ' '))
    INTO input_ejerlavskode_matrikelnummer;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_ejerlavsnavn, ' ')) t
    )
    SELECT
        string_agg(t, ':* <-> ') || ':*'
    FROM
        tokens
    INTO ejerlavsnavn_string_plain;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_ejerlavsnavn, ' ')) t
    )
    SELECT
        string_agg(fonetik.fnfonetik (t, 2), ':* <-> ') || ':*'
    FROM
        tokens INTO ejerlavsnavn_string;

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(input_ejerlavskode_matrikelnummer, ' ')) t
    )
    SELECT
        string_agg(t, ' & ')
    FROM
        tokens INTO ejerlavskode_matrikelnummer_string;
    CASE WHEN ejerlavsnavn_string IS NULL THEN
        SELECT
            ejerlavskode_matrikelnummer_string INTO query_string;
    WHEN ejerlavskode_matrikelnummer_string IS NULL THEN
        SELECT
            ejerlavsnavn_string INTO query_string;
        ELSE
            SELECT
                ejerlavsnavn_string || ' | ' || ejerlavskode_matrikelnummer_string INTO query_string;
    END CASE;
    CASE WHEN ejerlavsnavn_string_plain IS NULL THEN
        SELECT
            ejerlavskode_matrikelnummer_string INTO plain_query_string;
    WHEN ejerlavskode_matrikelnummer_string IS NULL THEN
        SELECT
            ejerlavsnavn_string_plain INTO plain_query_string;
        ELSE
            SELECT
                ejerlavsnavn_string_plain || ' | ' || ejerlavskode_matrikelnummer_string INTO plain_query_string;
    END CASE;


-- Hvis en soegning ender med at have over ca. 1000 resultater, kan soegningen tage lang tid.
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
            ressource = 'matrikelnummer'
        AND lower(input_ejerlavsnavn) = tekstelement ) > 1000
        AND filters = '1=1'
    THEN
        stmt = format(E'SELECT
                ejerlavsnavn::text,
                ejerlavskode::text,
                matrikelnummer::text,
                visningstekst::text,
                ST_X((ST_DUMP(centroide_geometri)).geom)::text,
                ST_Y((ST_DUMP(centroide_geometri)).geom)::text,
                geometri,
                0::float AS rank1,
                0::float AS rank2
            FROM
                basic.matrikelnummer
            WHERE
                lower(ejerlavsnavn) >= ''%s''
                AND lower(ejerlavsnavn) <= ''%s'' || ''å''
            ORDER BY
                matrikelnummer,
                visningstekst
            LIMIT $3;', input_tekst, input_tekst);
        --RAISE NOTICE 'stmt=%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    ELSE
    -- Execute and return the result
    stmt = format(E'SELECT
            ejerlavsnavn::text,
            ejerlavskode::text,
            matrikelnummer::text,
            visningstekst::text,
            ST_X((ST_DUMP(centroide_geometri)).geom)::text,
            ST_Y((ST_DUMP(centroide_geometri)).geom)::text,
            geometri,
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
            basic.matrikelnummer
        WHERE (
            textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
            OR textsearchable_plain_col @@ to_tsquery(''simple'', $2)
        )
        AND %s
        ORDER BY
            rank1 desc,
            rank2 desc,
            matrikelnummer,
            visningstekst
        LIMIT $3  ;', filters); RETURN QUERY EXECUTE stmt
    USING query_string, plain_query_string, rowlimit;
    END IF;
    END
$function$;
-- Test cases:
/*
 SELECT (api.matrikelnummer('søby',NULL, 1, 100)).*;
 SELECT (api.matrikelnummer('11aa',NULL, 1, 100)).*;
 SELECT (api.matrikelnummer('1320452',NULL, 1, 100)).*;
 SELECT (api.matrikelnummer('11aa 1320452',NULL, 1, 100)).*;
 SELECT (api.matrikelnummer('1320452 11aa kobbe',NULL, 1, 100)).*;
 SELECT (api.matrikelnummer('11aa søby',NULL, 1, 100)).*;
 SELECT (api.matrikelnummer('s',NULL, 1, 100)).*;
 SELECT (api.matrikelnummer('a 1 a', NULL, 1, 100)).*;

 */
