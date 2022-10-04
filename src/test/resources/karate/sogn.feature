Feature: Gsearch test

Background:
* url url + '/search'

Scenario: sogn
    Then param q = 'lund'
    And param resources = 'sogn'
    When method GET
    Then status 200
    And match response == '#[10]'