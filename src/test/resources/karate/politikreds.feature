Feature: Gsearch test

Background:
* url url + '/search'

Scenario: politikreds
    Then param q = 'lund'
    And param resources = 'politikreds'
    When method GET
    Then status 200
    And match response == '#[10]'