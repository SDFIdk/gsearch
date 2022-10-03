Feature: Gsearch test

Background:
* url serviceUrl + '/search'

Scenario: Testing valid GET endpoint
    When method GET
    Then status 200