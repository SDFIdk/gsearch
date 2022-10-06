Feature: Gsearch opstillingskreds test

  Background:
    * url url + '/search'

  Scenario: Response matches columns database
    Then param q = 'valby'
    And param resources = 'opstillingskreds'
    When method GET
    Then status 200
    And match response == '#[1]'
    And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
    And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
    And match response contains deep
    """
    {
      "type": 'opstillingskreds',
      "opstillingskredsnavn": '#string',
      "praesentation": '#string',
      "bbox": '#(bboxSchema)',
      "valgkredsnummer": '#string',
      "geometri": '#(geometriSchema)',
      "id": '#string',
      "storkredsnummer": '#string',
      "storkredsnavn":,'#string',
      "rang1": '#string',
      "rang2": '#string'
    }
    """

  Scenario: Partial string
    Then param q = 'va'
    And param resources = 'opstillingskreds'
    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].opstillingskreds contains deep ['Valby', 'Varde']

  Scenario: Search is case insensitive
    Then param q = 'Valby'
    And param resources = 'opstillingskreds'
    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[1]'

    Then param q = 'valby'
    And param resources = 'opstillingskreds'
    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[1]'

    Then match firstresponse == secondresponse

    Then param q = 'VALBY'
    And param resources = 'opstillingskreds'
    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[1]'

    Then match thirdresponse == secondresponse

  Scenario: Do not have a match on '.'
    Then param q = '.'
    And param resources = 'opstillingskreds'
    When method GET
    Then status 200
    And match response == '#[0]'
