function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }
  if (env === 'dev') {
    config.userEmail = 'karateexercises@test.com';
    config.userPassword = '123123123';
  } else if (env === 'qa') {
   // Dejamos comentadas las siguientes líneas para dejar preparado un ejemplo de código, sobre como sería la configuración cuando tuviéramos mas de un entorno de pruebas
   //config.userEmail = 'karate@test.com';
   // config.userPassword = '123456';
  }

  karate.configure('logPrettyRequest', true);
  karate.configure('logPrettyResponse', true);

  var accessToken = karate.callSingle('classpath:examples/conduitApp/helpers/createToken.feature', config).authToken;
  karate.configure('headers', {Authorization: 'Token ' + accessToken});

  return config;
}