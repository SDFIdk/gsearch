Feature: Gsearch husnummer test

    Background:
        * url url + '/husnummer'

    Scenario: Response matches columns database
        Then param q = 'Kocksvej'
        Then param limit = '1'

        When method GET
        Then status 200
        And match response == '#[1]'
        And def geometriSchema = {type: 'MultiPoint', coordinates: '#array'}
        And match response contains only
        """
        {
            "vejkode": '#string',
            "visningstekst": '#string',
            "geometri": '#(geometriSchema)',
            "husnummertekst": '#string',
            "vejnavn": '#string',
            "supplerendebynavn": '#string',
            "kommunekode": '#string',
            "kommunenavn": '#string',
            "postnummer": '#string',
            "vejpunkt_geometri": '#(geometriSchema)',
            "id": '#string',
            "postnummernavn": '#string'
        }
        """

    Scenario: Partial string
        Then param q = 'kock'

        When method GET
        Then status 200
        And match response == '#[10]'

    Scenario: Search is case insensitive
        Then param q = 'Kocksvej'

        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[10]'

        Then param q = 'kocksvej'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[10]'

        Then match firstresponse == secondresponse

        Then param q = 'KOCKSVEJ'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[10]'

        Then match thirdresponse == secondresponse

    Scenario: Search streetname with number
        Then param q = 'kocksvej 1'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].husnummertekst contains deep ['1']

    Scenario: Search streetname with number and letter
        Then param q = 'kocksvej 1C'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].husnummertekst contains deep ['1C']

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

    Scenario: Test that upper and lower case gives the same result
        Then param q = 'Ø'

        And param limit = '10'
        When method GET
        Then status 200
        And match response == '#[10]'

        Then param q = 'ø'

        And param limit = '10'
        When method GET
        Then status 200
        And def secondResponse = response
        And match secondResponse == '#[10]'

        And match response == secondResponse

    Scenario: Search steetname that has numbers in it
        Then param q = 'Haveforeningen af 10. maj 1918'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].vejnavn contains deep ['Haveforeningen af 10. maj 1918']

    Scenario: Search steetname that has numbers in it
        Then param q = '2.Tværvej'

        When method GET
        Then status 200
        And match response == '#[8]'
        And match response.[*].vejnavn contains deep ['2.Tværvej']

    Scenario: Filter kommunekode in like
        Then param q = 'kocksvej'

        And param filter = "kommunekode like '%0540%'"
        When method GET
        Then status 200
        And match response == '#[10]'

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
        And match response == '#[100]'
  
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
