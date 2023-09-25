import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/driver_list/data/driver_list_api_data.dart';
import 'package:rsl_supervisor/driver_list/service/driver_list_service.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';

class DriverListController extends GetxController {
  RxBool apiLoading = false.obs;
  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  RxList<DriverList> driverList = <DriverList>[].obs;
  RxString noDataMsg = "No data found".obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    _callDriverListApi();
  }

  void _callDriverListApi() async {
    apiLoading.value = true;
    driverListApi(DriverListRequest(
            locationId: supervisorInfo.value.kioskId.toString()))
        .then((response) {
      apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        driverList.value = response.driverList ?? [];
        driverList.refresh();
        noDataMsg.value = response.message ?? "";
      } else {
        noDataMsg.value = response.message ?? "No Data found";
        driverList.value = [];
        driverList.refresh();
      }
    }).onError((error, stackTrace) {
      apiLoading.value = false;
      printLogs("DriverList api error: ${error.toString()}");
      driverList.value = [];
      driverList.refresh();
    });
  }
}
