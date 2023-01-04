Feature: Gsearch navngivenvej test

  Background:
    * url url + '/search'

  Scenario: Response matches columns database
    Then param q = 'Kocksvej'
    And param resources = 'navngivenvej'
    When method GET
    Then status 200
    And match response == '#[9]'
    And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
    And def geometriSchema = {type: 'MultiLineString', coordinates: '#array'}
    And match response contains deep
    """
    {
      "type": 'navngivenvej',
      "postnummer": '#string',
      "visningstekst": '#string',
      "vejnavn": '#string',
      "postnummernavn": '#string',
      "bbox": '#(bboxSchema)',
      "geometri": '#(geometriSchema)',
      "id": '#string',
      "rang1": '#string',
      "rang2": '#string'
    }
    """

  Scenario: Partial string
    Then param q = 'kock'
    And param resources = 'navngivenvej'
    When method GET
    Then status 200
    And match response == '#[10]'

  Scenario: Search is case insensitive
    Then param q = 'Kocksvej'
    And param resources = 'navngivenvej'
    When method GET
    Then status 200
    And match response == '#[9]'

    Then param q = 'kocksvej'
    And param resources = 'navngivenvej'
    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[9]'

    Then match response == secondresponse

    Then param q = 'KOCKSVEJ'
    And param resources = 'navngivenvej'
    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[9]'

    Then match thirdresponse == secondresponse

  Scenario: Do not have a match on '.'
    Then param q = '.'
    And param resources = 'navngivenvej'
    When method GET
    Then status 200
    And match response == '#[0]'

  Scenario: Test maximum limit and one character search
    Then param q = 's'
    And param resources = 'navngivenvej'
    And param limit = '100'
    When method GET
    Then status 200
    And match response == '#[100]'

  Scenario: Test that upper and lower case gives the same result
    Then param q = 'Ø'
    And param resources = 'navngivenvej'
    And param limit = '10'
    When method GET
    Then status 200
    And match response == '#[10]'

    Then param q = 'ø'
    And param resources = 'navngivenvej'
    And param limit = '10'
    When method GET
    Then status 200
    And def secondResponse = response
    And match secondResponse == '#[10]'

    And match response == secondResponse
