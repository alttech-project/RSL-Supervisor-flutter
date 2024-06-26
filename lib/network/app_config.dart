enum Environment { demo, live }

enum CompanyType { RSL, PLIMO }

enum LocationType { GENERAL, HOTEL }

const Map<Environment, String> baseUrls = {
  Environment.demo:
      'https://webdemo1.limor.us/supervisorapp/index/?lang=en&type=',
  Environment.live: 'https://web.limor.us/supervisorapp/index/?lang=en&type=',
};

const Map<Environment, String> nodeUrls = {
  Environment.demo: 'https://passnode.limor.us/passenger/',
  Environment.live: 'https://ridenodeauth.limor.us/passenger/',
};

const Map<Environment, String> newBookingUrls = {
  Environment.demo: 'http://34.197.71.192:3009/newBooking/',
  Environment.live:
      'https://corporateback.royalsmartlimousine.com/newBooking/supervisorCorporateBooking/',
};

const Map<CompanyType, String> companyIds = {
  CompanyType.RSL: '0',
  CompanyType.PLIMO: '194',
};

class AppConfig {
  static Environment currentEnvironment = Environment.live;
  static CompanyType companyType = CompanyType.RSL;

  static String get webBaseUrl => baseUrls[currentEnvironment]!;

  static String get nodeUrl => nodeUrls[currentEnvironment]!;

  static String get newBookingUrl => newBookingUrls[currentEnvironment]!;

  static String get companyId => companyIds[companyType]!;

  static String get googleMapKey => 'AIzaSyBqdu4G5XlM8aUzSA6Myult46AuZauvD8Q';
}
