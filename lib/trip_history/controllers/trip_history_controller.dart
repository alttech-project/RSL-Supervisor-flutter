import 'dart:convert';
import 'dart:ffi';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/trip_history/data/cancel_trip_data.dart';
import 'package:rsl_supervisor/trip_history/data/export_pdf_data.dart';
import 'package:rsl_supervisor/trip_history/data/trip_history_data.dart';
import 'package:rsl_supervisor/trip_history/service/trip_history_services.dart';

import '../../routes/app_routes.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';

class TripHistoryController extends GetxController {
  SupervisorInfo supervisorInfo = SupervisorInfo();
  RxList<TripDetails> tripList = <TripDetails>[].obs;
  RxBool showLoader = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  TextEditingController tripIdController = TextEditingController();
  TextEditingController carNoController = TextEditingController();
  TextEditingController farEditController = TextEditingController();
  TextEditingController commentAddController = TextEditingController();


  RxInt dispatchedTrips = 0.obs;
  RxInt cancelledTrips = 0.obs;
  RxBool showBtnLoader = false.obs;
   Rx<TripDetails>tripDetail=TripDetails().obs;
  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    fromDate.value = DateTime.now().subtract(const Duration(days: 1));
    toDate.value = DateTime.now();
    callTripHistoryApi();
  }

  void goBack() {
    Get.back();
  }

  void callTripHistoryApi() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showLoader.value = true;
    tripHistoryApi(
      TripHistoryRequest(
        kioskId: supervisorInfo.kioskId,
        driverName: carNoController.text,
        tripId: tripIdController.text,
        from: DateFormat('yyyy-MM-d HH:mm').format(fromDate.value),
        to: DateFormat('yyyy-MM-d HH:mm').format(toDate.value),
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          tripList.value = response.details ?? [];
          dispatchedTrips.value = response.dispatchedTripCount ?? 0;
          cancelledTrips.value = response.cancelledTripCount ?? 0;
        } else {
          tripList.value = [];
          dispatchedTrips.value = 0;
          cancelledTrips.value = 0;
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
        }
        tripList.refresh();
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        tripList.value = [];
        dispatchedTrips.value = 0;
        cancelledTrips.value = 0;
        tripList.refresh();
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void callExportPdfApi() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showBtnLoader.value = true;
    exportPdfApi(
      ExportPdfRequest(
        kioskId: supervisorInfo.kioskId,
        driverId: carNoController.text,
        tripId: tripIdController.text,
        from: DateFormat('yyyy-MM-d HH:mm').format(fromDate.value),
        to: DateFormat('yyyy-MM-d HH:mm').format(toDate.value),
        cid: supervisorInfo.cid,
      ),
    ).then(
      (response) {
        showBtnLoader.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Alert",
          message: response.message ?? "",
        );
      },
    ).onError(
      (error, stackTrace) {
        showBtnLoader.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Error",
          message: error.toString(),
        );
      },
    );
  }

  String displayTimeFormatter(String pickupTime) {
    String convertedTime = "";
    try {
      DateTime dateTime = DateTime.parse(pickupTime);
      convertedTime = DateFormat('MMM d, y h:mm a').format(dateTime);
    } catch (e) {
      convertedTime = pickupTime;
    }

    return convertedTime;
  }

  void showCancelTripAlert(int tripId) {
    showDefaultDialog(
      context: Get.context!,
      title: "Alert",
      message: "Are you sure you want to cancel this trip?",
      isTwoButton: true,
      acceptBtnTitle: "Yes, Cancel",
      cancelBtnTitle: "No",
      acceptAction: () {
        _callCancelTripApi(tripId);
      },
    );
  }

  void _callCancelTripApi(int tripId) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showLoader.value = true;
    cancelTripApi(
      CancelTripRequest(
        kioskId: supervisorInfo.kioskId,
        cid: supervisorInfo.cid,
        cancelPwd: generateMd5("123456"),
        cancelMessage: "Test cancel",
        tripId: tripId,
      ),
    ).then(
      (response) {
        showLoader.value = false;
        if (response.status == 1) {
          showSnackBar(
            title: 'Success',
            msg: response.message ?? "Trip cancelled successfully",
          );
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong",
          );
        }
        callTripHistoryApi();
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Error",
          message: error.toString(),
        );
      },
    );
  }
  void callEditFareApi(String? comments,int? fare,int? tripId) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showLoader.value = true;
    editFareApi(
      EditFareRequestData(
       comments: comments,
        fare: fare,
        tripId: tripId,
      ),
    ).then(
          (response) {
        showLoader.value = false;
        if (response.status == 1) {
          showSnackBar(
            title: 'Success',
            msg: response.details ?? "Trip fare updated successfully",
          );
          farEditController.text = "";
          commentAddController.text = "";
          removeRoutesUntil( routeName: AppRoutes.tripHistoryPage);

        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong",
          );
        }
        callTripHistoryApi();
      },
    ).onError(
          (error, stackTrace) {
        showLoader.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Error",
          message: error.toString(),
        );
      },
    );
  }
  String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  void getTripDetailFromList({required TripDetails detail}) {
tripDetail.value=detail;
tripDetail.refresh();
  }
  void fareSumbitValidation() {
    if (farEditController.text == "") {
      showSnackBar(
          title: "Information", msg: "Enter Your Edited Fare");
    } else if (commentAddController.text == "") {
      showSnackBar(
          title: "Information", msg: "Enter Your Comments");
    } else {
      callEditFareApi(
          commentAddController.text.trim(),
          int.parse(farEditController.text.trim()),
          int.parse(tripDetail.value.tripId ?? ''));
    }
  }
}
void removeRoutesUntil({String? routeName}) {
  printLogs("hi Deepak previous route : ${routeName}");
  bool condition(Route<dynamic>? route) {
    return route?.settings.name == '${routeName}';
  }
  Get.until(condition);
}
