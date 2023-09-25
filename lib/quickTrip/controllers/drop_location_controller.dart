import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/quickTrip/controllers/quick_trip_controller.dart';
import '../../dashboard/data/dashboard_api_data.dart';
import '../../dashboard/service/dashboard_service.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';

class DropLocationController extends GetxController {
  RxBool isShiftIn = true.obs;
  RxBool useCustomDrop = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  List<DropOffList> dropList = <DropOffList>[].obs;
  RxList<DropOffList> dropSearchList = <DropOffList>[].obs;
  RxString searchTxt = "".obs;
  RxString noDropOffDataMsg = "No Drop-off found".obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LocationManager locationManager = LocationManager();

  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  var deviceToken = "";
  RxString appVersion = "".obs;
  RxString appBuildNumber = "".obs;
  RxBool apiLoading = false.obs;
  RxBool showLoader = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    deviceToken = await GetStorageController().getDeviceToken();
    _callDashboardApi();
  }

  void _callDashboardApi() async {
    apiLoading.value = true;
    dashboardApi(DasboardApiRequest(
      kioskId: supervisorInfo.value.kioskId,
      supervisorId: supervisorInfo.value.supervisorId,
      cid: supervisorInfo.value.cid,
      deviceToken: deviceToken,
    )).then((response) {
      apiLoading.value = false;
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
      apiLoading.value = false;
      printLogs("Dashboard api error: ${error.toString()}");
      dropList = [];
      dropSearchList.value = [];
      dropSearchList.refresh();
    });
  }

  customDropAction(bool newValue) {
    print("hi customDropAction ${newValue}");
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

  void moveToQuickTrips() async {
    final result = await Get.toNamed(
      AppRoutes.placeSearchPage,
    );

    final QuickTripController controller = Get.find<QuickTripController>();
    controller
      ..dropLocationController.text = '${result.formattedAddress}'
      ..dropLatitude =
          double.tryParse('${result.geometry?.location?.lat}') ?? 0.0
      ..dropLongitude =
          double.tryParse('${result.geometry?.location?.lng}') ?? 0.0
      ..fareController.text = '';
    Get.back();
  }
}
