import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/dashboard_api_data.dart';
import '../data/shift_in_api_data.dart';
import '../service/dashboard_service.dart';

class DashBoardController extends GetxController {
  RxBool isShiftIn = true.obs;
  RxBool useCustomDrop = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  List<DropOffList> dropList = <DropOffList>[].obs;
  RxList<DropOffList> dropSearchList = <DropOffList>[].obs;
  RxString searchTxt = "".obs;
  RxString noDropOffDataMsg = "No Dropoff found".obs;
  final GetStorageController _storageController =
      Get.find<GetStorageController>();

  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  var deviceToken = "";
  @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  getUserInfo() async {
    supervisorInfo.value = await _storageController.getSupervisorInfo();
    deviceToken = await _storageController.getDeviceToken();
    _callShiftInApi("1");
    _callDashboardApi();
  }

  void _callDashboardApi() async {
    dashboardApi(DasboardApiRequest(
      kioskId: supervisorInfo.value.kioskId,
      supervisorId: supervisorInfo.value.supervisorId,
      cid: supervisorInfo.value.cid,
      deviceToken: deviceToken,
    )).then((response) {
      if ((response.status ?? 0) == 1) {
        dropList = response.dropOffList ?? [];
        dropSearchList.value = response.dropOffList ?? [];
        dropSearchList.refresh();
        noDropOffDataMsg.value = response.message ?? "";
      } else {
        noDropOffDataMsg.value = response.message ?? "No Dropoff found";
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

  void _callShiftInApi(String type) async {
    shiftInApi(ShiftInRequest(
      kioskId: supervisorInfo.value.kioskId,
      supervisorId: supervisorInfo.value.supervisorId,
      cid: supervisorInfo.value.cid,
      type: type,
    )).then((response) {
      printLogs("Shift in message: ${response.message ?? ""}");
    }).onError((error, stackTrace) {
      printLogs("Shift in error: ${error.toString()}");
    });
  }

  shiftInOutAction(bool newValue) {
    isShiftIn.value = newValue;
    _callShiftInApi(newValue ? "1" : "2");
  }

  customDropAction(bool newValue) {
    useCustomDrop.value = newValue;

    if (useCustomDrop.value) {
      searchController.value.text = "";
      searchTxt.value = "";
      FocusManager.instance.primaryFocus?.unfocus();
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

  logout() {
    _storageController.removeSupervisorInfo();
    Get.offNamed(AppRoutes.loginPage);
  }
}
