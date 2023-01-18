Feature: Gsearch postnummer test

  Background:
    * url url + '/postnummer'

  Scenario: Response matches columns database
    Then param q = '2605'

    When method GET
    Then status 200
    And match response == '#[1]'
    And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
    And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
    And match response contains deep
    """
    {
      "visningstekst": '#string',
      "bbox": '#(bboxSchema)',
      "geometri": '#(geometriSchema)',
      "postnummer": '#string',
      "postnummernavn": '#string',
      "gadepostnummer": '#string'
    }
    """

  Scenario: Partial string
    Then param q = 'køben'

    When method GET
    Then status 200
    And match response == '#[10]'

  Scenario: Search is case insensitive
    Then param q = 'København'

    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[10]'

    Then param q = 'københavn'

    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[10]'

    Then match firstresponse == secondresponse

    Then param q = 'KØBENHAVN'

    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[10]'

    Then match thirdresponse == secondresponse

  Scenario: Like search on københavn s returns København S and København SV
    Then param q = 'københavn S'

    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*]postnummernavn contains deep ['København S', 'København SV']
    And match response.[*].visningstekst contains deep ['2300 København S', '2450 København SV']

  Scenario: Get Birkerød and Hillerød from using the postnumber as search input
    Then param q = '3460 3400'

    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*]postnummernavn contains deep ['Birkerød', 'Hillerød']
    And match response.[*].postnummer contains deep ['3460', '3400']

  Scenario: Get København S from using the postnumber as search input and Søborg as tekst input
    Then param q = '2300 søborg'

    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*]postnummernavn contains deep ['Søborg', 'København S']

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
