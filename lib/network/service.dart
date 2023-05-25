import 'package:get/get.dart';
import 'package:get_x_sample/data/api_request_data.dart';

class ApiProvider extends GetConnect {
  @override
  void onInit() {
    // All request will pass to jsonEncode so CasesModel.fromJson()
    httpClient.baseUrl = 'https://api.covid19api.com';
    // baseUrl = 'https://api.covid19api.com'; // It define baseUrl to
    // Http and websockets if used with no [httpClient] instance

    // It's will attach 'apikey' property on header from all requests
    /*httpClient.addRequestModifier((request) {
      request.headers['apikey'] = '12345678';
      return request;
    });


    httpClient.addAuthenticator((request) async {
      final response = await get("http://yourapi/token");
      final token = response.body['token'];
      // Set the header
      request.headers['Authorization'] = "$token";
      return request;
    });*/

   /* httpClient.addRequestModifier((request){
      request.headers['apikey'] = '12345678';
      return request;
    });*/

    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }

  // Get request
  Future<Response> getUser(int id) => get('http://youapi/users/$id');

  // Post request
  Future<Response<VerifyPhoneApiResponseData>> verifyPhoneApi(
          VerifyPhoneApiRequestData requestData) =>
      post(null, requestData);

  // Post request with File
  /*Future<Response<CasesModel>> postCases(List<int> image) {
    final form = FormData({
      'file': MultipartFile(image, filename: 'avatar.png'),
      'otherFile': MultipartFile(image, filename: 'cover.png'),
    });
    return post('http://youapi/users/upload', form);
  }*/

  GetSocket userMessages() {
    return socket('https://yourapi/users/socket');
  }
}
