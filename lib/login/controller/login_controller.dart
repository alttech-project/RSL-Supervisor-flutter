import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rsl_supervisor/login/data/assign_supervisor_api_data.dart';
import 'package:rsl_supervisor/login/data/verify_otp_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/data/logout_api_data.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';
import '../data/verify_user_api_data.dart';
import '../service/login_services.dart';
import 'dart:io';


class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final OtpFieldController otpController = OtpFieldController();
  final LocationManager locationManager = LocationManager();
  RxBool apiLoading = false.obs;
  RxString otp = "".obs;
  Rx<LoginViews> currentView = LoginViews.emailPage.obs;
  List<KioskList> kioskList = <KioskList>[];
  RxBool showKioskList = false.obs;
  RxString photoUrl = "".obs;
  var supervisorId = 0;
  var supervisorName = "";
  var supervisorUniqueId = "";
  var cid = 0;
  var kioskAddress = "";
  var kioskName = "";
  var kioskId = 0;
  var phoneNumber = "";
  var deviceToken = "";

  @override
  void onInit() {
    super.onInit();
    currentView.value = LoginViews.emailPage;
    getDeviceToken();
    checkCameraPermission();
  }

  getDeviceToken() async {
    deviceToken = await GetStorageController().getDeviceToken();
  }

  onBackPressed() {
    if (apiLoading.value) return;

    if (currentView.value == LoginViews.otpPage) {
      currentView.value = LoginViews.emailPage;
    } else {
      SystemNavigator.pop();
    }
  }

  checkValidationAndCallApi() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    String text = emailController.text.trim();
    if (GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)) {
      apiLoading.value = true;
      verifyUserNameApi(
        VerifyUserNameRequestData(
          companyDomain: 'regina',
          companyMainDomain: 'limor.us',
          cid: '',
          username: text,
          deviceToken: deviceToken,
        ),
      ).then(
        (response) {
          apiLoading.value = false;
          if (response.status == 1) {
            currentView.value = LoginViews.otpPage;
            Get.snackbar('Alert', '${response.message}',
                backgroundColor: AppColors.kGetSnackBarColor.value);
          } else {
            Get.snackbar('Alert', '${response.message}',
                backgroundColor: AppColors.kGetSnackBarColor.value);
          }
        },
      ).catchError(
        (onError) {
          apiLoading.value = false;
          Get.snackbar('Error!', onError.toString(),
              backgroundColor: AppColors.kGetSnackBarColor.value);
        },
      );
    } else {
      Get.snackbar('Alert', 'Enter valid Email/Phone!',
          backgroundColor: AppColors.kGetSnackBarColor.value);
    }
  }

  callResendOtpApi() {
    otpController.clear();
    otp.value = "";
    FocusManager.instance.primaryFocus?.unfocus();
    String text = emailController.text.trim();
    apiLoading.value = true;
    verifyUserNameApi(
      VerifyUserNameRequestData(
        companyDomain: 'regina',
        companyMainDomain: 'limor.us',
        cid: '',
        username: text,
        deviceToken: deviceToken,
      ),
    ).then(
      (response) {
        apiLoading.value = false;
        if (response.status == 1) {
          Get.snackbar('Success', '${response.message}',
              backgroundColor: AppColors.kGetSnackBarColor.value);
          otpController.setFocus(0);
        } else {
          Get.snackbar('Alert', '${response.message}',
              backgroundColor: AppColors.kGetSnackBarColor.value);
        }
      },
    ).catchError(
      (onError) {
        apiLoading.value = false;
        Get.snackbar('Error!', onError.toString(),
            backgroundColor: AppColors.kGetSnackBarColor.value);
      },
    );
  }

  calVerfyOtpApi() async {
    String username = emailController.text.trim();
    apiLoading.value = true;

    LocationResult<Position> result =
        await locationManager.getCurrentLocation();

    if (result.data != null) {
      verifyOtpApi(
        VerifyOtpRequest(
          username: username,
          otp: otp.value,
          latitude: result.data!.latitude,
          longitude: result.data!.longitude,
          deviceToken: deviceToken,
        ),
      ).then(
        (response) {
          apiLoading.value = false;
          if (response.status == 1) {
            kioskList = response.detail?.kioskList ?? [];
            supervisorId = response.detail?.supervisorId ?? 0;
            supervisorName = response.detail?.name ?? "";
            supervisorUniqueId = response.detail?.uniqueId ?? "";
            cid = response.detail?.companyId ?? 0;
            kioskList = response.detail?.kioskList ?? [];

            moveToCaptureImagePage();
          } else {
            Get.snackbar('Alert', '${response.message}',
                backgroundColor: AppColors.kGetSnackBarColor.value);
          }
        },
      ).catchError(
        (onError) {
          apiLoading.value = false;
          Get.snackbar('Error!', onError.toString(),
              backgroundColor: AppColors.kGetSnackBarColor.value);
        },
      );
    } else {
      apiLoading.value = false;
      Get.defaultDialog(
          title: "ERROR!",
          middleText:
              result.error ?? "Error occured while fetching current location");
    }
  }

  callAssignSupervisorApi(imageUrl) async {
    apiLoading.value = true;
    LocationResult<Position> result =
        await locationManager.getCurrentLocation();

    if (result.data != null) {
      assignSupervisorApi(
        AssignSupervisorRequest(
            kioskId: kioskId,
            supervisorId: supervisorId,
            cid: cid,
            latitude: result.data!.latitude,
            longitude: result.data!.longitude,
            accuracy: result.data!.altitude,
            deviceToken: deviceToken,
            photoUrl: imageUrl),
      ).then(
        (response) {
          apiLoading.value = false;
          if (response.status == 1) {
            var supervisorInfo = SupervisorInfo(
              supervisorId: "$supervisorId",
              supervisorName: supervisorName,
              supervisorUniqueId: supervisorUniqueId,
              cid: "$cid",
              kioskId: "$kioskId",
              kioskAddress: kioskAddress,
              kioskName: kioskName,
              phoneNumber: phoneNumber,
            );
            GetStorageController()
                .saveSupervisorInfo(supervisorInfo: supervisorInfo);
            GetStorageController()
                .saveNodeUrl(url: response.supervisorMonitorLogUrl ?? "");
            resetView();
            Get.offNamed(AppRoutes.dashboardPage);
          } else {
            Get.snackbar('Alert', '${response.message}',
                backgroundColor: AppColors.kGetSnackBarColor.value);
          }
        },
      ).catchError(
        (onError) {
          apiLoading.value = false;
          Get.snackbar('Error!', onError.toString(),
              backgroundColor: AppColors.kGetSnackBarColor.value);
        },
      );
    } else {
      apiLoading.value = false;
      Get.defaultDialog(
          title: "ERROR!",
          middleText:
              result.error ?? "Error occured while fetching current location");
    }
  }

  void moveToCaptureImagePage() async {
    final imageUrl = await Get.toNamed(AppRoutes.captureImagePage);
    if (imageUrl is String) {
      if (kioskList.isNotEmpty && kioskList.length == 1) {
        showKioskList.value = false;
        kioskId = kioskList.isNotEmpty ? (kioskList[0].kioskId ?? 0) : 0;
        kioskAddress = kioskList.isNotEmpty ? (kioskList[0].address ?? "") : "";
        kioskName = kioskList.isNotEmpty ? (kioskList[0].kioskName ?? "") : "";
        phoneNumber = kioskList.isNotEmpty ? (kioskList[0].phone ?? "") : "";
        callAssignSupervisorApi(imageUrl);
      } else {
        photoUrl.value = imageUrl;
        showKioskList.value = true;
        showKioskBottomSheet();
      }
    }
  }

  void showKioskBottomSheet() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.r),
            topRight: Radius.circular(12.r),
          ),
        ),
        margin: EdgeInsets.only(top: 70.h),
        child: Column(
          children: [_line(), _kioskList()],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _line() {
    return Container(
      width: 40.w,
      height: 3.h,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5.r),
      ),
    );
  }

  _kioskList() {
    return Expanded(
      child:
          // Obx(() =>
          kioskList.isEmpty
              ? Center(
                  child: SizedBox(
                    height: 280.h,
                    child: Center(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "No kiosk found!",
                              style:
                                  AppFontStyle.subHeading(color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: kioskList.length,
                  itemBuilder: (context, index) {
                    return _kioskListRow(context, index);
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.withOpacity(0.6),
                    thickness: 1,
                    height: 5,
                  ),
                ),
      // ),
    );
  }

  Widget _kioskListRow(BuildContext context, int index) {
    final kiosk = kioskList[index];
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        kioskId = kiosk.kioskId ?? 0;
        kioskAddress = kiosk.address ?? "";
        kioskName = kiosk.kioskName ?? "";
        phoneNumber = kiosk.phone ?? "";
        callAssignSupervisorApi(photoUrl.value);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h, left: 10.w, right: 10.w, top: 5.h),
        padding: EdgeInsets.symmetric(
          vertical: 8.h,
          horizontal: 10.w,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            Flexible(
              child: Text(
                "  ${kiosk.kioskName}",
                style: AppFontStyle.body(
                  size: AppFontSize.small.value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  resetView() {
    emailController.clear();
    otpController.clear();
    currentView.value = LoginViews.emailPage;
    kioskList = [];
    otp.value = "";
    supervisorId = 0;
    supervisorName = "";
    supervisorUniqueId = "";
    cid = 0;
    kioskAddress = "";
    kioskName = "";
    kioskId = 0;
    phoneNumber = "";
  }

  void checkCameraPermission() async {
    var status = await Permission.camera.status;
    printLogs("CAMERA CHECK STATUS CHECKER : $status");
    if (status != PermissionStatus.granted) {
      status = await requestCameraPermission();
      _camePermissionAlert();
    }
  }

  Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.request();
    printLogs("CAMERA REQUEST STATUS CHECKER : $status");
    return status;
  }
}

void _camePermissionAlert() {
  showDefaultDialog(
    context: Get.context!,
    title: "Alert",
    message: "You want to allow the camera to continue with app.",
    isTwoButton: true,
    acceptBtnTitle: "Allow",
    acceptAction: () {
      openAppSettings();
    },
    cancelBtnTitle: "No",
    cancelAction: () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');

    },
  );
}

void openAppSettings() async {
  const url = 'app-settings:';
  if (Platform.isIOS) {
    // Use platform-specific code to open iOS settings
    Process.run('open', ['-a', 'App-Prefs:']);
  }

  else {
    print('Could not open app settings.');
  }
}






enum LoginViews { emailPage, otpPage }
