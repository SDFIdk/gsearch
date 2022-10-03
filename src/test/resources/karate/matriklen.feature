Feature: Gsearch test

Background:
* url url + '/search'

Scenario: Matriklen
    Then param q = 'lund'
    And param resources = 'matrikelnummer'
    When method GET
    Then status 200
    And match response == '#[10]'