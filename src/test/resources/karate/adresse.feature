Feature: Gsearch adresse test

    Background:
    * url url + '/adresse'

    Scenario: Response matches columns database
        Then param q = 'kocksvej'

        When method GET
        Then status 200
        And match response == '#[10]'
        And def geometriSchema = {type: 'MultiPoint', coordinates: '#array'}
        And match response contains deep
        """
        {
            "vejkode": '#string',
            "etagebetegnelse": '#string',
            "geometri": '#(geometriSchema)',
            "husnummer": '#string',
            "vejnavn": '#string',
            "kommunekode": '#string',
            "visningstekst": '#string',
            "kommunenavn": '#string',
            "doerbetegnelse": '#string',
            "postnummer": '#string',
            "vejpunkt_geometri": '#(geometriSchema)',
            "id": '#string',
            "postnummernavn": '#string'
        }
        """

    Scenario: Partial string
        Then param q = 'kocks'

        When method GET
        Then status 200
        And match response == '#[10]'

    Scenario: Search is case insensitive
        Then param q = 'Kocksvej'

        When method GET
        Then status 200
        And match response == '#[10]'

        Then param q = 'kocksvej'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[10]'

        Then match response == secondresponse

        Then param q = 'KOCKSVEJ'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[10]'

        Then match thirdresponse == secondresponse

    Scenario: Like search on hc andersen returns H.C. Andersen and H.C. Andersens
        Then param q = 'hc andersen'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].vejnavn contains deep ['H.C. Andersen Haven', 'H.C. Andersens Boulevard']
        And match response.[*].postnummernavn contains deep ['Odense C', 'København V']

    Scenario: Search steetname with number
        Then param q = 'kocksvej 1'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].husnummer contains deep ['1']

    Scenario: Search steetname with number and letter
        Then param q = 'kocksvej 1C'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].husnummer contains deep ['1C']

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

    Scenario: Search with speciel characters returns the same as without
        Then param q = 'Rentemest 110 2 th'

        When method GET
        And retry until responseStatus == 200
        And match response == '#[6]'
        And match response.[0].visningstekst == "Rentemestervej 110, 2. th, 2400 København NV"

        Then param q = 'Rentemest 110, 2. th,'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[6]'

        Then match response == secondresponse
        And match response.[0].visningstekst == "Rentemestervej 110, 2. th, 2400 København NV"

    Scenario: Filter kommunekode in like
        Then param q = 'kocksvej'

        And param filter = "kommunekode like '%0540%'"
        When method GET
        Then status 200
        And match response == '#[10]'
