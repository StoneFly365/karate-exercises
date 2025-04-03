# https://tester-ink.atlassian.net/browse/QA-340
# https://tester-ink.atlassian.net/browse/QA-362

@smokeTest 
@profile
Feature: Manage favorite profiles

    Background: Preconditions
        * url apiUrl
        * def user = karate.urlDecode('Artem%20Bondar')
        
    Scenario: Mark user as favorite 
        Given path 'profiles', user
        When method Get
        Then status 200
        And match response.profile.username == 'Artem Bondar'

        Given path 'profiles', user, 'follow'
        And request { "profile": { "following": true } }
        When method Post
        Then status 200
        And match response.profile.following == true

        Given path 'profiles', user, 'follow'
        When method Delete
        Then status 200
        And match response.profile.following == false