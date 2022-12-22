Feature: Gsearch sogn test

    Background:
    * url url + '/search'

    Scenario: sogn
        Then param q = 'lund'
        And param resources = 'sogn'
        When method GET
        Then status 200
        And match response == '#[10]'


    Scenario: Response matches columns database
        Then param q = 'Birkerød'
        And param resources = 'sogn'
        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains deep
        """
            {
                "type": 'sogn',
                "sognenavn": '#string',
                "visningstekst": '#string',
                "bbox": '#(bboxSchema)',
                "geometri": '#(geometriSchema)',
                "sognekode": '#string',
                "rang1": '#string',
                "rang2": '#string'
            }
        """

    Scenario: Partial string
        Then param q = 'All'
        And param resources = 'sogn'
        When method GET
        Then status 200
        And match response == '#[10]'
        And match response.[*].sognenavn contains deep ['Allinge-Sandvig', 'Allehelgens', 'Aller', 'Allerslev', 'Allerslev', 'Allerup', 'Allested', 'Allesø', 'Alling', 'Bregninge-Bjergsted-Alleshave']

    Scenario: Search is case insensitive
        Then param q = 'Birkerød'
        And param resources = 'sogn'
        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'birkerød'
        And param resources = 'sogn'
        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'BIRKERØD'
        And param resources = 'sogn'
        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'

        Then match thirdresponse == secondresponse

    Scenario: Do not have a match on '.'
        Then param q = '.'
        And param resources = 'sogn'
        When method GET
        Then status 200
        And match response == '#[0]'

    Scenario: Test maximum limit and one character search
        Then param q = 's'
        And param resources = 'sogn'
        And param limit = '100'
        When method GET
        Then status 200
        And match response == '#[100]'