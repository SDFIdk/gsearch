DROP FUNCTION IF EXISTS api.matrikel_udgaaet(text, text, int, int, int);

CREATE OR REPLACE FUNCTION api.matrikel_udgaaet(input_tekst text, filters text, sortoptions integer, rowlimit integer, srid integer)
    RETURNS SETOF api.matrikel_udgaaet
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
        -- Removes repeated whitespace and following symbols -()!
        regexp_replace(btrim(input_tekst), '[-()! \s]+', ' ', 'g')
    INTO input_tekst;

    -- Build the query_string (converting vejnavn of input to phonetic)
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
    )
    SELECT
            string_agg(functions.fnfonetik (t, 2), ':* & ') || ':*'
    FROM
        tokens
    INTO query_string;

    -- build the plain version of the query string for ranking purposes
    WITH tokens AS (
        SELECT
            -- Splitter op i temp-tabel hver hvert input ord i hver sin raekke.
            -- removes all combination of spaces and ampersand and replaces it with a whitespace
            UNNEST(string_to_array(regexp_replace(btrim(input_tekst),'[ ][&][ ]|[&][ ]|[ ][&]','','g'), ' ')) t
    )
    SELECT
            string_agg(t, ':* & ') || ':*'
    FROM
        tokens
    INTO plain_query_string;

-- Hvis en soegning ender med at have over ca. 1000 resultater, kan soegningen tage lang tid.
-- Dette er dog ofte soegninger, som ikke noedvendigvis giver mening. (fx. husnummer = 's'
-- eller adresse = 'od').
-- Saa for at goere api'et hurtigere ved disse soegninger, er der to forskellige queries
-- i denne funktion. Den ene bliver brugt, hvis der er over 1000 forekomster.
-- Vi har hardcoded antal forekomster i tabellen: `matrikel_udgaaet_count`.

-- Et par linjer nede herfra, tilfoejes der et `|| ''å''`. Det er et hack,
-- for at representere den alfanumerisk sidste vej, der starter med `%s`

    IF (
        SELECT
            COALESCE(forekomster, 0)
        FROM
            basic.matrikel_udgaaet_count
        WHERE
            lower(input_tekst) = tekstelement ) > 1000
        AND filters = '1=1'
    THEN
        stmt = format(E'SELECT
                ejerlavsnavn::text,
                ejerlavskode::int,
                kommunenavn::text,
                kommunekode::text,
                matrikelnummer::text,
                visningstekst::text,
                jordstykke_id::int,
                bfenummer::int,
                CASE WHEN $4 = 25832 THEN ST_X(ST_GEOMETRYN(centroide_geometri,1))::numeric 
                ELSE ST_X(ST_transform(ST_GEOMETRYN(centroide_geometri,1), $4))::numeric END,
                CASE WHEN $4 = 25832 then ST_Y(ST_GEOMETRYN(centroide_geometri,1))::numeric 
                ELSE ST_Y(ST_transform(ST_GeometryN(centroide_geometri,1),$4))::numeric END,
                CASE WHEN $4 = 25832 THEN geometri
                ELSE ST_TRANSFORM(geometri, $4) END
            FROM
                basic.matrikel_udgaaet
            WHERE
                ejerlavsnavn ilike ''%s%%''
                OR matrikelnummer ilike ''%s''
            LIMIT $3;', input_tekst, input_tekst);
        --RAISE NOTICE 'stmt=%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit, srid;
    ELSE
        -- Execute and return the result
        stmt = format(E'SELECT
                ejerlavsnavn::text,
                ejerlavskode::int,
                kommunenavn::text,
                kommunekode::text,
                matrikelnummer::text,
                visningstekst::text,
                jordstykke_id::int,
                bfenummer::int,
                CASE WHEN $4 = 25832 THEN ST_X(ST_GEOMETRYN(centroide_geometri,1))::numeric 
                ELSE ST_X(ST_transform(ST_GEOMETRYN(centroide_geometri,1), $4))::numeric END,
                CASE WHEN $4 = 25832 then ST_Y(ST_GEOMETRYN(centroide_geometri,1))::numeric 
                ELSE ST_Y(ST_transform(ST_GeometryN(centroide_geometri,1),$4))::numeric END,
                CASE WHEN $4 = 25832 THEN geometri
                ELSE ST_TRANSFORM(geometri, $4) END
            FROM
                basic.matrikel_udgaaet
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2)
            )
            AND %s
            ORDER BY
                functions.combine_rank(
                    $2,
                    $2,
                    textsearchable_plain_col,
                    textsearchable_unaccent_col,
                    ''simple''::regconfig,
                    ''functions.gsearch_fts_config''::regconfig
                ) desc,
                ts_rank_cd(
                    textsearchable_phonetic_col,
                    to_tsquery(''simple'',$1)
                )::double precision desc,
                matrikelnummer,
                visningstekst
            LIMIT $3  ;', filters);
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit, srid;
    END IF;
END
$function$;

-- Test cases:
/*
 SELECT (api.matrikel_udgaaet('søby',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('11aa',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('1320452',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('11aa 1320452',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('1320452 11aa kobbe',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('11aa søby',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('s',NULL, 1, 100)).*;
 SELECT (api.matrikel_udgaaet('a 1 a', NULL, 1, 100)).*;

 */
