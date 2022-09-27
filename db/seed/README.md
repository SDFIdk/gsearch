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
 
Reload af schema

Hvis man ænsker at en databaseændring (DDL) skal resultere at en API-servicen genindlæser, skal følgende sql køres:
```sql
SELECT pg_notify('gsearch', 'reload');
```


## Dataflow

Data bliver overfoert fra 2 forskellige postgres-clustre fordelt over 4 
forskellige database og 5 forskellige skemaer, og overfoert til databasen:
`gsearch` i skemaet: `basic`.

	Cluster
		database	- - - schema			-> schema		-> basic


	DAWA
		dawa        - - - public            -> dar          -> basic
	ugentlig
		matriklen   - - - matriklen_fdw     -> matriklen    -> basic
		dagi        - - - dagi_500_fdw      -> dagi_500     -> basic
					- - - dagi_10_fdw       -> dagi_10      -> basic
		stednavne   - - - stednavne_fdw     -> stednavne    -> basic


### nomnoml

Saet dette ind i nomnoml.com, for at faa et diagram:

```
#direction: right

[<postgres> DAWA |
    host: dbprimo.cuddlefish.intern
    port: 11312]
    
[<pgschema> public]
    
[<postgres> ugentlig |
	host: dbprimo.cuddlefish.intern
    port: 11714]
    
[<pgschema> matriklen]
[<pgschema> dagi]
[<pgschema> stednavne]

[<postgres> gsearch |
	host: dbprimo.cuddlefish.intern
    port: 11513]

[DAWA]->[public]

[public]->[gsearch]

[ugentlig]-[matriklen]
[ugentlig]-[dagi]
[ugentlig]-[stednavne]

[matriklen]->[gsearch]
[dagi]->[gsearch]
[stednavne]->[gsearch]
```
