import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/data/get_places_response.dart';

import '../../network/app_config.dart';
import '../../network/services.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/get_place_details_response.dart';

final ApiProvider _apiProvider = Get.find<ApiProvider>();
final _storageController = Get.find<GetStorageController>();

Future<GetPlacesResponse> getPlacesApi(String text) async {
  String url = await _storageController.getNodeUrl();
  url = url.replaceAll('passnode', 'ridenode');
  final response = await _apiProvider.httpRequest(
    requestType: RequestType.kGet,
    resource: Resource(
      url:
          '${url}getPlaces?input=$text&region=IN%2C+AE&key=${AppConfig.googleMapKey}',
      request: '',
    ),
  );
  return getPlacesFromJson(response);
}

Future<GetPlaceDetailsResponse> getPlaceDetailsApi(String placeId) async {
  String url = await _storageController.getNodeUrl();
  url = url.replaceAll('passnode', 'ridenode');
  final response = await _apiProvider.httpRequest(
    requestType: RequestType.kGet,
    resource: Resource(
      url:
          '${url}getPlaceDetails?placeid=$placeId&key=${AppConfig.googleMapKey}',
      request: '',
    ),
  );
  return placeDetailsResponseFromJson(response);
}
