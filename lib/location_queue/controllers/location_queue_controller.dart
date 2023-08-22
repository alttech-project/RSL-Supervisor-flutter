import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/data/add_driver_response.dart';
import 'package:rsl_supervisor/location_queue/data/driver_list_response.dart';
import 'package:rsl_supervisor/location_queue/data/driver_queue_position_response.dart';
import 'package:rsl_supervisor/location_queue/data/save_booking_response.dart';
import 'package:rsl_supervisor/location_queue/service/location_queue_service.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/utils/helpers/alert_helpers.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/search_driver_response.dart';

class LocationQueueController extends GetxController {
  SupervisorInfo supervisorInfo = SupervisorInfo();
  RxList<DriverDetails> driverList = <DriverDetails>[].obs;
  Timer? _timer;
  RxBool showLoader = false.obs;
  RxBool showBtnLoader = false.obs;
  RxBool showDrverSearchLoader = false.obs;
  RxBool isReorder = false.obs;
  RxList<DriverDetails> driverSearchList = <DriverDetails>[].obs;
  RxString driverSearchText = "".obs;
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  RxString countryCode = "971".obs;
  DriverDetails selectedDriver = DriverDetails();
  int fixedMeter = 1;
  final formKey = GlobalKey<FormState>();
  RxBool showQrCode = false.obs;
  RxString qrData = "".obs;
  RxString qrMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    _callDriverListApi(isOninit: true);
    startTimer();
  }

  void goBack() {
    stopTimer();
    Get.back();
  }

  void startTimer() {
    stopTimer();
    const timerDuration = Duration(seconds: 7);

    _timer = Timer.periodic(
      timerDuration,
      (Timer timer) {
        _callDriverListApi();
      },
    );
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  void _callDriverListApi({bool? isOninit}) async {
    driverListApi(
      DriverListRequest(
        supervisorId: supervisorInfo.supervisorId,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        if ((response.status ?? 0) == 1) {
          driverList.value = response.driverList ?? [];
          driverList.refresh();
        } else if ((response.status ?? 0) == -4) {
          stopTimer();
          GetStorageController().removeSupervisorInfo();
          Get.offAllNamed(AppRoutes.loginPage);
        } else {
          if (isOninit ?? false) {
            showSnackBar(
              title: 'Alert',
              msg: response.message ?? "Something went wrong...",
            );
          }
        }
      },
    ).onError(
      (error, stackTrace) {
        if (isOninit ?? false) {
          showSnackBar(
            title: 'Error',
            msg: error.toString(),
          );
        }
      },
    );
  }

  void callUpdateDriverQueueApi({required List<int> driverArray}) async {
    showLoader.value = true;
    updateDriverQueueApi(
      UpdateDriverQueueRequest(
        driverArray: driverArray,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          driverList.value = response.driverList ?? [];
          driverList.refresh();
        } else {
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void callDriverQueuePositionApi(
      {required DriverDetails driverDetails}) async {
    showLoader.value = true;
    driverQueuePositionApi(
      DriverQueuePositionRequest(
        driverId: driverDetails.driverId,
        modelId: driverDetails.modelId,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          if ((driverDetails.currentTripId ?? "").isNotEmpty) {
            showSnackBar(
              title: 'Success',
              msg: response.message ?? "",
            );
          } else {
            selectedDriver = driverDetails;
            _moveToFareSelectionPage();
          }
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void showAddDriverAlert({required DriverDetails driverDetails}) {
    showDefaultDialog(
      context: Get.context!,
      title: "Alert!",
      message: "Do you want to add this car to the queue?",
      acceptAction: () {
        _callAddDriverApi(driverDetails: driverDetails, type: 1);
      },
      isTwoButton: true,
      acceptBtnTitle: "Yes",
      cancelBtnTitle: "Cancel",
    );
  }

  void showRemoveDriverAlert({required DriverDetails driverDetails}) {
    showDefaultDialog(
      context: Get.context!,
      title: "Alert!",
      message: "Do you want to remove this car from the queue?",
      acceptAction: () {
        _callAddDriverApi(driverDetails: driverDetails, type: 2);
      },
      isTwoButton: true,
      acceptBtnTitle: "Yes",
      cancelBtnTitle: "Cancel",
    );
  }

  void _callAddDriverApi(
      {required DriverDetails driverDetails, required int type}) async {
    showLoader.value = true;
    addDriverApi(
      AddDriverRequest(
        driverId: driverDetails.driverId,
        modelId: driverDetails.modelId,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
        requestType: "$type",
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          showSnackBar(
            title: 'Success',
            msg: response.message ?? "Something went wrong...",
          );
          _callDriverListApi();
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void callSearchDriverApi() async {
    showDrverSearchLoader.value = true;
    searchDriverApi(
      SearchDriverRequest(
        keyword: driverSearchText.value,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        showDrverSearchLoader.value = false;
        if ((response.status ?? 0) == 1) {
          driverSearchList.value = response.details ?? [];
        } else {
          driverSearchList.value = [];
          printLogs(response.message ?? "");
        }
        driverSearchList.refresh();
      },
    ).onError(
      (error, stackTrace) {
        showDrverSearchLoader.value = false;
        driverSearchList.value = [];
        driverSearchList.refresh();
        printLogs(error.toString());
      },
    );
  }

  void _moveToFareSelectionPage() {
    stopTimer();
    Get.toNamed(AppRoutes.fareSelectionPage);
  }

  void goBackfromFareSelection() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    amountController.text = "";
    nameController.text = "";
    phoneController.text = "";
    emailController.text = "";
    messageController.text = "";
    selectedDriver = DriverDetails();
    fixedMeter = 1;
    Get.back();
    startTimer();
  }

  void goToDashboard() {
    amountController.text = "";
    nameController.text = "";
    phoneController.text = "";
    emailController.text = "";
    messageController.text = "";
    selectedDriver = DriverDetails();
    fixedMeter = 1;
    qrData.value = "";
    qrMessage.value = "";
    Get.offAllNamed(AppRoutes.dashboardPage);
  }

  void submitAction() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (formKey.currentState!.validate()) {
      final amount = amountController.text.trim();
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();
      final message = messageController.text.trim();

      if (email.isNotEmpty && !GetUtils.isEmail(email)) {
        showSnackBar(title: "Alert", msg: "Enter valid email id");
      } else {
        showBtnLoader.value = true;
        saveBookingApi(
          SaveBookingRequest(
            driverId: selectedDriver.driverId,
            fixedMeter: fixedMeter,
            kioskFare: amount,
            kioskId: supervisorInfo.kioskId,
            motorModel: selectedDriver.modelId,
            pickupTime: "",
            pickupplace: supervisorInfo.kioskAddress,
            tripMessage: message,
            supervisorName: supervisorInfo.supervisorName,
            supervisorId: supervisorInfo.supervisorId,
            zoneFareApplied: 0,
            supervisorUniqueId: supervisorInfo.supervisorUniqueId,
            cid: supervisorInfo.cid,
            name: name,
            countryCode: countryCode.value,
            mobileNo: phone,
            email: email,
          ),
        ).then(
          (response) {
            showBtnLoader.value = false;
            if (response.status == 1) {
              qrData.value = response.trackUrl ?? "";
              qrMessage.value = response.message ?? "";
              showQrCode.value = true;
            } else {
              showDefaultDialog(
                context: Get.context!,
                title: "Alert",
                message: response.message ?? "Something went wrong...",
              );
            }
          },
        ).onError(
          (error, stackTrace) {
            showBtnLoader.value = false;
            showDefaultDialog(
              context: Get.context!,
              title: "Alert",
              message: error.toString(),
            );
          },
        );
      }
    }
  }
}
