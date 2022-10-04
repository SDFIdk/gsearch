Feature: Gsearch test

Background:
* url url + '/search'

Scenario: Hsusnummer
    Then param q = 'lund'
    And param resources = 'husnummer'
    When method GET
    Then status 200
    And match response == '#[10]'