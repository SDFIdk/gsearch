Feature: Gsearch test

Background:
* url url + '/search'

Scenario: stednavn
    Then param q = 'lund'
    And param resources = 'stednavn'
    When method GET
    Then status 200
    And match response == '#[10]'