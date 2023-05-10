CREATE INDEX ON basic.husnummer USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.husnummer USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.husnummer USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.husnummer (lower(vejnavn), navngivenvej_id, sortering);
