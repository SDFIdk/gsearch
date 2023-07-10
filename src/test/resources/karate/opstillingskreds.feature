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
      "valgkredsnummer": '#string',
      "kommunekode": '#string',
      "geometri": '#(geometriSchema)',
      "opstillingskredsnummer": '#string',
      "storkredsnummer": '#string',
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
