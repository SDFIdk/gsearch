CREATE COLLATION IF NOT EXISTS matrikelnummer_collation (provider = icu, locale = 'en@colNumeric=yes');

DROP TABLE IF EXISTS basic.matrikel;

WITH ejerlav_kommune_distinct as (
	select distinct
		j.ejerlavlokalid,
		k.kommunenavn,
		k.kommunekode,
		k.id_lokalid as kommuneidlokalid
	from
		matriklen.jordstykke j
		join matriklen.matrikelkommune k on k.id_lokalid = j.kommunelokalid
),
ejerlavnavn_kommune_distinct as (
	select 
		e.ejerlavsnavn,
		e.ejerlavskode::text,
		ek.kommunenavn,
		ek.kommunekode,
		ek.kommuneidlokalid
	from
		ejerlav_kommune_distinct ek
		join matriklen.ejerlav e on e.id_lokalid = ek.ejerlavlokalid
),
matrikelnumre AS (
    SELECT
        e.ejerlavsnavn,
        e.ejerlavskode::text,
        k.kommunenavn,
        k.kommunekode,
        j.matrikelnummer,
        s.bfenummer::text,
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
        JOIN matriklen.samletfastejendom s on s.id_lokalid = j.samletfastejendomlokalid
),
ejerlavsnavn_dups AS (
    SELECT
        count(1) ejerlavsnavn_count,
        ejerlavsnavn,
        (setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 1)), 'B') ||
        setweight(to_tsvector('simple', split_part(ejerlavsnavn, ' ', 2)), 'C') ||
        setweight(to_tsvector('simple', basic.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_plain_col_ejerlavsnavn,
        (setweight(to_tsvector('basic.septima_fts_config', split_part(ejerlavsnavn, ' ', 1)), 'B') ||
        setweight(to_tsvector('basic.septima_fts_config', split_part(ejerlavsnavn, ' ', 2)), 'C') ||
        setweight(to_tsvector('basic.septima_fts_config', basic.split_and_endsubstring (ejerlavsnavn, 3)), 'D')) AS textsearchable_unaccent_col_ejerlavsnavn,
        (setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(ejerlavsnavn, ' ', 1), 2)), 'B') ||
        setweight(to_tsvector('simple', fonetik.fnfonetik (split_part(ejerlavsnavn, ' ', 2), 2)), 'C') ||
        setweight(to_tsvector('simple', basic.split_and_endsubstring_fonetik (ejerlavsnavn, 3)), 'D')) AS textsearchable_phonetic_col_ejerlavsnavn
    FROM ( SELECT *
        FROM ejerlavnavn_kommune_distinct) x
    GROUP BY
        ejerlavsnavn
)
SELECT
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
    m.bfenummer,
    m.centroide_geometri,
    e.textsearchable_plain_col_ejerlavsnavn,
    e.textsearchable_unaccent_col_ejerlavsnavn,
    e.textsearchable_phonetic_col_ejerlavsnavn,
    st_multi (m.geometri) AS geometri INTO basic.matrikel
FROM
    matrikelnumre m
    JOIN ejerlavsnavn_dups e ON e.ejerlavsnavn = m.ejerlavsnavn;
    