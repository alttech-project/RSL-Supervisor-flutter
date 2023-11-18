import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rsl_supervisor/network/app_config.dart';
import '../utils/helpers/app_info.dart';
import '../utils/helpers/basic_utils.dart';
import '../utils/helpers/getx_storage.dart';

class ApiProvider extends GetConnect {
  final GetStorageController controller = Get.find<GetStorageController>();

  @override
  void onInit() {
    super.onInit();
    httpClient.addAuthenticator<Object?>((request) async {
      final response = await httpClient.post(
        "token",
        body: {
          "username": "sap",
          "password": "Sap@12345",
          "grant_type": "password"
        },
        contentType: 'application/x-www-form-urlencoded',
      );
      controller.saveTokenData(value: response.body["access_token"].toString());
      request.headers['Authorization'] = "Bearer ${controller.getTokenData()}";
      return request;
    });

    httpClient.addRequestModifier<Object?>((request) async {
      String token = await controller.getTokenData();
      request.headers['Authorization'] = "Bearer $token";
      return request;
    });
    httpClient.maxAuthRetries = 3;
    httpClient.timeout = const Duration(seconds: 60);
  }

  Future<String> httpRequest(
      {RequestType requestType = RequestType.kPost,
      required Resource resource,
      bool encryptParams = true,
      bool decryptResponse = false,
      Map<String, String>? queryParam}) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    printLogs("Request Url : ${resource.url}");
    printLogs("Request Data : ${resource.request}\n");
    switch (requestType) {
      case RequestType.kGet:
        Response response = await get(resource.url);
        printLogs("Response Url: ${response.request?.url}");
        return response.bodyString ?? '';

      case RequestType.kPut:
        Response response = await put(resource.url, "");
        printLogs("Response Url: ${response.request?.url}");
        return response.bodyString ?? '';

      default:
        Response response = await post(resource.url, resource.request,
            query: _query(customQuery: queryParam));
        printLogs("Response Url: ${response.request?.url}");
        printLogs("Response Data : ${response.bodyString}");
        return response.bodyString ?? '';
    }
  }
}

class Resource<T> {
  final String url;
  final String request;
  T Function(Response response)? parse;

  Resource({required this.url, required this.request, this.parse});
}

class Request<T> {
  final String request;

  Request({required this.request});
}

enum RequestType { kGet, kPost, kPut }

Map<String, String> _query({Map<String, String>? customQuery}) =>
    appQueryParam(customQuery: customQuery);

Map<String, String> defaultApiHeaders(token) {
  final defaultApiHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  return defaultApiHeaders;
}

Map<String, String> appQueryParam({Map<String, String>? customQuery}) {
  Map<String, String> appQueryParam;
  Map<String, String> data;

  if (AppInfo.appInfo!.cid!.isNotEmpty) {
    data = {
      "lang": "en",
      'dID': AppInfo.appInfo?.deviceId ?? "",
      'dt': AppInfo.appInfo?.deviceType ?? "",
      'vn': AppInfo.appInfo?.versionName ?? "",
      'vc': AppInfo.appInfo?.versionCode ?? "",
      'cid': AppInfo.appInfo?.cid ?? "",
    };
  } else {
    data = {
      "lang": "en",
      'dID': AppInfo.appInfo?.deviceId ?? "",
      'dt': AppInfo.appInfo?.deviceType ?? "",
      'vn': AppInfo.appInfo?.versionName ?? "",
      'vc': AppInfo.appInfo?.versionCode ?? ""
    };
  }

  appQueryParam = {...?customQuery, ...data};
  return appQueryParam;
}
