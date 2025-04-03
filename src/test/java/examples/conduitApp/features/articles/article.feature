# https://tester-ink.atlassian.net/browse/QA-340
# https://tester-ink.atlassian.net/browse/QA-364

@smokeTest 
@article
Feature: Manage comments on articles

    Background: Define URL
        * url apiUrl
        * def paginationParams = { limit: 10, offset: 0 }

    Scenario: Make a comment about article
        Given path 'articles'
        And params paginationParams
        When method Get
        Then status 200
        * def slugId = response.articles[0].slug
        
        Given path 'articles', slugId, 'comments'
        And request { "comment": { "body": "This is a comment" } }
        When method Post
        Then status 200
        And match response.comment.body == '#string'

        Given path 'articles', slugId, 'comments'
        When method Get
        Then status 200
        * def commentId = response.comments[0].id

        Given path 'articles', slugId, 'comments', commentId
        When method Delete
        Then status 200