Feature: Gsearch stednavn test

    Background:
        * url url + '/stednavn'

    Scenario: Response matches columns database
        Then param q = 'valbyparken'

        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains only
        """
            {
                "skrivemaade_uofficiel": '#null',
                "skrivemaade_officiel": '#string',
                "visningstekst": '#string',
                "bbox": '#(bboxSchema)',
                "skrivemaade": '#string',
                "stednavn_subtype": '#string',
                "stednavn_type": '#string',
                "kommunekode": '#string',
                "geometri": '#(geometriSchema)',
                "id": '#string'
            }
        """


    Scenario: Partial string
        Then param q = 'valby g'

        When method GET
        Then status 200
        And match response == '#[3]'
        And match response.[*].skrivemaade_officiel contains only ['Gadekærvej Storbyhave', 'Valby Gl. Skole', 'Store Valbygård']
        And match response.[*].visningstekst contains only ['Valby Gadekær (Gadekærvej Storbyhave, Seværdighed i Valby)', 'Valby Gl. Skole (Bygning i Helsinge)', 'Store Valbygård (Gård i Roskilde)']


    Scenario: Search is case insensitive
        Then param q = 'Valbyparken'

        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'
        And match firstresponse.[*].visningstekst contains only ['Valbyparken (Park i København SV)']
        And match firstresponse.[*].skrivemaade_officiel contains only ['Valbyparken']
        And match firstresponse.[*].skrivemaade_uofficiel contains only ['#null']


        Then param q = 'valbyparken'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'
        And match secondresponse.[*].visningstekst contains only ['Valbyparken (Park i København SV)']
        And match secondresponse.[*].skrivemaade_officiel contains only ['Valbyparken']
        And match secondresponse.[*].skrivemaade_uofficiel contains only ['#null']
        Then match firstresponse == secondresponse


        Then param q = 'VALBYPARKEN'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'
        And match thirdresponse.[*].visningstekst contains only ['Valbyparken (Park i København SV)']
        And match thirdresponse.[*].skrivemaade_officiel contains only ['Valbyparken']
        And match thirdresponse.[*].skrivemaade_uofficiel contains only ['#null']
        Then match thirdresponse == secondresponse


    Scenario: Combined search
        Then param q = 'valby park'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].skrivemaade_officiel contains only ['Valbyparken']


    Scenario: Do not have a match on '.'
        Then param q = '.'

        When method GET
        Then status 200
        And match response == '#[0]'


    Scenario: Test maximum limit and one character search
        Then param q = 's'

        And param limit = '100'
        When method GET
        Then status 200
        And match response == '#[100]'


    Scenario: Partial string
        Then param q = 'retten i aa'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].visningstekst contains only ['Retten i Aalborg (Bygning i Aalborg)', 'Retten i Århus (Bygning i Aarhus C)']


    Scenario: Test that upper and lower case gives the same result
        Then param q = 'Ø'
        And param limit = '10'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[0].visningstekst == 'Ø (Højdedrag i Tjele)'


        Then param q = 'ø'
        And param limit = '10'

        When method GET
        Then status 200
        And def secondResponse = response
        And match secondResponse == '#[10]'
        And match response.[0].visningstekst == 'Ø (Højdedrag i Tjele)'
        And match response == secondResponse


    Scenario: Find a stednavn that only has an uofficielt skrivemaade
        Then param q = 'Chokola'

        And param limit = '10'
        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].skrivemaade_uofficiel contains ['Chokoladekrydset']


    Scenario: Search find the same adresse regards if there is - og multiple whitespaces
        Then param q = 'Wakeup Copenhagen Bernstorffsgade'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[0].visningstekst == 'Wakeup Copenhagen - Bernstorffsgade (Hotel i København V)'


        Then param q = 'Wakeup Copenhagen - Bernstorffsgade'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'
        And match response.[0].visningstekst == 'Wakeup Copenhagen - Bernstorffsgade (Hotel i København V)'
        Then match response == secondresponse


        Then param q = 'Wakeup Copenhagen  Bernstorffsgade'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'
        And match response.[0].visningstekst == 'Wakeup Copenhagen - Bernstorffsgade (Hotel i København V)'
        Then match thirdresponse == secondresponse


    Scenario: Filter sogn in like
        Then param q = 'kokholm'

        And param filter = "kommunekode like '%0787%'"
        When method GET
        Then status 200
        And match response == '#[2]'


    Scenario: Levenshtein ordering test
        Then param q = 'lind'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[0].visningstekst == 'Lind (Bydel i Herning)'
        And match response.[0].skrivemaade_officiel contains 'Lind'


    Scenario: Search for B&W-hallerne
        Then param q = 'B&W'

        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[2]'
        And match response.[*].skrivemaade_officiel contains ['B&W-hallerne']


        Then param q = 'B&W - hall'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'
        And match response.[*].skrivemaade_officiel contains ['B&W-hallerne']


        Then param q = 'B&W-hallerne (Hal i København K)'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'
        And match response.[*].skrivemaade_officiel contains ['B&W-hallerne']
        Then match thirdresponse == secondresponse


    Scenario: Search for the same place with its officelle navn: Monjasa Park and its one uofficelle navn: Fredericia Stadion
        # Relates to issue #133

        Then param q = 'Monjasa Park'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[0].visningstekst == 'Monjasa Park (Stadion i Fredericia)'
        And match response.[0].skrivemaade_officiel == 'Monjasa Park'
        And match response.[0].skrivemaade_uofficiel == 'Fredericia Stadion'
        And match response.[1].visningstekst == 'Fredericia Stadion (Monjasa Park, Stadion i Fredericia)'
        And match response.[1].skrivemaade_officiel == 'Monjasa Park'
        And match response.[1].skrivemaade_uofficiel == 'Fredericia Stadion'


        Then param q = 'Fredericia Stadion'

        When method GET
        Then status 200
        # There is a place "KFUM-Parken Fredericia (Stadion i Fredericia)" that also matches on the name BUT it is not the same place!
        And match response == '#[2]'
        And match response.[*].visningstekst contains deep 'Fredericia Stadion (Monjasa Park, Stadion i Fredericia)'
        And match response.[*].skrivemaade_officiel contains deep 'Monjasa Park'
        And match response.[*].skrivemaade_uofficiel contains deep 'Fredericia Stadion'


    Scenario: Search for the same place with its officelle navn: Gørlevsborg and it two uofficelle navn: Gjørrildsborg and Jarleborg
        # Relates to issue #133

        Then param q = 'Gørlevsborg'

        When method GET
        Then status 200
        And match response == '#[3]'
        And match response.[0].visningstekst contains only deep 'Gørlevsborg (Vold i Ringsted)'
        And match response.[0].skrivemaade_officiel contains only deep 'Gørlevsborg'
        And match response.[0].skrivemaade_uofficiel contains only deep 'Gjørrildsborg,Jarleborg'
        And match response.[*].visningstekst contains only deep ['Gørlevsborg (Vold i Ringsted)','Gjørrildsborg (Gørlevsborg, Vold i Ringsted)','Jarleborg (Gørlevsborg, Vold i Ringsted)']
        And match response.[*].skrivemaade_officiel contains only deep ['Gørlevsborg','Gørlevsborg','Gørlevsborg']
        And match response.[*].skrivemaade_uofficiel contains only deep ['Gjørrildsborg,Jarleborg','Gjørrildsborg,Jarleborg','Gjørrildsborg,Jarleborg']


        Then param q = 'Gjørrildsborg'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[0].visningstekst contains only deep 'Gjørrildsborg (Gørlevsborg, Vold i Ringsted)'
        And match response.[0].skrivemaade_officiel contains only deep 'Gørlevsborg'
        And match response.[0].skrivemaade_uofficiel contains only deep 'Gjørrildsborg,Jarleborg'

        Then param q = 'Jarleborg'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[0].visningstekst contains only deep 'Jarleborg (Gørlevsborg, Vold i Ringsted)'
        And match response.[0].skrivemaade_officiel contains only deep 'Gørlevsborg'
        And match response.[0].skrivemaade_uofficiel contains only deep 'Gjørrildsborg,Jarleborg'


    Scenario: Search for the same place that only have uofficelle navne: BT-huset and Bien and Suppeterrinen
        # Relates to issue #133

        Then param q = 'BT-huset'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[0].visningstekst contains only deep 'BT-huset (Bygning i København Ø)'
        And match response.[0].skrivemaade_officiel == '#null'
        And match response.[0].skrivemaade_uofficiel contains only deep 'BT-huset,Bien,Suppeterrinen'


        Then param q = 'Bien'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[0].visningstekst contains only deep 'Bien (Bygning i København Ø)'
        And match response.[0].skrivemaade_officiel == '#null'
        And match response.[0].skrivemaade_uofficiel contains only deep 'BT-huset,Bien,Suppeterrinen'


        Then param q = 'Suppeterrinen'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[0].visningstekst contains only deep 'Suppeterrinen (Bygning i København Ø)'
        And match response.[0].skrivemaade_officiel == '#null'
        And match response.[0].skrivemaade_uofficiel contains only deep 'BT-huset,Bien,Suppeterrinen'


    Scenario: Search levenshtein ordering test rørvig
        Then param q = 'rørvig'
        And param limit = '3'

        When method GET
        Then status 200
        And match response == '#[3]'
        And match response.[*].visningstekst contains only ['Rørvig (By i Odsherred Kommune)', 'Rørvig (Gård i Tønder)', 'Rørviggård (Gård i Otterup)']


    Scenario: Search levenshtein ordering test Kongen
        Then param q = 'Kongen'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[0].visningstekst == "Kongen (Christian X's Kollegium, Bygning i Viby J)"


    Scenario: Search levenshtein ordering test Absalon
        Then param q = 'Absalon'
        And param limit = '3'

        When method GET
        Then status 200
        And match response == '#[3]'
        And match response.[*].visningstekst contains only ['Absalon (Seværdighed i København K)', 'Absalon (Bygning i København V)', 'Absalon (HUSC, Professionshøjskole i Holbæk)']


    Scenario: Search levenshtein ordering test Sankt Klemens Kirke
        Then param q = 'Sankt Klemens Kirke'
        And param limit = '1'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[0].visningstekst == 'Sankt Klemens Kirke (Klemenskirke, Kirke i Klemensker)'


    Scenario: Search levenshtein ordering test Møn
        Then param q = 'møn'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[0].visningstekst == 'Møn (Ø i Stege)'


    Scenario: Search levenshtein ordering test Aars
        Then param q = 'Aars'
        And param limit = '2'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].visningstekst contains only ['Aars (Rasteplads i Aars)', 'Aars (By i Vesthimmerlands Kommune)']


    Scenario: Search levenshtein ordering test Akademiet
        Then param q = 'Akademiet'
        And param limit = '2'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].visningstekst contains only ['Akademiet (Uddannelsescenter i København N)', 'Akademiet (Københavns Skole & Idrætsakademi, Friskole i Hellerup)']


    Scenario: Search Christiansø Kirke
        Then param q = 'Christiansø Kirke'
        And param limit = '1'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].visningstekst contains only ['Christiansø Kirke (Kirke på Christiansø)']


    Scenario: Search Christiansø
        Then param q = 'Christiansø (Ø i Østersøen)'
        And param limit = '1'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].visningstekst contains only ['Christiansø (Ø i Østersøen)']


    Scenario: Search Slotsholmen
        Then param q = 'Slotsholmen'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].visningstekst contains ['Slotsholmen (Ø i København K)']


    Scenario: Test 2196 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 2196
  
        When method GET
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/2196>'
        And match response == '#[1]'


    Scenario: Test 2197 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 2197
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/2197>'
        And match response == '#[1]'


    Scenario: Test 2198 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 2198
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/2198>'
        And match response == '#[1]'


    Scenario: Test 3857 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 3857
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/3857>'
        And match response == '#[1]'


    Scenario: Test 4093 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 4093
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/4093>'
        And match response == '#[1]'


    Scenario: Test 4094 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 4094
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/4094>'
        And match response == '#[1]'


    Scenario: Test 4095 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 4095
        
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/4095>'
        And match response == '#[1]'


    Scenario: Test 4096 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 4096
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/4096>'
        And match response == '#[1]'


    Scenario: Test 4326 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 4326
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/4326>'
        And match response == '#[1]'


    Scenario: Test 25832 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 25832 
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/25832>'
        And match response == '#[1]'


    Scenario: Test 25833 crs response
        Then param q = 's'
        And param limit = '1'
        And param srid = 25833 
  
        When method get
        Then status 200
        And match header Content-Crs == '<https://www.opengis.net/def/crs/EPSG/0/25833>'
        And match response == '#[1]'
