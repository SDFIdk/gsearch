Feature: Gsearch husnummer test

  Background:
    * url url + '/search'

  Scenario: Response matches columns database
    Then param q = 'Kocksvej'
    And param resources = 'husnummer'
    When method GET
    Then status 200
    And match response == '#[10]'
    And def geometriSchema = {type: 'MultiPoint', coordinates: '#array'}
    And match response contains deep
    """
    {
      "type": 'husnummer',
      "vejkode": '#string',
      "adgangsadressebetegnelse": '#string',
      "adgangspunkt_geometri": '#(geometriSchema)',
      "husnummer": '#string',
      "vejnavn": '#string',
      "kommunekode": '#string',
      "kommunenavn": '#string',
      "postnummer": '#string',
      "vejpunkt_geometri": '#(geometriSchema)',
      "id": '#string',
      "postdistrikt": '#string',
      "rang1": '#string',
      "rang2": '#string'
    }
    """

  Scenario: Partial string
    Then param q = 'kock'
    And param resources = 'husnummer'
    When method GET
    Then status 200
    And match response == '#[10]'

  Scenario: Search is case insensitive
    Then param q = 'Kocksvej'
    And param resources = 'husnummer'
    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[10]'

    Then param q = 'kocksvej'
    And param resources = 'husnummer'
    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[10]'

    Then match firstresponse == secondresponse

    Then param q = 'KOCKSVEJ'
    And param resources = 'husnummer'
    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[10]'

    Then match thirdresponse == secondresponse

Scenario: Search steetname with number
    Then param q = 'kocksvej 1'
    And param resources = 'adresse'
    When method GET
    Then status 200
    And match response == '#[10]'
    And match response.[*].husnummer contains deep ['(1,"")']

  Scenario: Do not have a match on '.'
    Then param q = '.'
    And param resources = 'husnummer'
    When method GET
    Then status 200
    And match response == '#[0]'

  Scenario: Test maximum limit and small search
    Then param q = 'k'
    And param resources = 'husnummer'
    And param limit = '100'
    When method GET
    Then status 200
    And match response == '#[100]'
