Feature: Gsearch test

Background:
* url url + '/search'

Scenario: navngivenvej
    Then param q = 'lund'
    And param resources = 'navngivenvej'
    When method GET
    Then status 200
    And match response == '#[10]'