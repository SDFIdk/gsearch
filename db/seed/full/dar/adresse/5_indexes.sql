CREATE INDEX ON basic_initialloading.adresse USING GIN (textsearchable_plain_col);

CREATE INDEX ON basic_initialloading.adresse USING GIN (textsearchable_unaccent_col);

CREATE INDEX ON basic_initialloading.adresse USING GIN (textsearchable_phonetic_col);

CREATE INDEX ON basic_initialloading.adresse (lower(vejnavn), navngivenvej_id, husnummer_sortering, sortering);

CREATE INDEX ON basic_initialloading.adresse (supplerendebynavn);

CREATE INDEX ON basic_initialloading.adresse (kommunekode);

CREATE INDEX ON basic_initialloading.adresse USING gist (geometri);

VACUUM ANALYZE basic_initialloading.adresse;
