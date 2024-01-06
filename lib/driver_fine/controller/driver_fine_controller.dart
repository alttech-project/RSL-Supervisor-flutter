

import 'package:flutter/cupertino.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import '../../driver_list/data/driver_list_api_data.dart';
import '../../driver_list/service/driver_list_service.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/driver_fine_data.dart';

class DriverFineController extends GetxController {

  RxList<FineDetail> fineDetails = <FineDetail>[].obs;
  RxList<assignedFineDetail> fineassignedDrivers = <assignedFineDetail>[].obs;


  final TextEditingController fineTypeController = TextEditingController();
  final TextEditingController fineAmountController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController fineAssignController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  RxBool apiLoading = false.obs;
  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  RxList<DriverList> driverList = <DriverList>[].obs;
  Rx<DriverListResponse> driverListResponse = DriverListResponse().obs;
  RxString noDataMsg = "No data found".obs;


  @override
  void onInit() {
    super.onInit();
    print("onInitCalled");
    clearTextFields();
    _getUserInfo();
     }

  _getUserInfo() async {
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    _callDriverListApi();
  }

  void addFineDetails(FineDetail details) {
    fineDetails.add(details);
  }
  void assignedFineDetails(assignedFineDetail details) {
    fineassignedDrivers.add(details);
  }

  void clearTextFields() {
    fineTypeController.clear();
    fineAmountController.clear();
    remarksController.clear();
    notesController.clear();
    fineAssignController.clear();
  }


  void _callDriverListApi() async {
    apiLoading.value = true;
    driverListApi(DriverListRequest(
        locationId: supervisorInfo.value.kioskId.toString()))
        .then((response) {
      apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        driverListResponse.value = response;
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