Feature: Gsearch test

Background:
* url url + '/search'

Scenario: Kommune
    Then param q = 'lund'
    And param resources = 'kommune'
    When method GET
    Then status 200
    And match response == '#[10]'