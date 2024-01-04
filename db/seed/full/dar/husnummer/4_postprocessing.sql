ALTER TABLE basic_initialloading.husnummer
    ALTER COLUMN husnummertekst TYPE TEXT COLLATE husnummer_collation;


ALTER TABLE basic_initialloading.husnummer
    DROP COLUMN IF EXISTS textsearchable_plain_col;

ALTER TABLE basic_initialloading.husnummer
    ADD COLUMN textsearchable_plain_col tsvector
    GENERATED ALWAYS AS (textsearchable_plain_col_vej ||
                         setweight(to_tsvector('simple', husnummertekst), 'D') ||
                         setweight(to_tsvector('simple', postnummer), 'D') ||
                         setweight(to_tsvector('simple', postnummernavn), 'D'))
    STORED;

ALTER TABLE basic_initialloading.husnummer
    DROP COLUMN IF EXISTS textsearchable_unaccent_col;

ALTER TABLE basic_initialloading.husnummer
    ADD COLUMN textsearchable_unaccent_col tsvector
    GENERATED ALWAYS AS (textsearchable_unaccent_col_vej ||
                         setweight(to_tsvector('simple', husnummertekst), 'D') ||
                         setweight(to_tsvector('simple', postnummer), 'D') ||
                         setweight(to_tsvector('simple', postnummernavn), 'D'))
    STORED;

ALTER TABLE basic_initialloading.husnummer
    DROP COLUMN IF EXISTS textsearchable_phonetic_col;

ALTER TABLE basic_initialloading.husnummer
    ADD COLUMN textsearchable_phonetic_col tsvector
    GENERATED ALWAYS AS (textsearchable_phonetic_col_vej ||
                         setweight(to_tsvector('simple', husnummertekst), 'D') ||
                         setweight(to_tsvector('simple', postnummer), 'D') ||
                         setweight(to_tsvector('simple', postnummernavn), 'D'))
    STORED;
