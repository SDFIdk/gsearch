# NOTES from evaluation of GSearch

## Generelt - forslag/observationer
**Rækkefølgen** af attributter bør være enten "logisk" eller alfabetisk

### Bør droppes** 
I alle output droppes:
* rang1
* rang2

### Kildedato
// Har det været overvejet om der skal være et tidsstempel på hvert response, som angiver 
// hvornår det pågældende kilderegister senest er access'et?

## Geometri
// kunne være optional 
* geometry=no // (default=yes)

// I de fleste implementeringer vil objektgeometrien tidligst være interessant når brugeren har fundet 
// den ønskede objektforekomst. Det betyder at response ofte slæber rundt på en dødvægt af koordinater 
// til de indtil 100 forekomster, som GSearch returnerer. Fx. søg postnummer med q=københ eller sogn 
// med q=a
// Jeg ved ikke om det vil have praktisk betydning på svartider i apps med svage forbindelser ...

* **bbox'** bør nok altid være med i output

## Geometri filter
* bounding box 

// jeg ved at **bounding box** ikke er en simple feature, men den vil være  praktisk for udvikleren 
// at anvende som geografisk filter - med 2 sæt koordinater i stedet for 5. Men måske tager jeg fejl

* geometri,SRID=25832;BBOX(515000.1 6074200.2, 555000.5 6104200.6)
* geometri,SRID=25832;POLYGON((515000.1 6074200.2, 515000.3 6104200.4, 555000.5 6104200.6, 555000.7 6074200.8, 515000.1 6074200.2))) 

## Til de enkelte ressourcer

### Navngiven vej 
Bør returnere
* kommunekoder (liste) // så man kan filtrere på dem - ligesom man kan (?) på postnummer

### Adresse 
Bør returnere
* id til navngiven vej  // så man kan filtrere på den
* id til husnummer // så man kan filtrere på den

### Husnummer
Bør returnere
* id til navngiven vej  // så man kan filtrere på den

### Matrikelnummer
Bør returnere
* kommunekode // så man kan filtrere på kommune
* jordstykkeId // så man kan arbejde videre med resultatet
* SFE-nummer // ditto (SFE = BFE-nummer)

// Matrikelnummer svarer strikt på q-parametren - for q=12 returneres kun jordstykker 
// med matrikelnummer '12' - ikke 12a, 12b eller 122 eller ... - er det bevidst? 
// Mit synspunkt: så længe q starter med et ciffer og derefter evt. har et bogstav, 
// skal response foreslå mulige matrikelnumre med flere tal/bogstaver. 
// Hvis q der efter cifte+evt. bogstave er tilføjet et skilletegn (space/, o.l.) 
// er det et tegn på at bbugeren "er færdig" med matrikelnummeret, hvorfor 
// response skal foreslå de ejerlav, hvori dette matrikelnummer findes. 

Præsentationsfelt er forkert:
* praesentation bør ikke være: _"Birkerød By, Bistrup - 129av"_ men _"129av, Birkerød By, Bistrup"_ 

### Kommune
Bør returnere
* regionskode // så man kan filtrere på region
* udenforkommuneinddeling (true/false) // som er false for alle undtagen _0411 Christiansø_

Response attributværdier rettes:
**praesentation** I response er _"kommune"_ med lille _"k"_ - korrekt retskrivning er _"Kommune"_
**Christiansø** har praesentation _"Christiansø kommune"_ - bør bare være _"Christiansø"_

## Opstillingskreds
Bør returnere
* landsdel // så man kan filtrere på den
* landsdelnummer // Hvis det findes (ditto)

## Politikreds
**Søgning** seems to equal query of first part of string with any part of string

## Postnummer
**Søgning** efter postnumre i københavn  //
// Filter på gadepostnummer

## Retskredse
**Retskredsnavne** starter altid med _"Retten i ..."_ det betyder at hvis man søger med "r" får man alle, først hvis q bliver _"ra"_ får man _"Retten i Randers"_

## Sogn
Bør returnere
* Reference til  Stift (navn eller kode?) - af hensyn til filtrering 

## Stednavne
Bør returnere
* regionskode (liste) // hvis muligt - af hensyn til filtrering
* kommunekode (liste) // ditto.

