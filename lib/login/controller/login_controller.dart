import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rsl_supervisor/login/data/assign_supervisor_api_data.dart';
import 'package:rsl_supervisor/login/data/verify_otp_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import '../../network/app_config.dart';
import '../../quickTrip/controllers/quick_trip_controller.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/app_info.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';
import '../../views/controller/splash_controller.dart';
import '../data/verify_user_api_data.dart';
import '../service/login_services.dart';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  RxString appVersion = "".obs;
  RxString appBuildNumber = "".obs;
  RxString apk = "".obs;
  var showAppVersion = true.obs;
  RxInt enableSignUp = 0.obs;


  @override
  Future<void> onInit() async {
    super.onInit();
    currentView.value = LoginViews.emailPage;
    enableSignUp.value = await GetStorageController().getShowSignUp();
    // getDeviceToken();
    _getAppInfo();
    // await requestCameraPermission();
  }

  void _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    appBuildNumber.value = packageInfo.buildNumber;
    apk.value =
    AppConfig.currentEnvironment == Environment.demo ? "Demo" : "Live";
  }

/*  getDeviceToken() async {
    deviceToken = await GetStorageController().getDeviceToken();
  }*/

  onBackPressed() {
    if (apiLoading.value) return;
    if (currentView.value == LoginViews.otpPage) {
      currentView.value = LoginViews.emailPage;
    } else {
      SystemNavigator.pop();
    }
  }

  void hideAppVersion(bool hide) {
    showAppVersion.value = hide;
  }

  checkValidationAndCallApi() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    String text = emailController.text.trim();
    if (GetUtils.isEmail(text)) {
      apiLoading.value = true;
      verifyUserNameApi(
        VerifyUserNameRequestData(
          companyDomain: 'regina',
          companyMainDomain: 'limor.us',
          cid: '',
          username: text,
          deviceToken: await GetStorageController().getDeviceToken(),
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
      Get.snackbar('Alert', 'Enter valid Email!',
          backgroundColor: AppColors.kGetSnackBarColor.value);
    }
  }

  callResendOtpApi() async {
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
        deviceToken: await GetStorageController().getDeviceToken(),
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

  calVerifyOtpApi() async {
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
          deviceToken: await GetStorageController().getDeviceToken(),
        ),
      ).then(
            (response) async {
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
            deviceToken: await GetStorageController().getDeviceToken(),
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

            var corporateInfo = CorporateInfo(
              corporateName: response.corporateName,
              corporateEmail: response.corporateEmail,
              corporatePhoneNumber: response.corporatePhoneNumber,
              corporateCountryCode: response.corporateCountryCode,
              corporateLocation: response.corporateLocation,
              corporateLat: response.corporateLat,
              corporateLong: response.corporateLong,
            );

            GetStorageController()
                .saveCorporateInfo(corporateInfo: corporateInfo);

            GetStorageController()
                .saveSupervisorInfo(supervisorInfo: supervisorInfo);

            GetStorageController()
                .saveNodeUrl(url: response.supervisorMonitorLogUrl ?? "");

            GetStorageController()
                .saveCorporateId(id: response.corporateId.toString() ?? "0");

            GetStorageController()
                .saveCorporateId(id: response.corporateId.toString() ?? "0");

            GetStorageController()
                .saveQuickTripEnableType(type: response.quickTrip ?? 0);

            GetStorageController()
                .saveCustomDropOffEnableType(type: response.customDropOff ?? 0);

            GetStorageController()
                .saveDiscountValue(type: response.quickTripDiscount);

            if (response.locationType != null && response.locationType == 1) {
              GetStorageController()
                  .saveLocationType(type: LocationType.GENERAL.toString());
              GetStorageController()
                  .saveEditFare(type: response.enableEditFare ?? 0);
            } else {
              GetStorageController()
                  .saveLocationType(type: LocationType.HOTEL.toString());
              GetStorageController().saveEditFare(type: 0);

            }
            resetView();
            Get.offAllNamed(AppRoutes.dashboardPage);
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
          children: [_line(), _showTitle(), _kioskList()],
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

  Widget _showTitle() {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.only(top: 8.h, bottom: 10.h),
            child: Text(
              'Select Kiosk',
              style:
              AppFontStyle.subHeading(color: AppColors.kPrimaryColor.value),
            ))
      ],
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
  void navigateSignUpPage() {
    Get.toNamed(
      AppRoutes.signUpPage,
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

  void resetView() {
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
}

bool isIOS() {
  return Platform.isIOS;
}

void _cameraPermissionAlert() {
  final SplashController controller = Get.find<SplashController>();
  if (controller.isSplashScreen.value == false) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text("Camera Permission Required"),
          content: const Text(
              "You need to allow camera access for this app to function properly."),
          actions: <Widget>[
            TextButton(
              child: Text(
                  style: TextStyle(color: AppColors.kPrimaryColor.value),
                  "Cancel"),
              onPressed: () {
                exit(0);
              },
            ),
            TextButton(
              child: Text(
                  style: TextStyle(color: AppColors.kPrimaryColor.value),
                  "Open Settings"),
              onPressed: () {
                openAppSettings();

                Future.delayed(Duration(seconds: 1), () {
                  exit(0);
                });
              },
            ),
          ],
        );
      },
    );
  } else {
    Future.delayed(
      const Duration(seconds: 2),
          () async {
        _cameraPermissionAlert();
      },
    );
  }
}

void openAppSettings() async {
  AppSettings.openAppSettings();
}

enum LoginViews { emailPage, otpPage }
