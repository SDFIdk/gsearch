Feature: Geosearch test

Background:
* url serviceUrl + '/geosearch'

Scenario: Testing valid GET endpoint
    When method GET
    Then status 200