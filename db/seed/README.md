# gsearch

Installation af ny database:

 - Postgres database (fx. `test_gsearch`):
   - Encoding: UTF8
   - Collating: Danish_Denmark.1252
   - CType: Danish_Denmark.1252

 - Kopier følgende ned i Postgres installationsfolderen: .../share/tsearch_data/xsyn_gsearch.rules:
   - unaccent_gsearch.rules
   - xsyn_gsearch.rules
 
 - Populér data i schemaerne:
   - dagi_10
   - dagi_500
   - dar
   - matriklen
   - matriklen_udgaaet
   - stednavne_udstil
 - Kør SQL-filer i rækkefølge - dog undtaget: `010_init_fdw.sql` og `025_basic_data.sql`
 
Reload af schema

Hvis man ønsker at en databaseændring (DDL) skal resultere at en API-servicen genindlæser, skal følgende sql køres:

```sql
SELECT pg_notify('gsearch', 'reload');
```

