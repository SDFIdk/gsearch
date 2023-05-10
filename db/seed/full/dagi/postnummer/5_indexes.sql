
CREATE INDEX ON basic.postnummer USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.postnummer USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.postnummer USING GIN (textsearchable_phonetic_col);
