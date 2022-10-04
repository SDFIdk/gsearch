Feature: Gsearch test

Background:
* url url + '/search'

Scenario: region
    Then param q = 'lund'
    And param resources = 'region'
    When method GET
    Then status 200
    And match response == '#[10]'