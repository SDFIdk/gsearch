-- USE TEXTSEARCHABLE COLUMNS FROM NAVNGIVENVEJ INSTEAD OF RECOMPUTING THEM
-- append husnummer, etage, and dør
ALTER TABLE basic.adresse
    DROP COLUMN IF EXISTS textsearchable_plain_col;

-- supplerende bynavn kan være null så derfor bruges der coalesce som anbefalet fra postgres dokumentation
-- https://www.postgresql.org/docs/current/textsearch-controls.html#TEXTSEARCH-PARSING-DOCUMENTS
ALTER TABLE basic.adresse
    ADD COLUMN textsearchable_plain_col tsvector
        GENERATED ALWAYS AS (textsearchable_plain_col_vej ||
                             setweight(to_tsvector('simple', husnummer), 'D') ||
                             setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
                             setweight(to_tsvector('simple', doerbetegnelse), 'D') ||
                             setweight(to_tsvector('simple', coalesce(supplerendebynavn,'')), 'D') ||
                             setweight(to_tsvector('simple', postnummer), 'D') ||
                             setweight(to_tsvector('simple', postnummernavn), 'D'))
        STORED;

ALTER TABLE basic.adresse
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic.adresse
    ADD COLUMN textsearchable_unaccent_col tsvector
        GENERATED ALWAYS AS (textsearchable_unaccent_col_vej ||
                             setweight(to_tsvector('simple', husnummer), 'D') ||
                             setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
                             setweight(to_tsvector('simple', doerbetegnelse), 'D') ||
                             setweight(to_tsvector('simple', coalesce(supplerendebynavn,'')), 'D') ||
                             setweight(to_tsvector('simple', postnummer), 'D') ||
                             setweight(to_tsvector('simple', postnummernavn), 'D'))
        STORED;

ALTER TABLE basic.adresse
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic.adresse
    ADD COLUMN textsearchable_phonetic_col tsvector
        GENERATED ALWAYS AS (textsearchable_phonetic_col_vej ||
                             setweight(to_tsvector('simple', husnummer), 'D') ||
                             setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
                             setweight(to_tsvector('simple', doerbetegnelse), 'D') ||
                             setweight(to_tsvector('simple', coalesce(supplerendebynavn,'')), 'D') ||
                             setweight(to_tsvector('simple', postnummer), 'D') ||
                             setweight(to_tsvector('simple', postnummernavn), 'D'))
        STORED;
