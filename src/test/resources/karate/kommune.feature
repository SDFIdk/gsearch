Feature: Gsearch kommune test

    Background:
        * url url + '/kommune'

    Scenario: Response matches columns database
        Then param q = 'Albertslund'

        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains only
        """
        {
            "kommunenavn": '#string',
            "visningstekst": '#string',
            "bbox": '#(bboxSchema)',
            "geometri": '#(geometriSchema)',
            "kommunekode": '#string'
        }
        """

    Scenario: Partial string
        Then param q = 'køben'

        When method GET
        Then status 200
        And match response == '#[1]'

    Scenario: Search is case insensitive
        Then param q = 'København'

        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'københavn'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'KØBENHAVN'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'

        Then match thirdresponse == secondresponse

    Scenario: Like search on nord returns Norddjurs and Nordfyns
        Then param q = 'nord'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].kommunenavn contains deep ['Norddjurs', 'Nordfyns']
        And match response.[*].visningstekst contains deep ['Norddjurs Kommune', 'Nordfyns Kommune']

    Scenario: Get København from using the kommunekode as search input
        Then param q = '0101'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].kommunenavn contains deep ['København']
        And match response.[*].kommunekode contains deep ['0101']

    Scenario: Search kommunekode without the prefix zero
        Then param q = '259'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].kommunenavn contains deep ['Køge']
        And match response.[*].kommunekode contains deep ['0259']

    Scenario: Do not have a match on '.'
        Then param q = '.'

        When method GET
        Then status 200
        And match response == '#[0]'

    Scenario: Test maximum limit and one character search
        Then param q = 'h'

        And param limit = '100'
        When method GET
        Then status 200
        And match response == '#[14]'

    Scenario: Test Christiansø do not have kommune added after the name
        Then param q = 'Christiansø'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].visningstekst == ['Christiansø']

    Scenario: Filter kommunekode in like
        Then param q = 'glostrup'

        And param filter = "kommunekode like '%0161%'"
        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].kommunenavn == ['Glostrup']

    Scenario: Search with exactly the input value (here no matches)
        Then param q = '12a'

        When method GET
        Then status 200
        And match response == '#[0]'

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
