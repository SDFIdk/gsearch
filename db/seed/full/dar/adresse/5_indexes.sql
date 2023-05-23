CREATE INDEX ON basic.adresse USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic.adresse USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic.adresse USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic.adresse (lower(vejnavn), navngivenvej_id, husnummer_sortering, sortering);

CREATE INDEX ON basic.adresse USING gist (geometri);

VACUUM ANALYZE basic.adresse;