-- USE TEXTSEARCHABLE COLUMNS FROM NAVNGIVENVEJ INSTEAD OF RECOMPUTING THEM
-- append husnummer, etage, and dør
ALTER TABLE basic_initialloading.adresse
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic_initialloading.adresse
    ADD COLUMN textsearchable_plain_col tsvector
        GENERATED ALWAYS AS (textsearchable_plain_col_vej ||
                             setweight(to_tsvector('simple', husnummer), 'D') ||
                             setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
                             setweight(to_tsvector('simple', doerbetegnelse), 'D') ||
                             setweight(to_tsvector('simple', postnummer), 'D') ||
                             setweight(to_tsvector('simple', postnummernavn), 'D'))
        STORED;

ALTER TABLE basic_initialloading.adresse
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic_initialloading.adresse
    ADD COLUMN textsearchable_unaccent_col tsvector
        GENERATED ALWAYS AS (textsearchable_unaccent_col_vej ||
                             setweight(to_tsvector('simple', husnummer), 'D') ||
                             setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
                             setweight(to_tsvector('simple', doerbetegnelse), 'D') ||
                             setweight(to_tsvector('simple', postnummer), 'D') ||
                             setweight(to_tsvector('simple', postnummernavn), 'D'))
        STORED;

ALTER TABLE basic_initialloading.adresse
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic_initialloading.adresse
    ADD COLUMN textsearchable_phonetic_col tsvector
        GENERATED ALWAYS AS (textsearchable_phonetic_col_vej ||
                             setweight(to_tsvector('simple', husnummer), 'D') ||
                             setweight(to_tsvector('simple', etagebetegnelse), 'D') ||
                             setweight(to_tsvector('simple', doerbetegnelse), 'D') ||
                             setweight(to_tsvector('simple', postnummer), 'D') ||
                             setweight(to_tsvector('simple', postnummernavn), 'D'))
        STORED;
