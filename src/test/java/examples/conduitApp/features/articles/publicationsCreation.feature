# https://tester-ink.atlassian.net/browse/QA-339
# https://tester-ink.atlassian.net/browse/QA-354

@smokeTest
@article

Feature: Publications Creation

  Background: Define Url
    * url apiUrl
    * def articleRequestBody = read('classpath:examples/conduitApp/jsonData/newArticleRequest.json')
    * def dataGenerator = Java.type('examples.conduitApp.helpers.DataGenerator')
    * set articleRequestBody.article.title = dataGenerator.getRandomArticleValues().title
    * set articleRequestBody.article.description = dataGenerator.getRandomArticleValues().description
    * set articleRequestBody.article.body = dataGenerator.getRandomArticleValues().body

  Scenario: Create a new publication
    Given path 'articles'
    And request articleRequestBody
    When method post
    Then status 201
    And match response.article.title == articleRequestBody.article.title
    And match response.article.description == articleRequestBody.article.description
    And match response.article.body == articleRequestBody.article.body
  
  Scenario Outline: Check empty or invalid mandatory fields
    Given path 'articles'
    And request { "article": { "title": "<title>", "description": <description>, "body": "<body>" } }
    When method post
    Then status 422
    And match response == <error>
    Examples:
      | title                  | description      | body                   | error                                         |
      |                        | Test empty title | Test empty title       | {"errors":{"title":["can't be blank"]}}       |
      | Test empty description |                  | Test empty description | {"errors":{"description":["can't be blank"]}} |
      | Test empty body        | Test empty body  |                        | {"errors":{"body":["can't be blank"]}}        |