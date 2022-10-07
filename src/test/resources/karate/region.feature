Feature: Gsearch region test

    Background:
        * url url + '/search'

    Scenario: Response matches columns database
        Then param q = 'hovedstaden'
        And param resources = 'region'
        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains deep
        """
            {
                "type": 'region',
                "praesentation": 'Er lig med regionsnavn, fjern?',
                "bbox": '#(bboxSchema)',
                "geometri": '#(geometriSchema)',
                "regionskode": '#string',
                "regionsnavn": '#string',
                "rang1": '#string',
                "rang2": '#string'
            }
        """

    Scenario: Partial string
        Then param q = 'region'
        And param resources = 'region'
        When method GET
        Then status 200
        And match response == '#[5]'
        And match response.[*].regionsnavn contains deep ['Region Hovedstaden', 'Region Midtjylland', 'Region Nordjylland', 'Region Sjælland', 'Region Syddanmark']

    Scenario: Search is case insensitive
        Then param q = 'Hovedstaden'
        And param resources = 'region'
        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'hovedstaden'
        And param resources = 'region'
        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'HOVEDSTADEN'
        And param resources = 'region'
        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'

        Then match thirdresponse == secondresponse

    Scenario: Do not have a match on '.'
        Then param q = '.'
        And param resources = 'region'
        When method GET
        Then status 200
        And match response == '#[0]'