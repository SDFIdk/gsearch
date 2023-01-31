Feature: Gsearch matrikel test

  Background:
    * url url + '/matrikel'

  Scenario: Response matches columns database
    Then param q = '2000154'

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

    When method GET
    Then status 200
    And match response == '#[8]'

  Scenario: Search is case insensitive
    Then param q = 'Damhussøen'

    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[8]'

    Then param q = 'damhussøen'

    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[8]'

    Then match firstresponse == secondresponse

    Then param q = 'DAMHUSSØEN'

    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[8]'

    Then match thirdresponse == secondresponse

  Scenario: Combine search using ejerlavsnavn og matrikelnummer
    Then param q = '2000154 7000a'

    When method GET
    Then status 200
    And match response == '#[1]'
    And match response.[*].matrikelnummer contains deep ['7000a']
    And match response.[*].ejerlavsnavn contains deep ['Damhussøen, København']

  Scenario: Combine search using ejerlavskode and ejerlavsnavn
    Then param q = 'utterslev'

    When method GET
    Then status 200
    And match response == '#[10]'
    And match response.[*].ejerlavsnavn contains deep ['Utterslev By, Utterslev']

  Scenario: Do not have a match on '.'
    Then param q = '.'

    When method GET
    Then status 200
    And match response == '#[0]'

  Scenario: Search is interchangeable order of ejerlavsnavn and matrikelnummer
    Then param q = 'staurby 4a 401954'

    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[5]'

    Then param q = '4a 401954 staurby'

    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[8]'

    Then match firstresponse == secondresponse

    Then param q = '401954 4a staurby'

    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[5]'

    Then match thirdresponse == secondresponse

#  Scenario: Test maximum limit and one character search
#    Then param q = 's'
#
#    And param limit = '100'
#    When method GET
#    Then status 200
#    And match response == '#[100]'
