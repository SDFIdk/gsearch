Feature: Geosearch test

Background:
* url 'https://gsearch.k8s-test-121.septima.dk/geosearch'

Scenario: Testing valid GET endpoint
    Given param search = 'farum'
    Given param resources = 'sogn,postdistrikt'
    When method GET
    Then status 200