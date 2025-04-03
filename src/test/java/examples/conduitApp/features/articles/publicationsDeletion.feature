# https://tester-ink.atlassian.net/browse/QA-339
# https://tester-ink.atlassian.net/browse/QA-356

@smokeTest
@article
    
Feature: Publications deletion

Background: Define Url
    * url apiUrl

Scenario: Delete a publication
    Given path 'articles'
    When method get
    Then status 200
    * def articles = response.articles
    * def articleKarateExercises = articles.find(authorArticle => authorArticle.author.username == 'Karatexercises')
    * def slugId = articleKarateExercises.slug

    Given path 'articles', slugId
    When method delete
    Then status 204