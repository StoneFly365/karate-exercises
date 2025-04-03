# https://tester-ink.atlassian.net/browse/QA-338
# https://tester-ink.atlassian.net/browse/QA-348

@smokeTest 
@register

Feature: Register and users authentication

Background: preconditions 
* def dataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
* def randomEmail = dataGenerator.getRandomEmail();
* def randomUsername = dataGenerator.getRandomUsername();
* def randomPassword = dataGenerator.getRandomPassword();
* url apiUrl

Scenario: New user Sign Up
    Given path 'users'
    And request
    """
         { 
            "user": { 
                "email": #(randomEmail), 
                "password": #(randomPassword), 
                "username": #(randomUsername),               
                "bio": "##string",
                "image": "#string",
                "token": "#string"
            } 
        }
    """
    When method Post
    Then status 201
    And match response == 
    """
        {
            "user": {
                "id": "#number",
                "email": #(randomEmail),
                "token": "#string",
                "username": #(randomUsername),
                "bio": '##string',
                "image": "#string"
            }
        }
    """

    * def emailBeforeAt = randomEmail.split('@')[0]
    And assert emailBeforeAt.length() <= 50
    * def emailDomain = randomEmail.split('.')[1]
    And assert emailDomain == 'com' || emailDomain == 'es' || emailDomain == 'uk'
    
Scenario Outline: Validate sign up fields 
    Given path 'users'
    And request
    """
        {
            "user": {
                "email": "<email>",
                "password": "<password>",
                "username": "<username>"
            }
        }
    """
    When method Post
    Then status 422
    And match response == <errorResponse>

    Examples:
        | email           | password          | username          | errorResponse                                            |
        | karate@test.com | #(randomPassword) | #(randomUsername) | { "errors": { "email": ["has already been taken"] } }    |
        |                 | #(randomPassword) | #(randomUsername) | { "errors": { "email": ["can't be blank"] } }            |
        | #(randomEmail)  | #(randomPassword) | karate            | { "errors": { "username": ["has already been taken"] } } |
        | #(randomEmail)  | #(randomPassword) |                   | { "errors": { "username": ["can't be blank"] } }         |
        | #(ramdomEmail)  |                   | #(randomUsername) | { "errors": { "password": ["can't be blank"] } }         |