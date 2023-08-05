import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/data/get_places_response.dart';

import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<GetPlacesResponse> getPlacesApi(String text) async {
  final response = await _apiProvider.httpRequest(
    requestType: RequestType.kGet,
    resource: Resource(
      url:
          '${await _storageController.getNodeUrl()}getPlaces?input=$text&region=IN%2C+AE&key=AIzaSyBqdu4G5XlM8aUzSA6Myult46AuZauvD8Q',
      request: '',
    ),
  );
  return getPlacesFromJson(response);
}
