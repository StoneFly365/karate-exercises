# https://tester-ink.atlassian.net/browse/QA-338
# https://tester-ink.atlassian.net/browse/QA-349

@smokeTest
@login

Feature: Sign In

  Background: preconditions
    * url apiUrl
    * def dataLogin = read('classpath:examples/conduitApp/jsonData/loginUser.json')

  Scenario: Sign In correctly
    Given path 'users', 'login'
    And request dataLogin
    When method Post
    Then status 200
    And match response == 
    """
    {
      "user": {
        "email": "#string",
        "username": "#string",
        "bio": "##string",
        "image": "#string",
        "token": "#string"
      }
    }
    """

  Scenario Outline: Validate sign up empty fields
    Given path 'users', 'login'
    And request
    """
    {
      "user": {
        "email": "<email>",
        "password": "<password>"
      }
    }
    """
    When method Post
    Then status 422
    And match response == <errorResponse>

    Examples:
      | email                    | password  | errorResponse                                    |
      |                          | 123123123 | { "errors": { "email": ["can't be blank"] } }    |
      | karateexercises@test.com |           | { "errors": { "password": ["can't be blank"] } } |

  Scenario Outline: Validate sign up wrong fields
    Given path 'users', 'login'
    And request
    """
    {
      "user": {
        "email": "<email>",
        "password": "<password>"
      }
    }
    """
    When method Post
    Then status 403
    And match response == <errorResponse>

    Examples:
      | email                    | password  | errorResponse                                         |
      | karateexercibes@test.com | 123123123 | { "errors": { "email or password": ["is invalid"] } } |
      | karateexercises@test.com | 111111111 | { "errors": { "email or password": ["is invalid"] } } |