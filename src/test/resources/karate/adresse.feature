Feature: Gsearch adresse test

    Background:
    * url url + '/search'

    Scenario: Response matches columns database
        Then param q = 'kocksvej'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And match response == '#[10]'
        And def geometriSchema = {type: 'MultiPoint', coordinates: '#array'}
        And match response contains deep
        """
        {
          "type": 'adresse',
          "vejkode": '#string',
          "etagebetegnelse": '#string',
          "adgangspunkt_geometri": '#(geometriSchema)',
          "husnummer": '#string',
          "vejnavn": '#string',
          "kommunekode": '#string',
          "visningstekst": '#string',
          "kommunenavn": '#string',
          "doerbetegnelse": '#string',
          "postnummer": '#string',
          "vejpunkt_geometri": '#(geometriSchema)',
          "id": '#string',
          "postdistrikt": '#string',
          "rang1": '#string',
          "rang2": '#string'
        }
        """

    Scenario: Partial string
        Then param q = 'kocks'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And match response == '#[10]'

    Scenario: Search is case insensitive
        Then param q = 'Kocksvej'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[10]'

        Then param q = 'kocksvej'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[10]'

        Then match firstresponse == secondresponse

        Then param q = 'KOCKSVEJ'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[10]'

        Then match thirdresponse == secondresponse

    Scenario: Like search on hc andersen returns H.C. Andersen and H.C. Andersens
        Then param q = 'hc andersen'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].vejnavn contains deep ['H.C. Andersen Haven', 'H.C. Andersens Boulevard']
        And match response.[*].postdistrikt contains deep ['Odense C', 'København V']

    Scenario: Search steetname with number
        Then param q = 'kocksvej 1'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].husnummer contains deep ['1']

    Scenario: Search steetname with number and letter
        Then param q = 'kocksvej 1C'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].husnummer contains deep ['1C']

    Scenario: Do not have a match on '.'
        Then param q = '.'
        And param resources = 'adresse'
        When method GET
        Then status 200
        And match response == '#[0]'

    Scenario: Test maximum limit and one character search
        Then param q = 's'
        And param resources = 'adresse'
        And param limit = '100'
        When method GET
        Then status 200
        And match response == '#[100]'

    Scenario: Test that upper and lower case gives the same result
        Then param q = 'Ø'
        And param resources = 'adresse'
        And param limit = '10'
        When method GET
        Then status 200
        And match firstResponse == '#[10]'

        Then param q = 'ø'
        And param resources = 'adresse'
        And param limit = '10'
        When method GET
        Then status 200
        And match secondResponse == '#[10]'

        And match firstResponse == secondResponse



