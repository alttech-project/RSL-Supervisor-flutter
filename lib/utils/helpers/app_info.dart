enum BaseUrls { demo, live }

extension BaseURLHelper on BaseUrls {
  String get rawValue {
    switch (this) {
      case BaseUrls.demo:
        return 'http://3.108.72.20:8451/';
      case BaseUrls.live:
        return 'http://3.108.72.20:8451/';
      default:
        return 'http://34.235.139.192:2200/';
    }
  }
}

class AppInfo {
  static String kAppBaseUrl = BaseUrls.demo.rawValue;
}
