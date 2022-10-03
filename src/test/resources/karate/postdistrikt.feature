Feature: Gsearch test

Background:
* url url + '/search'

Scenario: Partial string
    Then param q = 'køben'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And match response == '#[10]'

Scenario: Search is case insensitive
    Then param q = 'København'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And def firstresponse = response
    And match firstresponse == '#[10]'

    Then param q = 'københavn'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And def secondresponse = response
    And match secondresponse == '#[10]'
    
    Then match firstresponse == secondresponse

    Then param q = 'KØBENHAVN'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And def thirdresponse = response
    And match thirdresponse == '#[10]'
    
    Then match thirdresponse == secondresponse

Scenario: Get København S and København SV
    Then param q = 'københavn S'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].name contains deep ['København S', 'København SV']

Scenario: Get Birkerød and Hillerød from using the postnumber as search input
    Then param q = '3460 3400'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].name contains deep ['Birkerød', 'Hillerød']

Scenario: Get København S from using the postnumber as search input and Søborg as tekst input
    Then param q = '2300 søborg'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].name contains deep ['Søborg', 'København S']

Scenario: Get postdistrikt that matches with Age
    Then param q = 'Age'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And match response == '#[4]'
    And match response.[*].name contains deep ['Agersø', 'Agerskov', 'Agerbæk', 'Agedrup']

Scenario: Get postdistrikt that matches with lund
    Then param q = 'lund'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And match response == '#[2]'
    And match response.[*].name contains deep ['Lunderskov', 'Lundby']

Scenario: Do not have a match on '.'
    Then param q = '.'
    And param resources = 'postdistrikt'
    When method GET
    Then status 200
    And match response == '#[0]'