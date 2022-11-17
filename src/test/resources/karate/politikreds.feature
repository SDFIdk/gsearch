Feature: Gsearch politikreds test

    Background:
        * url url + '/search'

    Scenario: politikreds
        Then param q = 'Nordjylland'
        And param resources = 'politikreds'
        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains deep
        """
        {
        "type": 'politikreds',
        "praesentation": '#string',
        "bbox": '#(bboxSchema)',
        "politikredsnummer": '#string',
        "geometri": '#(geometriSchema)',
        "politikredsnummer": '#string',
        "myndighedskode": '#string',
        "rang1": '#string',
        "rang2": '#string'
        }
        """

    Scenario: Partial string
        Then param q = 'nord'
        And param resources = 'politikreds'
        When method GET
        Then status 200
        And match response == '#[2]'
        And match response.[*].praesentation contains deep ['Nordjyllands Politikreds', 'Nordsjællands Politikreds']

    Scenario: Search is case insensitive
        Then param q = 'Nordjylland'
        And param resources = 'politikreds'
        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'nordjylland'
        And param resources = 'politikreds'
        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'NORDJYLLAND'
        And param resources = 'politikreds'
        When method GET
        Then status 200
        And def thirdresponse = response
        And match thirdresponse == '#[1]'

        Then match thirdresponse == secondresponse

    Scenario: Do not have a match on '.'
        Then param q = '.'
        And param resources = 'politikreds'
        When method GET
        Then status 200
        And match response == '#[0]'
