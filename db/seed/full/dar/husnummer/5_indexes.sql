CREATE INDEX ON basic_initialloading.husnummer USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic_initialloading.husnummer USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic_initialloading.husnummer USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic_initialloading.husnummer (lower(vejnavn), navngivenvej_id, sortering);

CREATE INDEX ON basic_initialloading.husnummer (supplerendebynavn);

CREATE INDEX ON basic_initialloading.husnummer (kommunekode);

CREATE INDEX ON basic_initialloading.husnummer USING gist (geometri);

VACUUM ANALYZE basic_initialloading.husnummer;
