-- The api functions can be called directly from the database with a select like this:
-- SELECT (api.{ENDPOINT}('{SEARCH TERM}', {CQL_FILTER}, {SORT_OPTS}, {LIMIT})).*;

SELECT (api.adresse('Christian -   ,   x', NULL, 1, 100)).*;
SELECT (api.husnummer('engsving', NULL, 1, 100)).*;
SELECT (api.kommune('2 ros.', NULL, 1, 100)).*;
SELECT (api.matrikel('kolding markjorder 3. Afd. - 10', NULL, 1, 100)).*;
SELECT (api.navngivenvej('2. tværvej', NULL, 1, 100)).*;
SELECT (api.opstillingskreds('kold', NULL, 1, 100)).*;
SELECT (api.politikreds('køben','myndighedskode=''1470''', 1, 100)).*;
SELECT (api.politikreds('køben','st_area(geometri) > ''184339980''', 1, 100)).*;
SELECT (api.postnummer('herning', NULL, 1, 100)).*;
SELECT (api.region('hovedstaden', NULL, 1, 100)).*;
SELECT (api.retskreds('aalborg', NULL, 1, 100)).*;
SELECT (api.sogn('vesterbro', NULL, 1, 100)).*;
SELECT (api.stednavn('Rundetårn', NULL, 1, 100)).*;
