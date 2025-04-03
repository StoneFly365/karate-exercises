# https://tester-ink.atlassian.net/browse/QA-340
# https://tester-ink.atlassian.net/browse/QA-363

@smokeTest 
@homePage
Feature: Manage article favorites

    Background: Define URL
        * url apiUrl
        * def paginationParams = { limit: 10, offset: 0 }

        Given path 'articles'
        And params paginationParams
        When method Get
        Then status 200
        * def slugId = response.articles[0].slug

    Scenario: Mark article as favorite

        Given path 'articles', slugId, 'favorite'
        And request {}
        When method Post
        Then status 200
        And match response.article.favorited == true

    Scenario: Unmark article as favorite

        Given path 'articles', slugId, 'favorite'
        When method Delete
        Then status 200

        Given path 'articles', slugId
        And params paginationParams
        When method Get
        Then status 200
        And match response.article.favorited == false
