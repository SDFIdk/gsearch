Feature: Gsearch kommune test

Background:
* url url + '/search'

Scenario: Response matches columns database
    Then param q = 'Albertslund'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And match response == '#[1]'
    And def bboxSchema = {type: 'Polygon', coordinates: '#array'}
    And def geometriSchema = {type: 'MultiPolygon', coordinates: '#array'}
    And match response contains deep
    """
    {
      "type": 'kommune',
      "kommunenavn": '#string',
      "praesentation": '#string',
      "bbox": '#(bboxSchema)',
      "geometri": '#(geometriSchema)',
      "id": '#string',
      "rang1": '#string',
      "rang2": '#string'
    }
    """

Scenario: Partial string
    Then param q = 'køben'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And match response == '#[1]'

Scenario: Search is case insensitive
    Then param q = 'København'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[1]'

    Then param q = 'københavn'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[1]'

    Then match firstresponse == secondresponse

    Then param q = 'KØBENHAVN'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[1]'

    Then match thirdresponse == secondresponse

Scenario: Like search on nord returns Norddjurs and Nordfyns
    Then param q = 'nord'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].kommunenavn contains deep ['Norddjurs', 'Nordfyns']
    And match response.[*].praesentation contains deep ['Norddjurs kommune', 'Nordfyns kommune']

Scenario: Get København from using the kommunekode as search input
    Then param q = '0101'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And match response == '#[1]'
    And match response.[*].kommunenavn contains deep ['København']
    And match response.[*].id contains deep ['0101']

Scenario: Combined search, Get København from using the kommunekode as search input and Herlev as tekst input
    Then param q = '0101 herlev'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].kommunenavn contains deep ['Herlev', 'København']

Scenario: Do not have a match on '.'
    Then param q = '.'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And match response == '#[0]'

Scenario: Test maximum limit and small search
    Then param q = 'h'
    And param resources = 'kommune'
    And param limit = '100'
    When method GET
    Then status 200
    And match response == '#[14]'
