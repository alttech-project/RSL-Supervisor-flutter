import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rsl_supervisor/dashboard/data/logout_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';

import '../../shared/styles/app_color.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final LocationManager locationManager = LocationManager();

  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  var deviceToken = "";
  RxString appVersion = "".obs;
  RxString appBuildNumber = "".obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
    _getAppInfo();
  }

  _getUserInfo() async {
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    deviceToken = await GetStorageController().getDeviceToken();
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

  openMenu() {
    scaffoldKey.currentState?.openDrawer();
  }

  menuAction(String title) {
    scaffoldKey.currentState?.closeDrawer();
    switch (title) {
      case 'Logout':
        _callLogoutApi();
        break;
      default:
        break;
    }
  }

  void _callLogoutApi() async {
    LocationResult<Position> result =
        await locationManager.getCurrentLocation();

    if (result.data != null) {
      logoutApi(LogoutApiRequest(
        supervisorId: supervisorInfo.value.supervisorId,
        cid: supervisorInfo.value.cid,
        latitude: result.data!.latitude,
        longitude: result.data!.longitude,
        accuracy: result.data!.accuracy,
        photoUrl:
            "https://firebasestorage.googleapis.com/v0/b/rsl-passenger-b0629.appspot.com/o/Supervisor%2FPhotosVerification%2FPhotos_07-08-2023%2Fphoto_-2001340201?alt=media&token=94c2317c-80ce-4534-9a18-4000245313be",
      )).then((response) {
        if ((response.status ?? 0) == 1) {
          GetStorageController().removeSupervisorInfo();
          Get.offAndToNamed(AppRoutes.loginPage);
        } else {
          Get.snackbar('Alert', '${response.message}',
              backgroundColor: AppColors.kGetSnackBarColor.value);
        }
      }).onError((error, stackTrace) {
        Get.snackbar('Alert', error.toString(),
            backgroundColor: AppColors.kGetSnackBarColor.value);
      });
    } else {
      Get.defaultDialog(
          title: "ERROR!",
          middleText:
              result.error ?? "Error occured while fetching current location");
    }
  }

  void _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    appBuildNumber.value = packageInfo.buildNumber;
  }
}
