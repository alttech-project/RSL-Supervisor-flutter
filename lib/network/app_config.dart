enum Environment {
  demo,
  live,
}

const Map<Environment, String> baseUrls = {
  Environment.demo: 'https://webdemo1.limor.us/supervisorapp/index/?lang=en&type=',
  Environment.live: 'https://web.limor.us/supervisorapp/index/?lang=en&type=',
};

class AppConfig {
  static Environment currentEnvironment = Environment.demo;

  static String get webBaseUrl => baseUrls[currentEnvironment]!;
}