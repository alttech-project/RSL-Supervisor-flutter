import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/data/get_places_response.dart';

import '../../utils/helpers/basic_utils.dart';
import '../data/get_place_details_response.dart';
import '../service/place_search_services.dart';

class PlaceSearchController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxList<Predictions> predictionList = <Predictions>[].obs;
  Rx<PlaceDetails?> placeDetails = Rx<PlaceDetails?>(null);
  var apiLoading = false.obs;

  void callPlacesListApi(String text) async {
    apiLoading.value = true;
    getPlacesApi(text).then((response) {
      apiLoading.value = false;
      if (response.status == "OK") {
        predictionList.value = response.predictions ?? [];
        predictionList.refresh();
      } else {
        printLogs("Get places error: ${response.status ?? ""}");
        predictionList.value = [];
        predictionList.refresh();
      }
    }).onError((error, stackTrace) {
      apiLoading.value = false;
      printLogs("Get places error: ${error.toString()}");
      predictionList.value = [];
      predictionList.refresh();
    });
  }

//   {
//   final QuickTripController controller = Get.find<QuickTripController>();
//   controller
//   ..dropLocationController.text = '${prediction.description}'
//   ..dropLatitude = 0
//   ..dropLongitude = 0
//   ..fareController.text = '';
//   Get.offAndToNamed(AppRoutes.quickTripPage);
// }
  void callPlaceDetailsApi(String placeId) async {
    apiLoading.value = true;
    getPlaceDetailsApi(placeId).then((response) {
      apiLoading.value = false;
      if (response?.status == "OK") {
        placeDetails.value = response?.result;
        Get.back(result: response?.result);
      } else {
        printLogs("Get places error: ${response?.status ?? ""}");
        placeDetails.value = null;
      }
    }).onError((error, stackTrace) {
      apiLoading.value = false;
      printLogs("Get places error: ${error.toString()}");
      placeDetails.value = null;
    });
  }
}
