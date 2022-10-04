Feature: Gsearch test

Background:
* url url + '/search'

Scenario: opstillingskreds
    Then param q = 'lund'
    And param resources = 'opstillingskreds'
    When method GET
    Then status 200
    And match response == '#[10]'