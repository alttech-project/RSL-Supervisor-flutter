import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../utils/helpers/basic_utils.dart';
import '../data/dashboard_api_data.dart';
import '../service/dashboard_service.dart';

class DashBoardController extends GetxController {
  RxBool isShiftIn = true.obs;
  RxBool useCustomDrop = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  List<DropOffList> dropList = <DropOffList>[].obs;
  RxList<DropOffList> dropSearchList = <DropOffList>[].obs;
  RxString searchTxt = "".obs;
  RxString noDropOffDataMsg = "No Dropoff found".obs;
  @override
  void onInit() {
    super.onInit();
    _callDashboardApi();
  }

  void _callDashboardApi() async {
    dashboardApi(DasboardApiRequest(
      kioskId: "187",
      supervisorId: "126",
      cid: "7",
      deviceToken:
          "dJsfk-hJS6izKJRqBd-9vI:APA91bEhxZRzH2ThZiHMXZPm9OEQh7PBhzrwjNYjsJYRBJ2kYy3xX5BbiNbc-MOwiRDR9zrIWikhD6fRBnedi4yUVXQXHUMAyTTzTxNw_PEnJClgzwqEeTaJhVFWSHsWJtejctcTUBSm",
    )).then((response) {
      if ((response.status ?? 0) == 1) {
        dropList = response.dropOffList ?? [];
        dropSearchList.value = response.dropOffList ?? [];
        dropSearchList.refresh();
      } else {
        noDropOffDataMsg.value = "No Dropoff found";
        dropList = [];
        dropSearchList.value = [];
        dropSearchList.refresh();
      }
    }).onError((error, stackTrace) {
      printLogs("Dashboard api error: ${error.toString()}");
      dropList = [];
      dropSearchList.value = [];
      dropSearchList.refresh();
    });
  }

  shiftInOutAction(bool newValue) {
    isShiftIn.value = newValue;
  }

  customDropAction(bool newValue) {
    useCustomDrop.value = newValue;

    if (useCustomDrop.value) {
      searchController.value.text = "";
      searchTxt.value = "";
      FocusManager.instance.primaryFocus?.unfocus();
      noDropOffDataMsg.value =
          "Please search any drop off location in the search option above.";
      dropSearchList.value = [];
      dropSearchList.refresh();
    } else {
      dropSearchList.value = dropList;
      dropSearchList.refresh();
    }
  }

  searchDropOff(String text) {
    if (text.isEmpty) {
      dropSearchList.value = dropList;
      dropSearchList.refresh();
      return;
    }

    dropSearchList.value = dropList
        .where((dropoff) =>
            (dropoff.address ?? "").toLowerCase().contains(text.toLowerCase()))
        .toList();
    dropSearchList.refresh();
  }

  moveToPlaceSeaerch() {
    Get.toNamed(AppRoutes.placeSearchPage);
  }
}
