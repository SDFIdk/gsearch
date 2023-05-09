Feature: Gsearch kommune test

    Background:
        * url url + '/kommune'

    Scenario: Response matches columns database
        Then param q = 'Albertslund'

        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains deep
        """
        {
            "kommunenavn": '#string',
            "visningstekst": '#string',
            "bbox": '#(bboxSchema)',
            "geometri": '#(geometriSchema)',
            "kommunekode": '#string'
        }
        """

    Scenario: Partial string
        Then param q = 'køben'

        When method GET
        Then status 200
        And match response == '#[1]'

    Scenario: Search is case insensitive
        Then param q = 'København'

        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'københavn'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'KØBENHAVN'

        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'

        Then match thirdresponse == secondresponse

    Scenario: Like search on nord returns Norddjurs and Nordfyns
        Then param q = 'nord'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].kommunenavn contains deep ['Norddjurs', 'Nordfyns']
        And match response.[*].visningstekst contains deep ['Norddjurs Kommune', 'Nordfyns Kommune']

    Scenario: Get København from using the kommunekode as search input
        Then param q = '0101'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].kommunenavn contains deep ['København']
        And match response.[*].kommunekode contains deep ['0101']

    Scenario: Search kommunekode without the prefix zero
        Then param q = '259'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].kommunenavn contains deep ['Køge']
        And match response.[*].kommunekode contains deep ['0259']

    Scenario: Combined search, Get København from using the kommunekode as search input and Herlev as tekst input
        Then param q = '0101 herlev'

        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].kommunenavn contains deep ['Herlev', 'København']

    Scenario: Do not have a match on '.'
        Then param q = '.'

        When method GET
        Then status 200
        And match response == '#[0]'

    Scenario: Test maximum limit and one character search
        Then param q = 'h'

        And param limit = '100'
        When method GET
        Then status 200
        And match response == '#[14]'

    Scenario: Test Christiansø do not have kommune added after the name
        Then param q = 'Christiansø'

        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].visningstekst == ['Christiansø']

    Scenario: Filter kommunekode in like
        Then param q = 'glostrup'

        And param filter = "kommunekode like '%0161%'"
        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].kommunenavn == ['Glostrup']

    Scenario: Search with exactly the input value (here no matches)
        Then param q = '12a'

        When method GET
        Then status 200
        And match response == '#[0]'