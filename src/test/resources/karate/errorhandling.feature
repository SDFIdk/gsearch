Feature: Gsearch errorhandling test

  Background:
    * url url + '/postdistrikt'

  Scenario: Empty q input
    Then param q = ''
    
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "getPostdistrikt.q: must not be blank",
        "errors": [
            "javax.validation.ConstraintViolationException: getPostdistrikt.q: must not be blank"
        ]
    }
    """

  Scenario: Missing q query parameter
    
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

  Scenario: Not exiting resource
    Then url url + '/postdistrikt1'
    Then param q = 's'
    When method GET
    Then status 404
    And match response ==
    """
    {
        "timestamp":#number,
        "status":404,
        "error":"Not Found",
        "path":"/postdistrikt1"
    }
    """

  Scenario: Exceed maximum limit
    Then param q = 's'
    
    And param limit = '101'
    When method GET
    Then status 400
    And match response ==
    """
    {
        "status": "BAD_REQUEST",
        "message": "getPostdistrikt.limit: must be less than or equal to 100",
        "errors": [
            "javax.validation.ConstraintViolationException: getPostdistrikt.limit: must be less than or equal to 100"
        ]
    }
    """