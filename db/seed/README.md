# gsearch
Installation af ny database:

 - Postgres database (fx. `test_gsearch`):
   - Encoding: UTF8
   - Collating: Danish_Denmark.1252
   - CType: Danish_Denmark.1252

 - Kopier følgende ned i Postgres installationsfolderen: .../share/tsearch_data/xsyn_gsearch.rules:
   - unaccent_gsearch.rules
   - xsyn_gsearch.rules
 
 Hvis der er adgang til Foreign Data Server hos Septima (prod_geosearch og prod_databox):
 - Kør SQL-filer i rækkefølge
 - Afhængighed af eksterne data:
   - prod_geosearch:
     - dagi_10m_nohist_l1
     - dagi_500m_nohist_l1
     - fonetik
     - stednavne_udstil
   - prod_databox:
     - dar
     - mat_kf

Hvis der ikke er adgang men data kommer et andet sted fra, skal data ligge i de særskilte schemaer:
 - Populér data i schemaerne:
   - dagi_10m_nohist_l1
   - dagi_500m_nohist_l1
   - dar
   - mat_kf
   - stednavne_udstil
 - Kør SQL-filer i rækkefølge - dog undtaget: `010_init_fdw.sql` og `025_basic_data.sql`
 

