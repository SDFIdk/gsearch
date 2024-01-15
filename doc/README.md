# GSearch dokumentation

**GSearch** er et REST-api som udstiller forskellige endpoints til at søge i adresser, matrikelnumre og Danmarks Administrative Geografiske Inddeling og Danske Stednavne.
API'et tilbyder funktionalitet, som kan implementeres i en brugerapplikation i form af et søgefelt med autocomplete/typeahead funktion.
Der kan ses en demo af sådan en implementation her [GSearch-UI](https://sdfidk.github.io/gsearch-ui/).
Hvordan GSearch-UI kan installeres som en NPM pakke, kan læses mere om på dets [Github repository](https://github.com/SDFIdk/gsearch-ui#installation).


**GSearch** tekstsøgning håndterer typiske stave- og skrivevarianter og fonetiske ligheder i de navne der søges i, som fx Ågade/Aagade, Gl. Byvej/Gammel Byvej, Vester/Vestre, Ringkøbing/Ringkjøbing, Kathrine/Cathrine og lignende.

## Generelt

**GSearch** opdateres på ugentligt basis. Der er planlagt at opdatere data på daglig basis se [issue 92](https://github.com/SDFIdk/gsearch/issues/92) for opdatering.
Bemærk særligt at data fra DAR ikke har samme høje opdateringsfrekvens som i andre sammenhænge.

**GSearch** kan søge i de ressourcer listet nedenfor.

Datakilder for ressourcerne er de fire autoritative grunddataregistre:
Danmarks Adresseregister (DAR), Danmarks Administrative Geografiske Inddeling (DAGI), Matriklen (MAT) og Danske Stednavne, som udstilles via Datafordeler.dk.

I hvert endpoint søges der efter bedst mulig match i et eller flere felter/attributter som følger:

* Adresse: Der søges i DAR adresse
* Husnummer: Der søges i DAR husnummer
* Kommune: Der søges i DAGI kommuneinddeling
* Matrikel: Der søges i MAT matrikelnummer
* Matrikel udgået: Der søges i MAT udgaaet matrikelnummer
* Navngiven vej: Der søges i DAR navngivenvej
* Opstillingskreds: Der søges i DAGI opstillingskreds
* Politikreds: Der søges i DAGI politikreds
* Postnummer: Der søges i DAGI postnummerinddeling
* Region: Der søges i DAGI regionsinddeling
* Retskreds: Der søges i DAGI retskreds
* Sogn: Der søges i DAGI sogneinddeling
* Stednavn: Der søges i danske stednavne

Følgende tegn i `q` parameteren bliver anset som mellemrum; `-`,`(`,`)`,`!`

## Request syntax
**URL** til GSearch er `https://api.dataforsyningen.dk/rest/gsearch/v2.0/{resource}`

**Søgning:** Den centrale inputparameter er `q`, der er en tekststreng som angiver hvad der skal søges efter.

_Eksempel:_ Søges efter navngivne veje med `lærke`.

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/navngivenvej?q=Lærke HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

**Supplerende request parametre** kan anvendes til at målrette søgningen hhv. begrænse antallet af svar i response:

_Parametren_ `limit` begrænser det mulige antal svar i response. Maksimum er 100; default værdi er 10.

_Eksempel:_ Søges efter navngivne veje med 'vinkel' og en `limit=90`.

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/navngivenvej?q=vinkel&limit=90 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

### Filter
_Parametren_ `filter` angiver hvilken del af data-ressourcen, der søges i.

`Filter` skal defineres i syntaksen _ECQL_, som er en GeoServer extension af Open Geospatial Consortiums https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html.

Et ECQL filterudtryk kan anvende værdier fra en eller flere af de attributter, der optræder i den pågældende data-ressources retursvar, herunder geometrien i attributterne fx `bbox` og `geometri`.

**NB** Det er vigtigt at ECQL-udtrykket anvender fuld URL-encoding så f.eks `'` encodes til `%27`, `%` encodes til `%25` og at udtrykket er defineret som tekst.

_Eksempel:_ Simpelt filter på husnummer: kommunekode '0461', dvs. Odense, bemærk brugen af `%27` som erstatning for `'` og `%25` som erstatning for `%`.

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/husnummer?q=lærke&filter=kommunekode%20like%20%27%250461%25%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Brug af geometri som filter vil være relevant, når man ønsker at begrænse søgningen inden for en polygon, der fx kan repræsentere et kortudsnit i brugerapplikationen.

Det spatiale referencesystem i et geometrifilter skal angives i EPSG:25832 (ETRS89 UTM Zone 32).

Adresser og husnumre har ikke geometri i `bbox`, de har dog en ekstra `vejpunkt_geometri` udover `geometri` (indeholder geometrien fra adgangspunkt_geometri), som begge kan anvendes i et geografisk filter.
Matrikel og matrikel udgået har hellere ikke geometri i `bbox`, men de har to ekstra `centroid_x` og `centroid_y` udover `geometri`, som alle tre kan anvendes i et geografisk filter.

_Eksempel:_ Filter med geometri (POLYGON) for stednavne inden for et område i Sønderjylland.

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/stednavn?q=ben&filter=INTERSECTS(geometri,POLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

_Eksempel:_ Filter med geometri (BBOX) for stednavne inden for et område i Sønderjylland.

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/stednavn?q=ben&filter=BBOX(geometri,%20515000.1,6074200.2,%20555000.5,6104200.6,%20%27epsg:25832%27) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

## Response
Resultatet af en forespørgsel indeholder de forekomster, som matcher forespørgslen bedst muligt. Antallet af forekomster begrænses af parameteren `limit` (se ovenfor). Response er formateret som JSON.

**Indhold:** Response indeholder altid det fundne objekts autoritative `id` samt en tekststreng `visningstekst`, der fungerer som visuel repræsentation af objektet og som eksempelvis kan implementeres i en liste med søgeresultater, efterhånden som brugeren føjer tegn til søgestrengen.

**Objektgeometri:** Objektgeometri er inkluderet i response som GeoJSON i referencesystemet EPSG:25832 (ETRS89 UTM Zone 32).

For adresse- og husnummer ressourcerne indeholder response geometrier i attributterne `geometri` (indeholder geometrien fra adgangspunkt_geometri) og `vejpunkt_geometri`.
For matrikel og matrikel udgået indeholder response geomtrier i attributterne `centroid_x`, `centroid_y` og `geometri`.
Øvrige data-ressourcer har to sæt geometrier: `bbox`, der er en beregnet bounding box, og `geometri` der er basisregisterets objektgeometri.

For DAGI-objekterne; Postnummer bliver returneret i skala 1:10.000 (referenceskala). Kommune, opstillingskreds, politikreds, region, retskreds, sogn returneres i skala 1:500.000 (generaliseret version).

**Attributter i øvrigt:** Det øvrige indhold af objekt-attributter i response afhænger i øvrigt af data-ressourcen, som det fremgår af eksemplerne herunder. Output for hver ressource er i øvrigt dokumenteret under [schemas](https://docs.dataforsyningen.dk/#gsearch_v2.0.0-schemas).

Hvis en request tager længere tid end 10 sekunder, bliver requesten afbrudt og returnerer en [504 Gateway Timeout](https://www.rfc-editor.org/rfc/rfc9110#name-504-gateway-timeout).

<h2 id="gsearch-eksempler">Eksempler</h2>
<h3 id="dok_adresse">adresse</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/adresse?q=flens HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'flens':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/adresse?limit=30&q=fle&filter=kommunekode%20like%20%27%250360%25%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'fle' med med `limit=30` og `filter` på `kommunekode` '0360', dvs. Lolland Kommune:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/adresse?limit=100&q=skanse&filter=INTERSECTS(vejpunkt_geometri,POLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'skanse' med `limit=100` og filter på `vejpunkt_geometri` - et område i Sønderjylland:

<br/><br/>

<h3 id="dok_husnummer">husnummer</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/husnummer?q=genvej HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'genvej':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/husnummer?limit=30&q=fl&filter=kommunekode%20like%20%27%250376%25%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'fl' med med `limit=30` og `filter` på `kommunekode` '0376', dvs. Guldborgsund Kommune:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/husnummer?limit=100&q=fjordbak&filter=INTERSECTS(geometri,POLYGON((615000.1%206049000.2,%20615000.3%206111000.4,%20735000.5%206111000.6,%20735000.7%206049000.8,%20615000.1%206049000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'fjordbak' med `limit=100` og `filter` på `geometri` - Lolland-Falster:

<br/><br/>

<h3 id="dok_kommune">kommune</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/kommune?q=a HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'a':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/kommune?q=a&filter=kommunekode%20like%20%27%250851%25%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'a' med `filter` på `kommunekode` '0851', dvs. Aalborg Kommune:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/kommune?q=l&filter=INTERSECTS(geometri,POLYGON((615000.1%206049000.2%2C%20615000.3%206111000.4%2C%20735000.5%206111000.6%2C%20735000.7%206049000.8%2C%20615000.1%206049000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'l' med `filter` på `geometri` - Lolland-Falster:

<br/><br/>

<h3 id="dok_matrikel">matrikel</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel?q=123ab HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '123ab':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel?q=123ab&filter=ejerlavskode=%27130653%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '123ab' med `filter` på `ejerlavskode` '130653':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel?q=a&filter=bfenummer=%27100032397%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'a' med `filter` på `bfenummer` '100032397':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel?q=2&filter=INTERSECTS(geometri,POLYGON((530000.1%206085450.2,%20530000.3%206092950.4,%20540000.5%206092950.6,%20540000.7%206085450.8,%20530000.1%206085450.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '2' med `filter` på `geometri` - Sønderjylland:

<br/><br/>

<h3 id="dok_matrikel_udgaaet">matrikel udgået</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel_udgaaet?q=11a HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '11a':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel_udgaaet?q=11a&filter=ejerlavskode=%2770854%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '11a' med `filter` på `ejerlavskode` '70854':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel_udgaaet?q=e&filter=bfenummer=%275290287%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'e' med `filter` på `bfenummer` '5290287':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/matrikel_udgaaet?q=1&filter=INTERSECTS(geometri,POLYGON((530000.1%206085450.2,%20530000.3%206092950.4,%20540000.5%206092950.6,%20540000.7%206085450.8,%20530000.1%206085450.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '1' med `filter` på `geometri` - Sønderjylland:

<br/><br/>

<h3 id="dok_navngivenvej">navngivenvej</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/navngivenvej?limit=100&q=krin HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks-eksempel som søger efter 'krin' med `limit=100` (>100 resultater):

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/navngivenvej?q=birk&filter=INTERSECTS(geometri,POLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'birk' med `filter` på `geometri` - et område i Sønderjylland:

<br/><br/>

<h3 id="dok_opstillingskreds">opstillingskreds </h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/opstillingskreds?q=vest HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'vest':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/opstillingskreds?q=vest&filter=storkredsnummer=%276%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'vest' med filter på storkreds '6':

<br/><br/>

<h3 id="dok_politikreds">politikred </h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/politikreds?q=vest HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'vest':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/politikreds?q=ø&filter=INTERSECTS(geometri,POLYGON((440000.1%206190000.2,%20440000.3%206410000.4,%20620000.5%206410000.6,%20620000.7%206190000.8,%20440000.1%206190000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'ø' med `filter` på `geometri` - Nørrejylland:

<br/><br/>

<h3 id="dok_postnummer">postnummer</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/postnummer?limit=60&q=b HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'b' og `limit=60`:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/postnummer?q=mari HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'mari':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/postnummer?q=mari&filter=INTERSECTS(geometri,POLYGON((615000.1%206049000.2,%20615000.3%206111000.4,%20735000.5%206111000.6,%20735000.7%206049000.8,%20615000.1%206049000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'mar'og `filter` på `geometri` - Lolland-Falster:

<br/><br/>

<h3 id="dok_region">region</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/region?q=mid HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'mid':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/region?q=regi HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'regi':

<br/><br/>

<h3 id="dok_retskreds">retskreds</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/retskreds?q=ros HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'ros':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/retskreds?q=a HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'a':

<br/><br/>

<h3 id="dok_sogn">sogn</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/sogn?q=bis HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'bis:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/sogn?q=skal HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'skal':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/sogn?q=r&filter=INTERSECTS(geometri,POLYGON((625000.1%206165000.2,%20625000.3%206215000.4,%20677000.5%206215000.6,%20677000.7%206165000.8,%20625000.1%206165000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'r' og med `filter` på `geometri` - Odsherred:

<br/><br/>

<h3 id="dok_stednavn">stednavn</h3>
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/stednavn?q=kattebj HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'kattebj':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/stednavn?limit=40&q=kratg HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'kratg':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/stednavn?q=katte&filter=stednavn_type=%27bebyggelse%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'katte' og med `filter` på type af stednavn 'bebyggelse':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/stednavn?q=katte&filter=stednavn_subtype=%27moseSump%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'katte' og med `filter` på type af stednavn 'moseSump':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v2.0/stednavn?q=steng&filter=INTERSECTS(geometri,POLYGON((625000.1%206165000.2,%20625000.3%206215000.4,%20677000.5%206215000.6,%20677000.7%206165000.8,%20625000.1%206165000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'steng' og med `filter` på `geometri` - Odsherred:

<br/><br/>

