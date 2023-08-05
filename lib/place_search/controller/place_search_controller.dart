import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/data/get_places_response.dart';

import '../../utils/helpers/basic_utils.dart';
import '../service/place_search_services.dart';

class PlaceSearchController extends GetxController {
  Rx<TextEditingController> searchController = TextEditingController().obs;
  RxList<Predictions> predictionList = <Predictions>[].obs;

  void callPlacesListApi(String text) async {
    getPlacesApi(text).then((response) {
      if (response.status == "OK") {
        predictionList.value = response.predictions ?? [];
        predictionList.refresh();
      } else {
        printLogs("Get places error: ${response.status ?? ""}");
        predictionList.value = [];
        predictionList.refresh();
      }
    }).onError((error, stackTrace) {
      printLogs("Get places error: ${error.toString()}");
      predictionList.value = [];
      predictionList.refresh();
    });
  }
}
