DROP FUNCTION IF EXISTS api.navngivenvej (text, text, int, int, int);

CREATE OR REPLACE FUNCTION api.navngivenvej (input_tekst text, filters text, sortoptions integer, rowlimit integer, srid integer)
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

    SELECT
        -- Removes repeated whitespace and following symbols -()!
        regexp_replace(btrim(input_tekst), '[-()! \s]+', ' ', 'g')
    INTO input_tekst;

    -- Build the query_string
    WITH tokens AS (
        SELECT
            UNNEST(string_to_array(btrim(input_tekst), ' ')) t
    )
    SELECT
        string_agg(functions.fnfonetik (t, 2), ':* & ') || ':*'
    FROM
        tokens INTO query_string;
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
        tokens INTO plain_query_string;

-- Hvis en input_tekst kun indeholder bogstaver og har over 1000 resultater, kan soegningen tage lang tid.
-- Dette er dog ofte soegninger, som ikke noedvendigvis giver mening. (fx. husnummer = 's'
-- eller adresse = 'od').
-- Saa for at goere api'et hurtigere ved disse soegninger, er der to forskellige queries
-- i denne funktion. Den ene bliver brugt, hvis der er over 1000 forekomster.
-- Vi har hardcoded antal forekomster i tabellen: `navngivenvej_count`.

-- Et par linjer nede herfra, tilfoejes der et `|| ''å''`. Det er et hack,
-- for at representere den alfanumerisk sidste vej, der starter med `%s`
    IF (
        SELECT
            COALESCE(forekomster, 0)
        FROM
            basic.navngivenvej_count
        WHERE
            lower(input_tekst) = tekstelement) > 1000
        AND filters = '1=1' THEN
        stmt = format(E'SELECT
                id::text,
                vejnavn::text,
                supplerendebynavn::text,
                visningstekst::text,
                postnummer,
                postnummernavn,
                kommunekode,
                CASE WHEN $4 = 25832 THEN geometri
                ELSE ST_TRANSFORM(geometri, $4) END,
                CASE WHEN $4 = 25832 THEN bbox::geometry
                ELSE BOX2D(ST_TRANSFORM(bbox, ''EPSG:25832'', $4))::geometry END
            FROM
                basic.navngivenvej
            WHERE
                lower(vejnavn) >= lower(''%s'') AND lower(vejnavn) <= lower(''%s'') || ''å''
            ORDER BY
                lower(vejnavn)
            LIMIT $3;', input_tekst, input_tekst);
        --RAISE NOTICE '%', stmt;
        RETURN QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit, srid;
    ELSE
        stmt = format(E'SELECT
                id::text,
                vejnavn::text,
                supplerendebynavn::text,
                visningstekst::text,
                postnummer,
                postnummernavn,
                kommunekode,
                CASE WHEN $4 = 25832 THEN geometri
                ELSE ST_TRANSFORM(geometri, $4) END,
                CASE WHEN $4 = 25832 THEN bbox::geometry
                ELSE BOX2D(ST_TRANSFORM(bbox, ''EPSG:25832'', $4))::geometry END
            FROM
                basic.navngivenvej
            WHERE (
                textsearchable_phonetic_col @@ to_tsquery(''simple'', $1)
                OR textsearchable_unaccent_col @@ to_tsquery(''simple'', $2)
                OR textsearchable_plain_col @@ to_tsquery(''simple'', $2))
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
                vejnavn
            LIMIT $3;', filters);
        --RAISE NOTICE '%', stmt;
        RETURN
        QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit, srid;
    END IF;
END
$function$;
