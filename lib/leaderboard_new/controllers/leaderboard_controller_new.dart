import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/leaderboard_new/data/leaderboard_api_data_new.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../service/leaderboard_api_service.dart';

class LeaderBoardControllerNew extends GetxController {
  RxBool showLoader = false.obs;
  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  final dashBoardController = Get.find<DashBoardController>();
  Rx<LeaderBoardData> leaderBoardData = LeaderBoardData().obs;
  RxInt tabIndex = 1.obs;
  final selectedRadio = 1.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  void goBack() {
    Get.back();
  }

  _getUserInfo() async {
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    callLeaderboardApi(tabIndex.value);
  }

  void callLeaderboardApi(int forRange) async {
    showLoader.value = true;
    leaderboardApi(
      LeaderboardRequestData(
        forRange: forRange,
        supervisorId: int.parse(supervisorInfo.value.supervisorId ?? "0"),
        locationId: int.parse(supervisorInfo.value.kioskId ?? "0"),
      ),
    ).then(
      (response) {
        if (response.status == 1) {
          showLoader.value = false;
          if (response.responseData != null) {
            leaderBoardData.value = response.responseData!;
            leaderBoardData.refresh();
          }
        } else {
          showLoader.value = false;
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        printLogs("LeaderboardApi in error: ${error.toString()}");
      },
    );
  }

  void changeTabIndex(int newIndex) {
    tabIndex.value = newIndex + 1;
    callLeaderboardApi(
      tabIndex.value,
    );
  }

  void handleRadioValueChanged(int? value) {
    callLeaderboardApi(tabIndex.value);
    selectedRadio.value = value!;
  }
}
