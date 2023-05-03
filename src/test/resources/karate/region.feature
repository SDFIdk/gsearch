Feature: Gsearch region test

    Background:
        * url url + '/region'

    Scenario: Response matches columns database
        Then param q = 'hovedstaden'

        When method GET
        Then status 200
        And match response == '#[1]'
        And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
        And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
        And match response contains deep
        """
            {
                "visningstekst": '#string',
                "bbox": '#(bboxSchema)',
                "geometri": '#(geometriSchema)',
                "regionskode": '#string',
                "regionsnavn": '#string'
            }
        """

    Scenario: Partial string
        Then param q = 'region'

        When method GET
        Then status 200
        And match response == '#[5]'
        And match response.[*].regionsnavn contains deep ['Region Hovedstaden', 'Region Midtjylland', 'Region Nordjylland', 'Region Sjælland', 'Region Syddanmark']

    Scenario: Search is case insensitive
        Then param q = 'Hovedstaden'

        When method GET
        Then status 200
        And def firstresponse = response
        And match firstresponse == '#[1]'

        Then param q = 'hovedstaden'

        When method GET
        Then status 200
        And def secondresponse = response
        And match secondresponse == '#[1]'

        Then match firstresponse == secondresponse

        Then param q = 'HOVEDSTADEN'

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

  Scenario: Filter kommunekode in like
    Then param q = 's'

    And param filter = "kommunekode like '%0169%'"
    When method GET
    Then status 200
    And match response == '#[1]'
