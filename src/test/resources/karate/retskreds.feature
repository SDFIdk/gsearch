Feature: Gsearch test

Background:
* url url + '/search'

Scenario: retskreds
    Then param q = 'lund'
    And param resources = 'retskreds'
    When method GET
    Then status 200
    And match response == '#[10]'