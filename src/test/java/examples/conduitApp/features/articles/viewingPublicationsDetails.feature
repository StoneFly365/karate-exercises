# https://tester-ink.atlassian.net/browse/QA-339
# https://tester-ink.atlassian.net/browse/QA-357

@smokeTest
@article

Feature: See publications details 

Background: Define Url
    * url apiUrl
    * def timeValidator = read('classpath:examples/conduitApp/helpers/timeValidator.js')

Scenario: Check details of the publications
    Given path 'articles'
    When method get
    Then status 200
    * def slugId = response.articles[0].slug

    Given path 'articles', slugId
    When method get
    Then status 200
    And match response.article.title == '#string'
    And match response.article.body == '#string'
    And match response.article.tagList == '#[]'  
    * def isValidDate = timeValidator(response.article.createdAt)
    And match isValidDate == true
    And match response.article.author.username == '#string'
    
# Queda pendiente este escenario
# Scenario: Unauthenticated users can access the details endpoint, but should not have access to edit or delete endpoints
#     * def slugId = 'Discover-Bondar-Academy:-Your-Gateway-to-Efficient-Learning-1'
#     Given path 'articles', slugId
#     When method delete
#     Then status 403
#     And match response.message == "You are not authorized to delete this article" 

#     Given path 'articles', slugId
#     And request {}
#     When method put
#     Then status 403
#     And match response.message == "You are not authorized to update this article"