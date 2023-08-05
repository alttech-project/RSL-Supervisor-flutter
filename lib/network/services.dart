import 'dart:convert';
import 'package:get/get.dart';
import '../utils/helpers/basic_utils.dart';
import '../utils/helpers/getx_storage.dart';

class ApiProvider extends GetConnect {
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
}

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

Map<String, String> defaultApiHeaders(token) {
  final _defaultApiHeaders = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${token}'
  };
  return _defaultApiHeaders;
}
