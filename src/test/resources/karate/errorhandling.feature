Feature: Gsearch errorhandling test

  Background:
    * url url + '/search'

  Scenario: Empty q input
    Then param q = ''
    And param resources = 'postdistrikt'
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "gsearch.q: must not be blank",
        "errors": [
            "javax.validation.ConstraintViolationException: geosearch.q: must not be blank"
        ]
    }
    """

  Scenario: Missing q query parameter
    And param resources = 'postdistrikt'
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "Required request parameter 'q' for method parameter type String is not present",
        "errors": [
            "org.springframework.web.bind.MissingServletRequestParameterException: Required request parameter 'q' for method parameter type String is not present"
        ]
    }
    """

  Scenario: Missing resources query parameter
    Then param q = 's'
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "Required request parameter 'resources' for method parameter type String is not present",
        "errors": [
            "org.springframework.web.bind.MissingServletRequestParameterException: Required request parameter 'resources' for method parameter type String is not present"
        ]
    }
    """

  Scenario: Empty resources input
    Then param q = 's'
    And param resources = ''
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "geosearch.resources: must not be blank",
        "errors": [
            "javax.validation.ConstraintViolationException: geosearch.resources: must not be blank"
        ]
    }
    """

  Scenario: Not exiting resource
    Then param q = 's'
    And param resources = 'postdistrikt1'
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "Resource postdistrikt1 does not exist",
        "errors": [
            "java.lang.IllegalArgumentException: Resource postdistrikt1 does not exist"
        ]
    }
    """

  Scenario: Exceed maximum limit
    Then param q = 's'
    And param resources = 'postdistrikt'
    And param limit = '101'
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "Required request parameter 'q' for method parameter type String is not present",
        "errors": [
            "org.springframework.web.bind.MissingServletRequestParameterException: Required request parameter 'q' for method parameter type String is not present"
        ]
    }
    """