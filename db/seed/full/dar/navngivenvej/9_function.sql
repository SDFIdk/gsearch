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
-- - matrikel
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
                id::text,
                vejnavn::text,
                visningstekst::text,
                postnummer,
                postnummernavn,
                kommunekode,
                geometri,
                bbox
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
                id::text,
                vejnavn::text,
                visningstekst::text,
                postnummer,
                postnummernavn,
                kommunekode,
                geometri,
                bbox
            FROM
                basic.navngivenvej
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
                ts_rank_cd(
                    textsearchable_phonetic_col,
                    to_tsquery(''simple'',$1)
                )::double precision desc,
                vejnavn
            LIMIT $3;', filters);
        --RAISE NOTICE '%', stmt;
        RETURN
        QUERY EXECUTE stmt
        USING query_string, plain_query_string, rowlimit;
    END IF;
END
$function$;
