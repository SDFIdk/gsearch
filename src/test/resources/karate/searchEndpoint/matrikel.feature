Feature: Gsearch matrikel test

  Background:
    * url url + '/search'

  Scenario: Response matches columns database
    Then param q = '2000154'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And match response == '#[8]'
    And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
    And match response contains deep
    """
    {
      "ejerlavskode": '#string',
      "ejerlavsnavn": '#string',
      "visningstekst": '#string',
      "geometri": '#(geometriSchema)',
      "centroid_x": '#string',
      "centroid_y": '#string',
      "matrikelnummer": '#string'
    }
    """

  Scenario: Partial string
    Then param q = 'damhus'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And match response == '#[8]'

  Scenario: Search is case insensitive
    Then param q = 'Damhussøen'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[8]'

    Then param q = 'damhussøen'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[8]'

    Then match firstresponse == secondresponse

    Then param q = 'DAMHUSSØEN'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[8]'

    Then match thirdresponse == secondresponse

  Scenario: Combine search using ejerlavsnavn og matrikelnummer
    Then param q = '2000154 7000a'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And match response == '#[1]'
    And match response.[*].matrikelnummer contains deep ['7000a']
    And match response.[*].ejerlavsnavn contains deep ['Damhussøen, København']

  Scenario: Combine search using ejerlavskode and ejerlavsnavn
    Then param q = '2000154 utterslev'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And match response == '#[10]'
    And match response.[*].ejerlavsnavn contains deep ['Damhussøen, København', 'Utterslev By, Utterslev']

  Scenario: Do not have a match on '.'
    Then param q = '.'
    And param resources = 'matrikel'
    When method GET
    Then status 200
    And match response == '#[0]'

#  Scenario: Test maximum limit and one character search
#    Then param q = 's'
#    And param resources = 'matrikel'
#    And param limit = '100'
#    When method GET
#    Then status 200
#    And match response == '#[100]'
