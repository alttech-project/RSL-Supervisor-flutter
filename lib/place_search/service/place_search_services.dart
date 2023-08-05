import 'package:get/get_instance/src/get_instance.dart';
import 'package:rsl_supervisor/place_search/data/get_places_response.dart';

import '../../network/services.dart';

final ApiProvider apiProvider = GetInstance().find<ApiProvider>();

Future<GetPlacesResponse> getPlacesApi(String text) async {
  final response = await apiProvider.getApiCall(
    url:
        "https://ridenodeauth.limor.us/passenger/getPlaces?input=$text&region=IN%2C+AE&key=AIzaSyBqdu4G5XlM8aUzSA6Myult46AuZauvD8Q",
    key: "Get Places",
  );
  return getPlacesFromJson(response);
}
