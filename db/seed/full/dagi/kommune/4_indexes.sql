CREATE INDEX ON basic_initialloading.kommune (kommunekode);

CREATE INDEX ON basic_initialloading.kommune (kommunenavn);

VACUUM ANALYZE basic_initialloading.kommune;