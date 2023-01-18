Feature: Gsearch husnummer test

  Background:
    * url url + '/husnummer'

  Scenario: Response matches columns database
    Then param q = 'Kocksvej'

    When method GET
    Then status 200
    And match response == '#[10]'
    And def geometriSchema = {type: 'MultiPoint', coordinates: '#array'}
    And match response contains deep
    """
    {
      "vejkode": '#string',
      "visningstekst": '#string',
      "geometri": '#(geometriSchema)',
      "husnummertekst": '#string',
      "vejnavn": '#string',
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
