SELECT '510_api_stednavne.sql ' || now();


DROP TYPE IF EXISTS api.stednavn CASCADE;

CREATE TYPE api.stednavn AS (
    id text,
    skrivemaade text,
    visningstekst text,
    skrivemaade_officiel text,
    skrivemaade_uofficiel text,
    stednavn_type text,
    stednavn_subtype text,
    geometri geometry,
    bbox geometry
);

COMMENT ON TYPE api.stednavn IS 'Stednavn';

COMMENT ON COLUMN api.stednavn.id IS 'UUID for stednavn';

COMMENT ON COLUMN api.stednavn.skrivemaade IS 'Skrivemåde for stednavn';

COMMENT ON COLUMN api.stednavn.visningstekst IS 'Præsentationsform for stednavn';

COMMENT ON COLUMN api.stednavn.skrivemaade_officiel IS 'Officiel skrivemåde for stednavn';

COMMENT ON COLUMN api.stednavn.skrivemaade_uofficiel IS 'Uofficiel skrivemåde for stednavn';

COMMENT ON COLUMN api.stednavn.stednavn_type IS 'Featuretype på stednavn';

COMMENT ON COLUMN api.stednavn.stednavn_subtype IS 'Topografitype på stednavn';

COMMENT ON COLUMN api.stednavn.geometri IS 'Geometri i EPSG:25832';

COMMENT ON COLUMN api.stednavn.bbox IS 'Geometriens boundingbox i EPSG:25832';

DROP TABLE IF EXISTS basic.stednavn;

WITH stednavne AS (
    SELECT
        objectid,
        id_lokalid,
        coalesce(visningstekst, '') AS visningstekst,
        navnestatus,
        skrivemaade,
        type,
        subtype,
        municipality_filter,
        st_force2d (geometri_udtyndet) AS geometri
    FROM
        stednavne_udstilling.stednavne_udstilling
),
agg_stednavne_officiel AS (
    SELECT
        objectid,
        skrivemaade
    FROM
        stednavne_udstilling.stednavne_udstilling o
    WHERE
        navnestatus <> 'uofficielt'
),
agg_stednavne_uofficiel AS (
    SELECT
        objectid,
        skrivemaade
    FROM
        stednavne_udstilling.stednavne_udstilling u
    WHERE
        navnestatus = 'uofficielt'
),
agg_stednavne AS (
    SELECT
        su.objectid,
        id_lokalid,
        navnefoelgenummer,
        visningstekst as visningstekst,
        navnestatus,
        o.skrivemaade AS skrivemaade,
        u.skrivemaade AS uofficielle_skrivemaader,
        "type",
        subtype,
        geometri_udtyndet as geometri,
        municipality_filter
    FROM
        stednavne_udstilling.stednavne_udstilling su
    LEFT JOIN agg_stednavne_officiel o ON
        o.objectid = su.objectid
    LEFT JOIN agg_stednavne_uofficiel u ON
        u.objectid = su.objectid
    GROUP BY
        su.objectid,
        id_lokalid,
        navnefoelgenummer,
        visningstekst,
        o.skrivemaade,
        u.skrivemaade,
        "type",
        subtype,
        geometri_udtyndet,
        municipality_filter
)
SELECT
    id_lokalid AS id,
    visningstekst,
    replace(replace(visningstekst, ' - ', ' '), '-', ' ') AS visningstekst_nohyphen,
    skrivemaade,
    (
        CASE WHEN uofficielle_skrivemaader IS NULL THEN
            ''
        ELSE
            uofficielle_skrivemaader
        END) AS skrivemaade_uofficiel,
    (
        CASE WHEN uofficielle_skrivemaader IS NULL THEN
            ''
        ELSE
            replace(uofficielle_skrivemaader, '-', ' ')
        END) AS skrivemaade_uofficiel_nohyphen,
    type AS stednavn_type,
    subtype AS stednavn_subtype,
    st_multi (st_union (geometri)) AS geometri,
    st_envelope (st_collect (geometri)) AS bbox INTO basic.stednavn
FROM
    agg_stednavne
GROUP BY
    id,
    visningstekst,
    visningstekst_nohyphen,
    skrivemaade,
    skrivemaade_uofficiel,
    skrivemaade_uofficiel_nohyphen,
    type,
    subtype;


-- Inserts into tekst_forekomst
    WITH a AS (SELECT generate_series(1,8) a)
INSERT INTO basic.tekst_forekomst (ressource, tekstelement, forekomster)
    SELECT
    'stednavn',
    substring(lower(skrivemaade) FROM 1 FOR a),
    count(*)
    FROM
    basic.stednavn am
    CROSS JOIN a
    GROUP BY
    substring(lower(skrivemaade) FROM 1 FOR a)
    HAVING
    count(1) > 1000
    ON CONFLICT DO NOTHING;

ALTER TABLE basic.stednavn
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic.stednavn
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', split_part(visningstekst, ' ', 1)), 'A') ||
                         setweight(to_tsvector('simple', split_part(visningstekst, ' ', 2)), 'B') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring ((visningstekst), 3)), 'C') ||
                         basic.stednavne_uofficielle_tsvector (skrivemaade_uofficiel))
    STORED;

ALTER TABLE basic.stednavn
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.stednavn
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('basic.septima_fts_config', split_part(visningstekst, ' ', 1)), 'A') ||
                         setweight(to_tsvector('basic.septima_fts_config', split_part(visningstekst, ' ', 2)), 'B') ||
                         setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (visningstekst, 3)), 'C') ||
                         basic.stednavne_uofficielle_tsvector (skrivemaade_uofficiel))
    STORED;

ALTER TABLE basic.stednavn
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.stednavn
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(visningstekst_nohyphen, ' ', 1), 2)), 'A') ||
                         setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(visningstekst_nohyphen, ' ', 2), 2)), 'B') ||
                         setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (visningstekst_nohyphen, 3)), 'C') ||
                         basic.stednavne_uofficielle_tsvector_phonetic (skrivemaade_uofficiel_nohyphen))
    STORED;

CREATE INDEX ON basic.stednavn USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.stednavn USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.stednavn USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.stednavn (lower(visningstekst));

DROP FUNCTION IF EXISTS api.stednavn (text, text, int, int);

CREATE OR REPLACE FUNCTION api.stednavn (input_tekst text, filters text, sortoptions int, rowlimit int)
    RETURNS SETOF api.stednavn
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

    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(replace(input_tekst, '-', ' ')), ' ')) t
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
            ressource = 'stednavn' AND lower(input_tekst) = tekstelement) > 1000 AND filters = '1=1' THEN
        stmt = format(E'SELECT
                id::text, skrivemaade::text, visningstekst::text, skrivemaade::text AS skrivemaade_officiel,
                skrivemaade_uofficiel::text, stednavn_type::text, stednavn_subtype::text, geometri, bbox
            FROM
                basic.stednavn
            WHERE
                lower(visningstekst) >= lower(''%s'') AND lower(visningstekst) <= lower(''%s'') || ''å''
            ORDER BY
                lower(visningstekst)
            LIMIT $3;', input_tekst, input_tekst);
        --RAISE NOTICE '%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    ELSE
        -- Execute and return the result
        stmt = format(E'SELECT
                id::text, skrivemaade::text, visningstekst::text, skrivemaade::text AS skrivemaade_officiel,
                skrivemaade_uofficiel::text, stednavn_type::text, stednavn_subtype::text, geometri, bbox
            FROM
                basic.stednavn
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
            AND %s
            ORDER BY
                basic.combine_rank($2, $2, textsearchable_plain_col, textsearchable_unaccent_col, ''simple''::regconfig, ''basic.septima_fts_config''::regconfig) desc,
                ts_rank_cd(textsearchable_phonetic_col, to_tsquery(''simple'',$1))::double precision desc,
                visningstekst
            LIMIT $3;', filters);
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    END IF;
END
$function$;

-- Test cases:
/*
 SELECT (api.stednavn('tivoli',NULL, 1, 100)).*;
 SELECT (api.stednavn('tivoli forlys',NULL, 1, 100)).*;
 SELECT (api.stednavn('vuc ringkøb',NULL, 1, 100)).*;
 SELECT (api.stednavn('grøngård slot',NULL, 1, 100)).*;
 SELECT (api.stednavn('slotsruin',NULL, 1, 100)).*;
 SELECT (api.stednavn('uch',NULL, 1, 100)).*;
 SELECT (api.stednavn('hc andersen slot',NULL, 1, 100)).*;
 SELECT (api.stednavn('s',NULL, 1, 100)).*;
 */
