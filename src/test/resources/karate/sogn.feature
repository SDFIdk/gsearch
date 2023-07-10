Feature: Gsearch sogn test

    Background:
    * url url + '/sogn'

    Scenario: sogn
        Then param q = 'lund'

        When method GET
        Then status 200
        And match response == '#[10]'


    Scenario: Response matches columns database
        Then param q = 'Birkerød'

        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains only
        """
            {
                "sognenavn": '#string',
                "kommunekode": '#string',
                "visningstekst": '#string',
                "bbox": '#(bboxSchema)',
                "geometri": '#(geometriSchema)',
                "sognekode": '#string'
            }
        """

    Scenario: Partial string
        Then param q = 'All'

        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].sognenavn contains deep ['Allinge-Sandvig', 'Allehelgens', 'Aller', 'Allerslev', 'Allerslev', 'Allerup', 'Allested', 'Allesø', 'Alling', 'Bregninge-Bjergsted-Alleshave']

    Scenario: Search is case insensitive
        Then param q = 'Birkerød'

        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'birkerød'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'BIRKERØD'

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
        And match response == '#[100]'

    Scenario: Filter kommunekode in like
        Then param q = 'sel'

        And param filter = "kommunekode like '%0779%'"
        When method GET
        Then status 200
        And match response == '#[1]'
