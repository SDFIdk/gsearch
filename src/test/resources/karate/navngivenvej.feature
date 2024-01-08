Feature: Gsearch navngivenvej test

    Background:
        * url url + '/navngivenvej'

    Scenario: Response matches columns database
        Then param q = 'Kocksvej'
        Then param limit = '1'

        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiLineString', coordinates: '#array'}
        And match response contains only
        """
        {
            "postnummer": '#string',
            "visningstekst": '#string',
            "vejnavn": '#string',
            "supplerendebynavn": '#string',
            "postnummernavn": '#string',
            "bbox": '#(bboxSchema)',
            "geometri": '#(geometriSchema)',
            "id": '#string',
            "kommunekode": "#string",
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
        And match response == '#[9]'

        Then param q = 'kocksvej'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[9]'

        Then match response == secondresponse

        Then param q = 'KOCKSVEJ'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[9]'

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

    Scenario: Response with multipolygon
        Then param q = 'Christiansø'

        When method GET
        Then status 200
        And match response == '#[8]'

    Scenario: Search steetname that has numbers in it
        Then param q = 'Haveforeningen af 10. maj 1918'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].vejnavn contains deep ['Haveforeningen af 10. maj 1918']

    Scenario: Search steetname that has numbers in it
        Then param q = '2.Tværvej'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].vejnavn contains deep ['2.Tværvej']

    Scenario: Filter kommunekode in like
        Then param q = 'røde'

        And param filter = "kommunekode like '%0787%'"
        When method GET
        Then status 200
        And match response == '#[2]'

    Scenario: Search with supplerende bynavn returns the same as without supplerende bynavn
        Then param q = 'Haderslevvej 6100'

        When method GET
        And retry until responseStatus == 200
        And match response == '#[13]'
        And match response.[0].visningstekst == "Haderslevvej (6100 Haderslev, 6500 Vojens)"