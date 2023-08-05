import 'dart:convert';
import 'package:get/get.dart';
import '../utils/helpers/basic_utils.dart';
import '../utils/helpers/getx_storage.dart';

enum AppBaseUrls {
  kWebDemo,
  kBackButtonColor,
}

class ApiProvider extends GetConnect {
  final GetStorageController controller = Get.find<GetStorageController>();

  @override
  void onInit() {
    super.onInit();
    // httpClient.baseUrl = BaseUrls.demo.rawValue;
    httpClient.addAuthenticator<Object?>((request) async {
      // printLogs("Authenticator API Call 401 OCCURED");
      final response = await httpClient.post("token",
          body: {
            "username": "sap",
            "password": "Sap@12345",
            "grant_type": "password"
          },
          contentType: 'application/x-www-form-urlencoded');
      /*if (response.statusCode == 200) {
        printLogs("Token API Success ${response.body["access_token"]}");
      }*/
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
  }

  Future<String> httpRequest(
      {RequestType requestType = RequestType.kPost,
        required Resource resource,
        bool encryptParams = true,
        bool decryptResponse = false}) async {
    printLogs("Request Url : ${resource.url}");
    printLogs("Request Data : ${resource.request}");
    switch (requestType) {
      case RequestType.kGet:
        Response response = await get(
          resource.url,
        );
        return response.bodyString ?? '';

      case RequestType.kPut:
        Response response = await put(resource.url, "");
        return response.bodyString ?? '';

      default:
        Response response = await post(
          resource.url,
          resource.request,
        );
        printLogs("Response data : ${response.bodyString}");
        return response.bodyString ?? '';
    }
  }
}

/*class ApiProvider extends GetConnect {
  final GetStorageController controller = Get.find<GetStorageController>();

  Future<String> postApiCall(
      {required Resource resource, required String key}) async {
    printLogs("$key Url : ${resource.url}");
    printLogs("$key Request : ${resource.request}");
    Response response = await post(
      resource.url,
      resource.request,
    );
    printLogs("$key Response : ${json.encode(response.body)}");
    return json.encode(response.body);
  }

  Future<String> getApiCall({required String url, required String key}) async {
    printLogs("$key Url : $url");
    Response response = await get(url);
    printLogs("$key Response : ${json.encode(response.body)}");
    return json.encode(response.body);
  }
}*/

class Resource<T> {
  final String url;
  final String request;
  T Function(Response response)? parse;

  Resource({required this.url, required this.request, this.parse});
}

class Request<T> {
  final String request;

  Request({
    required this.request,
  });
}

enum RequestType { kGet, kPost, kPut }

Map<String, String> defaultApiHeaders(token) {
  final defaultApiHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token'
  };
  return defaultApiHeaders;
}
