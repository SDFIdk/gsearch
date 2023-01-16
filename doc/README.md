# GSearch dokumentation

**GSearch** er et REST-api som udstiller en metode til at søge i adresser, matrikelnumre og en række andre geografiske navne. Api'et tilbyder funktionalitet, som kan implementeres i en brugerapplikation i form af et søgefelt med autocomplete/typeahead funktion.

**GSearch** har i princippet samme funktionalitet og virkemåde som SDFI's nuværende søgekomponent, _GeoSearch_, men med en række forbedringer, bl.a. i muligheden af at sætte filtre, der kan fokusere og dermed optimere søgningen.

**GSearch** tekstsøgning håndterer typiske stave- og skrivevarianter og fonetiske ligheder i de navne der søges i, som fx Ågade/Aagade, Gl. Byvej/Gammel Byvej, Vester/Vestre, Ringkøbing/Ringkjøbing, Kathrine/Cathrine o.l.

## Generelt

**GSearch** opdateres på ugeligt basis, det planlagt at opdatere data på dagligbasis se [issue 92](https://github.com/SDFIdk/gsearch/issues/92) for opdatering.

**GSearch** kan søge i 12 data-ressourcer: adresse, husnummer, kommune, matrikel, navngiven vej, opstillingskreds, politikreds, politidistrikt, region, retskreds, sogn og stednavn.

Datakilder for ressourcerne er de fire autoritative grunddataregistre: Danmarks Adresseregister (DAR), Danmarks Administrative, Geografiske Inddeling (DAGI), Matriklen (MAT) og Danske Stednavne (DS), som alle udstilles via Datafordeleren.

I hver ressource søges der efter bedst mulig match i et eller flere felter/attributter som følger:

* Adresse: Der søges i DAR adresse, husnummer, navngivenvej, postnummer
* Husnummer: Der søges i DAR husnummer
* Kommune: Der søges i DAGI kommuneinddeling
* Matrikel: Der søges i MAT matrikelnummer
* Navngiven vej: Der søges i DAR navngivenvej og postnummer
* Opstillingskreds: Der DAGI opstillingskreds
* Politikreds: Der søges i DAGI politikreds
* Postnummer: Der søges i DAGI postnummerinddeling
* Region: Der søges i regionsinddeling
* Retskreds: Der søges i DAGI retskreds
* Sogn: Der søges i DAGI sogneinddeling
* Stednavn: Der søges i stednavneregisteret på tværs af alle stednavne

## Request syntax
**URL** til GSearch er `https://api.dataforsyningen.dk/rest/gsearch/v1.0/search`

**Søgning:** De centrale inputparametre er _'resources'_, som angiver hvilken data-ressource der skal søges i og _'q'_, der er en tekststreng som angiver hvad der skal søges efter.

_Eksempel,_ hvor der søges efter navngivne veje med 'lærke'

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/search?resources=navngivenvej&q=Lærke HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Parameteren _'resources'_ _kan_ definere mere end én data-ressource. I så fald skal man være opmærksom på at den supplerende parameter _'filter'_ ikke kan anvendes.

**Supplerende request parametre** kan anvendes til at målrette søgningen hhv. begrænse antallet af svar i response:

_Parametren 'limit'_ begrænser det mulige antal svar i response. Maksimum er 100; default værdi er 10.

_Eksempel,_ hvor der der søges efter navngivne veje med 'vinkel' og en limit på 90

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/search?resources=navngivenvej&q=vinkel&limit=90 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
### Filter
_Parametren 'filters'_ angiver hvilken del af data-ressourcen, der søges i.

Filtre skal defineres i syntaksen _ECQL_, som er en GeoServer extension af Open Geospatial Consortiums <https://docs.geoserver.org/stable/en/user/tutorials/cql/cql_tutorial.html>

Et ECQL filterudtryk kan anvende værdier fra en eller flere af de attributter, der optræder i den pågældende data-ressources retursvar, herunder geometrien i attributterne fx _'bbox'_ og _'geometri'_.

**NB** Det er vigtigt at ECQL-udtrykket anvender fuld URL-encoding så `'` fx encodes til `%27` og at udtrykken er defineret som tekst.

**NB** Attributter i retursvaret, der udgør et array, kan ikke benyttes som filter. Det gælder fx attributten _'postnummer'_ i ressourcen _'navngivenvej'_.

_Eksempel_ på simpelt filter på husnummer: kommunekode '0461', dvs. Odense, bemærk brugen af `%27` som erstatning for `'`.

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/search?resources=husnummer&q=lærke&filter=kommunekode=%270461%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

Brug af geometri som filter vil være relevant når man ønsker at begrænse søgningen inden for en polygon, der fx kan repræsentere et kortudsnit i brugerapplikationen.

Det spatiale referencesystem i et geometrifilter skal angives som _'SRID=25832'_.

Adresser og husnumre har ikke geometri i _'bbox'_ eller _'geometri'_, Geometri findes hér i _'vejpunkt_geometri'_ og _'adgangspunkt_geometri'_, som derfor kan anvendes i et geografisk filter.

_Eksempel_ på filter med geometri for stednavne inden for et område i Sønderjylland

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/search?resources=stednavn&q=ben&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```

## Response
Resultatet af en forespørgsel indeholder de forekomster, som matcher forespørgslen bedst muligt. Antallet af forekomster begrænses af parmereten _'limit'_ (se ovenfor).Response er formateret som JSON.

**Indhold:** Response indeholder altid det fundne objekts autoritative _'id'_ samt en tekststreng _'praesentation'_ der fungerer som visuel repræsentation af objektet og som eksempelvis kan implementeres i en liste med søgeresultater, efterhånden som brugeren føjer tegn til søgestrengen.

**Objektgeometri:** Objektgeometri er inkluderet i response som GeoJSON i referencesystem EPSG:25832 (ETRS89 UTM Zone 32).

For adresse og husnummer indeholder response geometri i attributterne _'vejpunkt_geometri'_ og _'adgangspunkt_geometri'_. Øvrige data-ressourcer har to sæt geometri: _'bbox'_, der er en beregnet bounding box, og _'geometri'_ der er basisregisterets objektgeometri.

For DAGI-objekterne, dvs. kommune, kommune, opstillingskreds, politikreds, postnummer, region, retskreds, sogn, anvendes den generaliserede _'D500'_ geometri.

**Attributter i øvrigt:** Det øvrige indhold af objekt-attributter i response afhænger i øvrigt af data-ressourcen, som det fremgår af eksemplerne herunder. Output for hver ressource er i øvrigt dokumenteret under [schemas](https://docs.dataforsyningen.dk/#gsearch-schemas).

<h2 id="gsearch-eksempler">Eksempler</h2>

### Adresse
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/adresse?q=flens HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'flens':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/adresse?limit=30&q=fle&filter=kommunekode=%270360%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'fle' med med limit=30 og filter på kommunekode 0360, dvs. Lolland Kommune:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/adresse?limit=100&q=skanse&filter=INTERSECTS(vejpunkt_geometri,SRID=25832%3BPOLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'skanse' med limit=100 og filter på vejpunkt_geometri - et område i Sønderjylland:

<br/><br/>

### Husnummer
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/husnummer?q=genvej HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'genvej':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/husnummer?limit=30&q=fl&filter=kommunekode=%270376%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'fl' med med limit=30 og filter på kommunekode 0376, dvs. Guldborgsund Kommune:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/husnummer?limit=100&q=fjordbak&filter=INTERSECTS(adgangspunkt_geometri,SRID=25832%3BPOLYGON((615000.1%206049000.2,%20615000.3%206111000.4,%20735000.5%206111000.6,%20735000.7%206049000.8,%20615000.1%206049000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'fjordbak' med limit=100 og filter på adgangspunkt_geometri - Lolland-Falster:

<br/><br/>

### Kommune
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/kommune?q=a HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'a':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/kommune?q=a&filter=kommunekode=%270851%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'a' med filter på kommunekode '0851':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/kommune?q=l&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((530000.1%206085450.2,%20530000.3%206092950.4,%20540000.5%206092950.6,%20540000.7%206085450.8,%20530000.1%206085450.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'l' med filter på geometri - Lolland-Falster:

<br/><br/>


### Matrikel
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/matrikel?q=123ab HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '123ab':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/matrikel?q=123ab&filter=ejerlavskode=%27130653%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '123ab' med filter på ejerlavskode '130653':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/matrikel?q=22&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((530000.1%206085450.2,%20530000.3%206092950.4,%20540000.5%206092950.6,%20540000.7%206085450.8,%20530000.1%206085450.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter '22' med filter på geometri - Lolland-Falster:

<br/><br/>

### Navngivenvej
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/navngivenvej?limit=100&q=krin HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks-eksempel som søger efter 'krin' med limit=100 (>100 resultater):

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/navngivenvej?q=birk&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((515000.1%206074200.2,%20515000.3%206104200.4,%20555000.5%206104200.6,%20555000.7%206074200.8,%20515000.1%206074200.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'birk' med filter på geometri - et område i Sønderjylland:

<br/><br/>

### Opstillingskreds
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/opstillingskreds?q=vest HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'vest':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/opstillingskreds?q=vest&filter=storkredsnummer=%276%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'vest' med filter på storkreds '6':

<br/><br/>

### Politikreds
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/politikreds?q=vest HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'vest':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/politikreds?q=ø&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((440000.1%206190000.2,%20440000.3%206410000.4,%20620000.5%206410000.6,%20620000.7%206190000.8,%20440000.1%206190000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'ø' med filter på geometri - Nørrejylland:

<br/><br/>

### Postnummer
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/postnummer?limit=60&q=b HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'b' og limit '60':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/postnummer?q=mari HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'mari':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/postnummer?q=mari&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((615000.1%206049000.2,%20615000.3%206111000.4,%20735000.5%206111000.6,%20735000.7%206049000.8,%20615000.1%206049000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'mar'og filter på geometri - Lolland-Falster:

<br/><br/>

### Region
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/region?q=mid HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'mid':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/region?q=regi HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'regi' (og returnerer alle fem):

<br/><br/>

### Retskreds
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/retskreds?q=mid HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'mid':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/retskreds?q=a HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'a' (og returnerer alle fem):

<br/><br/>

### Sogn
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/sogn?q=bis HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'bis:

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/sogn?q=skal HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'skal':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/sogn?q=r&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((625000.1%206165000.2,%20625000.3%206215000.4,%20677000.5%206215000.6,%20677000.7%206165000.8,%20625000.1%206165000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'r' og med filter på geometri - Odsherred:

<br/><br/>

### Stednavn
```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/stednavn?q=kattebj HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'kattebj':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/stednavn?limit=40&q=kratg HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'kratg':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/stednavn?q=katte&filter=stednavn_type=%27bebyggelse%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'katte' og med filter på type af stednavn 'bebyggelse':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/stednavn?q=katte&filter=stednavn_subtype=%27moseSump%27 HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'katte' og med filter på type af stednavn 'moseSump':

<br/><br/>

```http
GET https://api.dataforsyningen.dk/rest/gsearch/v1.0/stednavn?q=steng&filter=INTERSECTS(geometri,SRID=25832%3BPOLYGON((625000.1%206165000.2,%20625000.3%206215000.4,%20677000.5%206215000.6,%20677000.7%206165000.8,%20625000.1%206165000.2))) HTTP/1.1
Host: api.dataforsyningen.dk
Accept: application/json
```
Syntaks eksempel som søger efter 'steng' og med filter på geometri - Odsherred:

<br/><br/>

