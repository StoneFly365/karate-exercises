# https://tester-ink.atlassian.net/browse/QA-339
# https://tester-ink.atlassian.net/browse/QA-355

@smokeTest
@article

Feature: Publications Edition

Background: Define Url
    * url apiUrl
    * def articleRequestBody = read('classpath:examples/conduitApp/jsonData/newArticleRequest.json')
    * def dataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body
    
Scenario: Edit a publication
    Given path 'articles'
    And params {author:'Karatexercises', limit: 10, offset: 0}
    When method get
    Then status 200
    * def slugId = response.articles[0].slug

    Given path 'articles', slugId
    And request articleRequestBody
    When method put
    Then status 200
    
Scenario: Edit another user's publication 
    Given path 'articles', 'Discover-Bondar-Academy:-Your-Gateway-to-Efficient-Learning-1'
    And request articleRequestBody
    When method put
    Then status 403
    And match response.message == 'You are not authorized to update this article'