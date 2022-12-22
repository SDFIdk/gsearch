Feature: Gsearch retskreds test

    Background:
        * url url + '/search'

    Scenario: Response matches columns database
        Then param q = 'aalborg'
        And param resources = 'retskreds'
        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains deep
        """
            {
                "type": 'retskreds',
                "visningstekst": '#string',
                "bbox": '#(bboxSchema)',
                "retkredsnavn": '#string',
                "geometri": '#(geometriSchema)',
                "retskredsnummer": '#string',
                "myndighedskode": '#string',
                "rang1": '#string',
                "rang2": '#string'
            }
        """

    Scenario: Partial string
        Then param q = 'retten i aa'
        And param resources = 'retskreds'
        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].retkredsnavn contains deep ['Retten i Aalborg', 'Retten i Århus']

    Scenario: Search is case insensitive
        Then param q = 'Glostrup'
        And param resources = 'retskreds'
        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'glostrup'
        And param resources = 'retskreds'
        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'GLOSTRUP'
        And param resources = 'retskreds'
        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'

        Then match thirdresponse == secondresponse

    Scenario: Do not have a match on '.'
        Then param q = '.'
        And param resources = 'retskreds'
        When method GET
        Then status 200
        And match response == '#[0]'

    Scenario: Test maximum limit and one character search
        Then param q = 'r'
        And param resources = 'retskreds'
        And param limit = '100'
        When method GET
        Then status 200
        And match response == '#[23]'