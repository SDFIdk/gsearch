Feature: Gsearch test

Background:
* url url + '/search'

Scenario: Adresse
    Then param q = 'lund'
    And param resources = 'adresse'
    When method GET
    Then status 200
    And match response == '#[10]'