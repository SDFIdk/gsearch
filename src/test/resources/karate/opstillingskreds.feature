Feature: Gsearch opstillingskreds test

  Background:
    * url url + '/opstillingskreds'

  Scenario: Response matches columns database
    Then param q = 'valby'

    When method GET
    Then status 200
    And match response == '#[1]'
    And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
    And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
    And match response contains only
    """
    {
      "opstillingskredsnavn": '#string',
      "visningstekst": '#string',
      "bbox": '#(bboxSchema)',
      "valgkredsnummer": '#number',
      "kommunekode": '#string',
      "geometri": '#(geometriSchema)',
      "opstillingskredsnummer": '#number',
      "storkredsnummer": '#number',
      "storkredsnavn": '#string'
    }
    """

  Scenario: Partial string
    Then param q = 'va'

    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].opstillingskredsnavn contains deep ['Valby', 'Varde']

  Scenario: Search is case insensitive
    Then param q = 'Valby'

    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[1]'

    Then param q = 'valby'

    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[1]'

    Then match firstresponse == secondresponse

    Then param q = 'VALBY'

    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[1]'

    Then match thirdresponse == secondresponse

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
    And match response == '#[17]'

  Scenario: Filter kommunekode in like
    Then param q = 'k'

    And param filter = "kommunekode like '%0621%'"
    When method GET
    Then status 200
    And match response == '#[2]'

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
