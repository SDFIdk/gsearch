-- Demo api
DROP SCHEMA IF EXISTS api CASCADE;
CREATE SCHEMA IF NOT EXISTS api;

CREATE TYPE api.demo AS (
  vejnavn TEXT,
  postdistrikt TEXT
);

COMMENT ON TYPE api.demo IS 'Demostruktur';
COMMENT ON COLUMN api.demo.vejnavn IS 'Navnet på vejen';
COMMENT ON COLUMN api.demo.postdistrikt IS 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce quis lectus quis sem lacinia nonummy. Proin mollis lorem non dolor. In hac habitasse platea dictumst. Nulla ultrices odio. Donec augue. Phasellus dui. Maecenas facilisis nisl vitae nibh. Proin vel seo est vitae eros pretium dignissim. Aliquam aliquam sodales orci. Suspendisse potenti.';

CREATE OR REPLACE FUNCTION api.demo(input_tekst text, filters jsonb, sortoptions int, rowlimit int)
 RETURNS SETOF api.demo
 LANGUAGE plpgsql
 STABLE
AS $function$
DECLARE 
  max_rows integer;
BEGIN
  -- Initialize
  max_rows = 100;
  IF rowlimit > max_rows THEN
    RAISE 'rowlimit skal være <= %', max_rows;
  END IF;
  
RETURN query (SELECT * FROM (VALUES ('Brudedalen', 'Farum'), ('Suhrs Allé', 'Farum'), ('Oshögavägen', 'Oxie')) t (vejnavn, postdistrikt)
WHERE t.vejnavn ILIKE input_tekst OR t.postdistrikt ILIKE input_tekst)
;
END
$function$
;

-- Test cases:
SELECT api.demo('Farum',NULL, 1, 100);
SELECT api.demo('suhrs Allé',NULL, 1, 100);
SELECT api.demo(null,NULL, 1, 100);
-- SELECT api.demo(null,NULL, 1, 200); -- Should fail!!

GRANT EXECUTE ON FUNCTION api.demo TO udv_gsearch_read
