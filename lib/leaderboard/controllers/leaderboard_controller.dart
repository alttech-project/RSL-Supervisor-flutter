import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/leaderboard/data/leaderboard_api_data.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../utils/helpers/basic_utils.dart';
import '../service/leaderboard_service.dart';

class LeaderBoardController extends GetxController {
  RxBool showLoader = false.obs;
  RxList<ResponseDate> supervisorList = <ResponseDate>[].obs;
  RxInt tabIndex = 1.obs;
  final dashBoardController = Get.find<DashBoardController>();
  final selectedRadio = 1.obs;

  // Mark:LeaderBaordAPi
  void callLeaderboardApi(int forRange, int supervisorId, int basedOn) async {
    showLoader.value = true;
    leaderboardApi(
      LeaderboardRequestData(
        forRange: forRange,
        supervisorId: supervisorId,
        basedOn: basedOn,
      ),
    ).then(
      (response) {
        if (response.status == 1) {
          supervisorList.value = response.responseDate ?? [];
          supervisorList.refresh();
          showLoader.value = false;
          printLogs("LeaderboardApi in message: ${response.message ?? ""}");
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        printLogs("LeaderboardApi in error: ${error.toString()}");
      },
    );
  }

  void handleRadioValueChanged(int? value) {
    callLeaderboardApi(
        tabIndex.value,
        int.parse(dashBoardController.supervisorInfo.value.supervisorId ?? ""),
        value!);
    selectedRadio.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    callLeaderboardApi(
        tabIndex.value,
        int.parse(dashBoardController.supervisorInfo.value.supervisorId ?? ""),
        selectedRadio.value);
  }

  void changeTabIndex(int newIndex) {
    tabIndex.value = newIndex + 1;
    callLeaderboardApi(
        tabIndex.value,
        int.parse(dashBoardController.supervisorInfo.value.supervisorId ?? ""),
        selectedRadio.value);
  }

}
