CREATE COLLATION IF NOT EXISTS matrikelnummer_udgaaet_collation (provider = icu, locale = 'en@colNumeric=yes');

DROP TABLE IF EXISTS basic_initialloading.matrikel_udgaaet;

WITH ejerlav_kommune_distinct AS (
	SELECT distinct
		j.ejerlavlokalid,
		k.kommunenavn,
		k.kommunekode,
		k.id_lokalid AS kommuneidlokalid
	FROM
		matriklen_udgaaet.jordstykke j
		JOIN matriklen.matrikelkommune k ON k.id_lokalid = j.kommunelokalid
),
ejerlavnavn_kommune_distinct AS (
	SELECT 
		e.ejerlavsnavn,
		e.ejerlavskode::text,
		ek.kommunenavn,
		ek.kommunekode,
		ek.kommuneidlokalid
	FROM
		ejerlav_kommune_distinct ek
		JOIN matriklen.ejerlav e ON e.id_lokalid = ek.ejerlavlokalid
),
kommune_distinct AS (
	SELECT distinct
		k.kommunenavn,
		k.kommunekode,
		k.id_lokalid
	FROM 
		matriklen.matrikelkommune k
),
ejerlav_distinct AS (
	SELECT distinct
		ejerlavsnavn,
		ejerlavskode::text,
		id_lokalid
	FROM matriklen.ejerlav 
),
samletfastejendom_distinct AS (
	SELECT distinct
		bfenummer::text,
		id_lokalid
	FROM matriklen_udgaaet.samletfastejendom
),
lodflade_distinct AS (
	SELECT distinct
		jordstykkelokalid,
		geometri
	FROM matriklen_udgaaet.lodflade
),
jordstykke_distinct AS (
	SELECT distinct
		id_lokalid,
		matrikelnummer,
		ejerlavlokalid,
		kommunelokalid,
		samletfastejendomlokalid
	FROM matriklen_udgaaet.jordstykke
),
matrikelnumre AS (
    SELECT
        e.ejerlavsnavn,
        e.ejerlavskode::text,
        k.kommunenavn,
        k.kommunekode,
        j.matrikelnummer,
        j.id_lokalid::text,
        s.bfenummer::text,
        c.geometri AS centroide_geometri,
        st_force2d (COALESCE(l.geometri)) AS geometri
    FROM
        matriklen_udgaaet.jordstykke j
        JOIN ejerlav_distinct e ON e.id_lokalid = j.ejerlavlokalid
        JOIN matriklen_udgaaet.centroide c ON c.jordstykkelokalid = j.id_lokalid
        JOIN kommune_distinct k ON k.id_lokalid = j.kommunelokalid
        JOIN lodflade_distinct l ON l.jordstykkelokalid = j.id_lokalid
        LEFT JOIN samletfastejendom_distinct s ON s.id_lokalid = j.samletfastejendomlokalid
),
ejerlavsnavn_dups AS (
    SELECT
        count(1) ejerlavsnavn_count,
        ejerlavsnavn,
        (setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 1)), 'B') ||
        setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 2)), 'C') ||
        setweight(to_tsvector('simple', functions.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_plain_col_ejerlavsnavn,
        (setweight(to_tsvector('functions.gsearch_fts_config', split_part(ejerlavsnavn, ' ', 1)), 'B') ||
        setweight(to_tsvector('functions.gsearch_fts_config', split_part(ejerlavsnavn, ' ', 2)), 'C') ||
        setweight(to_tsvector('functions.gsearch_fts_config', functions.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_unaccent_col_ejerlavsnavn,
        (setweight(to_tsvector('simple', functions.fnfonetik (split_part(ejerlavsnavn, ' ', 1), 2)), 'B') ||
        setweight(to_tsvector('simple', functions.fnfonetik (split_part(ejerlavsnavn, ' ', 2), 2)), 'C') ||
        setweight(to_tsvector('simple', functions.split_and_endsubstring_fonetik (ejerlavsnavn, 3)), 'D')) AS textsearchable_phonetic_col_ejerlavsnavn
    FROM ( SELECT *
        FROM
            ejerlavnavn_kommune_distinct) x
    GROUP BY
        ejerlavsnavn
)
SELECT DISTINCT
    m.matrikelnummer || ', ' || CASE WHEN ejerlavsnavn_count > 1
        THEN
            m.ejerlavsnavn || ' (' || m.kommunenavn || ')'
        ELSE
            m.ejerlavsnavn
    END AS visningstekst,
    m.ejerlavsnavn,
    m.ejerlavskode,
    m.kommunenavn,
    m.kommunekode,
    m.matrikelnummer,
    m.id_lokalid AS jordstykke_id,
    m.bfenummer,
    m.centroide_geometri,
    e.textsearchable_plain_col_ejerlavsnavn,
    e.textsearchable_unaccent_col_ejerlavsnavn,
    e.textsearchable_phonetic_col_ejerlavsnavn,
    st_multi (m.geometri) AS geometri 
INTO basic_initialloading.matrikel_udgaaet
FROM
    matrikelnumre m
    JOIN ejerlavsnavn_dups e ON e.ejerlavsnavn = m.ejerlavsnavn;
    
