Feature: Gsearch stednavn test

    Background:
        * url url + '/search'

    Scenario: Response matches columns database
        Then param q = 'valbyparken'
        And param resources = 'stednavn'
        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains deep
        """
            {
                "type": 'stednavn',
                "skrivemaade_uofficiel": '#string',
                "skrivemaade_officiel": '#string',
                "praesentation": '#string',
                "bbox": '#(bboxSchema)',
                "skrivemaade": '#string',
                "stednavn_subtype": '#string',
                "stednavn_type": '#string',
                "geometri": '#(geometriSchema)',
                "id": '#string',
                "rang1": '#string',
                "rang2": '#string'
            }
        """

    Scenario: Partial string
        Then param q = 'valby g'
        And param resources = 'stednavn'
        When method GET
        Then status 200
        And match response == '#[4]'
        And match response.[*].skrivemaade_officiel contains deep ['Gadekærvej Storbyhave', 'Valby Gl. Skole', 'Station Gearhallen', 'Store Valbygård']

    Scenario: Search is case insensitive
        Then param q = 'Valbyparken'
        And param resources = 'stednavn'
        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'valbyparken'
        And param resources = 'stednavn'
        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'VALBYPARKEN'
        And param resources = 'stednavn'
        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'

        Then match thirdresponse == secondresponse

    Scenario: Combined search
        Then param q = 'valby naturareal'
        And param resources = 'stednavn'
        When method GET
        Then status 200
        And match response == '#[1]'
        And match response.[*].skrivemaade_officiel contains deep ['Valbyparken']

    Scenario: Do not have a match on '.'
        Then param q = '.'
        And param resources = 'stednavn'
        When method GET
        Then status 200
        And match response == '#[0]'

    Scenario: Test maximum limit and one character search
        Then param q = 's'
        And param resources = 'stednavn'
        And param limit = '100'
        When method GET
        Then status 200
        And match response == '#[100]'


    Scenario: Test that upper and lower case gives the same result
        Then param q = 'Ø'
        And param resources = 'stednavn'
        And param limit = '10'
        When method GET
        Then status 200
        And match firstResponse == '#[10]'

        Then param q = 'ø'
        And param resources = 'stednavn'
        And param limit = '10'
        When method GET
        Then status 200
        And match secondResponse == '#[10]'

        And match firstResponse == secondResponse
