import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/location_queue/data/add_driver_data.dart';
import 'package:rsl_supervisor/location_queue/data/driver_list_data.dart';
import 'package:rsl_supervisor/location_queue/data/driver_queue_position_data.dart';
import 'package:rsl_supervisor/location_queue/data/save_booking_data.dart';
import 'package:rsl_supervisor/location_queue/service/location_queue_service.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/utils/helpers/alert_helpers.dart';

import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../widgets/car_search_widget.dart';
import '../data/search_driver_data.dart';

class LocationQueueController extends GetxController {
  SupervisorInfo supervisorInfo = SupervisorInfo();
  RxList<DriverDetails> driverList = <DriverDetails>[].obs;
  // RxList<DriverDetails> secondaryDriverList = <DriverDetails>[].obs;
  RxList<DriverDetails> waitingDriverList = <DriverDetails>[].obs;

  RxList<DriverDetails> filteredDriverList = <DriverDetails>[].obs;
  // RxList<DriverDetails> filteredSecondaryDriverList = <DriverDetails>[].obs;
  RxList<DriverDetails> filteredWaitingDriverList = <DriverDetails>[].obs;

  Timer? _timer;
  RxBool showLoader = false.obs;
  RxBool showBtnLoader = false.obs;
  RxBool showDrverSearchLoader = false.obs;
  RxBool showDriverListLoader = false.obs;
  RxBool isReorder = false.obs;
  RxList<DriverDetails> driverSearchList = <DriverDetails>[].obs;
  RxString driverSearchText = "".obs;
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  final TextEditingController referenceNumberController =
      TextEditingController();

  RxString countryCode = "971".obs;
  DriverDetails selectedDriver = DriverDetails();
  int fixedMeter = 1;
  final formKey = GlobalKey<FormState>();
  RxBool showQrCode = false.obs;
  RxString qrData = "".obs;
  RxString qrMessage = "".obs;
  RxString searchText = ''.obs;
  RxBool isDriverHighLighted = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  final scrollController = ScrollController();

  double dropLatitude = 0.0, dropLongitude = 0.0;
  String fare = "", dropAddress = "", zoneFareApplied = "0";
  int fromDashboard = 1;
  bool shiftStatus = true;

  int mainCount = 0;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    shiftStatus = await GetStorageController().getShiftStatus();
    callDriverListApi(isOninit: true);
    startTimer();
  }

  void goBack() {
    stopTimer();
    Get.back();
  }

  void startTimer() {
    stopTimer();
    const timerDuration = Duration(seconds: 10);

    _timer = Timer.periodic(
      timerDuration,
      (Timer timer) {
        callDriverListApi();
      },
    );
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  void callDriverListApi({bool? isOninit}) async {
    if (isOninit == true) {
      showDriverListLoader.value = true;
    } else {
      showDriverListLoader.value = false;
    }
    driverListApi(
      DriverListRequest(
        supervisorId: supervisorInfo.supervisorId,
        cid: supervisorInfo.cid,
        kioskId: supervisorInfo.kioskId,
      ),
    ).then(
      (response) {
        showDriverListLoader.value = false;
        if ((response.status ?? 0) == 1) {
          driverList.value = response.driverList?.mainDriverDetails ?? [];
          filteredDriverList.value =
              response.driverList?.mainDriverDetails ?? [];
          filteredDriverList.refresh();

/*          secondaryDriverList.value =
              response.driverList?.waitingDriverDetails ?? [];
          filteredSecondaryDriverList.value =
              response.driverList?.waitingDriverDetails ?? [];
          filteredSecondaryDriverList.refresh();*/

          waitingDriverList.value =
              response.driverList?.outWaitingDriverDetails ?? [];
          filteredWaitingDriverList.value =
              response.driverList?.outWaitingDriverDetails ?? [];
          filteredWaitingDriverList.refresh();
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
        showDriverListLoader.value = false;
        if (isOninit ?? false) {
          showSnackBar(
            title: 'Error',
            msg: error.toString(),
          );
        }
      },
    );
  }

  void callUpdateDriverQueueApi(
      {required List<int> driverArray,
      required List<int> secondaryDriverArray,
      required driverID,
      required type,
      required positionIndex,
      required queueType}) async {
    printLogs("driverArray $driverArray $secondaryDriverArray");
    showLoader.value = true;
    updateDriverQueueApi(
      UpdateDriverQueueRequest(
          driverArray: driverArray,
          secondaryDriverArray: secondaryDriverArray,
          cid: supervisorInfo.cid,
          kioskId: supervisorInfo.kioskId,
          driverID: driverID.toString(),
          type: type,
          positionIndex: positionIndex,
          queueType: queueType),
    ).then(
      (response) {
        showLoader.value = false;
        if ((response.status ?? 0) == 1) {
          /* driverList.value = response.driverList?.mainDriverDetails ?? [];
          filteredDriverList.value =
              response.driverList?.mainDriverDetails ?? [];
          filteredDriverList.refresh();

          secondaryDriverList.value =
              response.driverList?.waitingDriverDetails ?? [];
          filteredSecondaryDriverList.value =
              response.driverList?.waitingDriverDetails ?? [];
          filteredSecondaryDriverList.refresh();

          waitingDriverList.value =
              response.driverList?.outWaitingDriverDetails ?? [];
          waitingDriverList.value =
              response.driverList?.outWaitingDriverDetails ?? [];
          filteredWaitingDriverList.refresh();*/
          callDriverListApi();
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
          callDriverListApi();
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

  void scrollToItem(String query) {
    if (query.isEmpty) {
      filteredDriverList.value = driverList;
      filteredDriverList.refresh();
/*      filteredSecondaryDriverList.value = secondaryDriverList;
      filteredSecondaryDriverList.refresh();*/
      filteredWaitingDriverList.value = waitingDriverList;
      filteredWaitingDriverList.refresh();
      return;
    }

    final matchingItemIndexDriverName = filteredDriverList.indexWhere((item) =>
        (item.driverName ?? "").toLowerCase().contains(query.toLowerCase()));
    final matchingItemIndexTaxiNo = filteredDriverList.indexWhere((item) =>
        (item.taxiNo ?? "").toLowerCase().contains(query.toLowerCase()));
    if (matchingItemIndexDriverName != -1) {
      scrollController.animateTo(
        matchingItemIndexDriverName * filteredDriverList.length.toDouble() * 10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (matchingItemIndexTaxiNo != -1) {
      scrollController.animateTo(
        matchingItemIndexTaxiNo * filteredDriverList.length.toDouble() * 10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

  /*  final matchingItemIndexDriverName1 = filteredSecondaryDriverList.indexWhere(
        (item) => (item.driverName ?? "")
            .toLowerCase()
            .contains(query.toLowerCase()));
    final matchingItemIndexTaxiNo1 = filteredSecondaryDriverList.indexWhere(
        (item) =>
            (item.taxiNo ?? "").toLowerCase().contains(query.toLowerCase()));
    if (matchingItemIndexDriverName1 != -1) {
      scrollController.animateTo(
        matchingItemIndexDriverName1 *
            filteredSecondaryDriverList.length.toDouble() *
            10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (matchingItemIndexTaxiNo1 != -1) {
      scrollController.animateTo(
        matchingItemIndexTaxiNo1 *
            filteredSecondaryDriverList.length.toDouble() *
            10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }

   */

    final matchingItemIndexDriverName2 = filteredWaitingDriverList.indexWhere(
        (item) => (item.driverName ?? "")
            .toLowerCase()
            .contains(query.toLowerCase()));
    final matchingItemIndexTaxiNo2 = filteredWaitingDriverList.indexWhere(
        (item) =>
            (item.taxiNo ?? "").toLowerCase().contains(query.toLowerCase()));
    if (matchingItemIndexDriverName2 != -1) {
      scrollController.animateTo(
        matchingItemIndexDriverName2 *
            filteredWaitingDriverList.length.toDouble() *
            10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else if (matchingItemIndexTaxiNo2 != -1) {
      scrollController.animateTo(
        matchingItemIndexTaxiNo2 *
            filteredWaitingDriverList.length.toDouble() *
            10,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  bool highlightedColor(item) {
    if (searchText.isNotEmpty) {
      var isHighLighted = (item.driverName ?? "")
              .toLowerCase()
              .contains(searchText.toLowerCase()) ||
          (item.taxiNo ?? "").toLowerCase().contains(searchText.toLowerCase());
      printLogs("highlightedColor $isHighLighted");
      isDriverHighLighted.value = true;
      return isHighLighted;
    }
    isDriverHighLighted.value = false;
    return false;
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
    referenceNumberController.text = "";
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
    referenceNumberController.text = "";
    selectedDriver = DriverDetails();
    fixedMeter = 1;
    qrData.value = "";
    qrMessage.value = "";
    Get.offAllNamed(AppRoutes.dashboardPage);
  }

  void goToDispatch() {
    amountController.text = "";
    nameController.text = "";
    phoneController.text = "";
    emailController.text = "";
    messageController.text = "";
    referenceNumberController.text = "";
    selectedDriver = DriverDetails();
    fixedMeter = 1;
    qrData.value = "";
    qrMessage.value = "";
/*
    Get.offNamed(AppRoutes.dispatchPage);
*/
  Get.back();
  }

  void submitAction() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
      if (formKey.currentState!.validate()) {
        final amount = amountController.text.trim();
        final name = nameController.text.trim();
        final phone = phoneController.text.trim();
        final email = emailController.text.trim();
        final message = messageController.text.trim();
        final referenceNumber = referenceNumberController.text.trim();

        if (fixedMeter == 1 && amount.isEmpty) {
          showSnackBar(title: "Alert", msg: "Enter valid fare");
        } else if (email.isNotEmpty && !GetUtils.isEmail(email)) {
          showSnackBar(title: "Alert", msg: "Enter valid email id");
        } else {
          showBtnLoader.value = true;
          saveBookingApi(SaveBookingRequest(
                  driverId: selectedDriver.driverId,
                  dropLatitude: dropLatitude,
                  dropLongitude: dropLongitude,
                  dropPlace: dropAddress,
                  fixedMeter: fixedMeter,
                  kioskFare: amount,
                  kioskId: supervisorInfo.kioskId,
                  motorModel: selectedDriver.modelId,
                  pickupTime: "",
                  pickupplace: supervisorInfo.kioskAddress,
                  tripMessage: message,
                  supervisorName: supervisorInfo.supervisorName,
                  supervisorId: supervisorInfo.supervisorId,
                  approxFare: fare,
                  zoneFareApplied: int.parse(zoneFareApplied),
                  supervisorUniqueId: supervisorInfo.supervisorUniqueId,
                  cid: supervisorInfo.cid,
                  name: name,
                  countryCode: '+${countryCode.value}',
                  mobileNo: phone,
                  email: email,
                  referenceNumber: referenceNumber))
              .then(
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

  void showAddCarDialog() {
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
      driverSearchText.value = "";
      callSearchDriverApi();

      Get.bottomSheet(
        Obx(
          () => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            margin: EdgeInsets.only(top: 70.h),
            child: CarSearchView(
              onChanged: (text) {
                driverSearchText.value = text;
                callSearchDriverApi();
              },
              showLoader: showDrverSearchLoader.value,
              listData: driverSearchList
                  .map((element) =>
                      ("${element.taxiNo ?? ""} - ${element.driverName ?? ""}"))
                  .toList(),
              onSelect: (index) {
                Get.back();
                showAddDriverAlert(driverDetails: driverSearchList[index]);
              },
              noDataText: "No cars found!",
            ),
          ),
        ),
        isScrollControlled: true,
      );
    }
  }

  void reorderFirstList(int oldIndex, int newIndex) {
    mainCount = 1;
    printLogs("TAG:reorder first");
    var driverArray = filteredDriverList.toList();

    // If list is empty or oldIndex is out of bounds, return early
    if (driverArray.isEmpty || oldIndex >= driverArray.length || oldIndex < 0) {
      return;
    }

    // Adjust newIndex if it's greater than oldIndex (to account for the item removal)
    if (newIndex > oldIndex) {
      newIndex--;
    }

    newIndex = newIndex.clamp(0, driverArray.length - 1);

    printLogs(
        "Reordering in first list: Old index: $oldIndex, New index: $newIndex");

    final driver = driverArray.removeAt(oldIndex);
    driverArray.insert(newIndex, driver);

    filteredDriverList.assignAll(driverArray);
    filteredDriverList.refresh();

    // Call the API to update the driver queue positions
    callUpdateDriverQueueApi(
      driverID: driver.driverId,
      type: 2,
      driverArray: filteredDriverList.map((e) => e.driverId ?? 0).toList(),
      secondaryDriverArray:
          [],
      queueType: 1,
      positionIndex: newIndex,
    );
  }

//   void reorderSecondList(int oldIndex, int newIndex) {
//     printLogs("TAG:reorder second");
//     var driverArray = filteredSecondaryDriverList.toList();
//
//     // If list is empty or oldIndex is out of bounds, return early
//     if (driverArray.isEmpty || oldIndex >= driverArray.length || oldIndex < 0)
//       return;
//
//     if (newIndex > oldIndex) {
//       newIndex--;
//     }
//
//     newIndex = newIndex.clamp(
//         0, driverArray.length - 1); // Clamp newIndex within valid range
//
//     printLogs(
//         "Reordering in second list: Old index: $oldIndex, New index: $newIndex");
//
//     final driver = driverArray.removeAt(oldIndex);
//     driverArray.insert(newIndex, driver);
//
// /*    filteredSecondaryDriverList.assignAll(driverArray);
//     filteredSecondaryDriverList.refresh(); */// Refresh second list
//
//     callUpdateDriverQueueApi(
//         driverID: driver.driverId,
//         type: 2,
//         driverArray: filteredDriverList.map((e) => e.driverId ?? 0).toList(),
//         secondaryDriverArray:
//             [],
//         queueType: 2,
//         positionIndex: newIndex);
//   }

  // void moveFromFirstToSecondList(int oldIndex, int newIndex) {
  //   mainCount = 0;
  //
  //   printLogs("TAG:reorder first to second");
  //   var firstList = filteredDriverList.toList();
  //   var secondList = filteredSecondaryDriverList.toList();
  //
  //   // If first list is empty or oldIndex is out of bounds, return early
  //   if (firstList.isEmpty || oldIndex >= firstList.length || oldIndex < 0) {
  //     return;
  //   }
  //
  //   newIndex = newIndex.clamp(
  //       0, secondList.length); // Clamp newIndex within valid range
  //
  //   printLogs(
  //       "Moving from first to second list: Old index: $oldIndex, New index: $newIndex");
  //
  //   final driver =
  //       firstList.removeAt(oldIndex); // Capture the driver being moved
  //   secondList.insert(newIndex, driver); // Insert driver into the second list
  //
  //   filteredDriverList.assignAll(firstList);
  //   filteredDriverList.refresh(); // Refresh first list
  //   filteredSecondaryDriverList.assignAll(secondList);
  //   filteredSecondaryDriverList.refresh(); // Refresh second list
  //
  //   callUpdateDriverQueueApi(
  //       driverID: driver.driverId,
  //       type: 1,
  //       driverArray: filteredDriverList.map((e) => e.driverId ?? 0).toList(),
  //       secondaryDriverArray:
  //           filteredSecondaryDriverList.map((e) => e.driverId ?? 0).toList(),
  //       positionIndex: newIndex,
  //       queueType: 1);
  //
  //   printLogs(
  //       "TAG:Moved driver ID: ${driver.driverId ?? 'Unknown'} from first list to second list");
  // }

//   void moveFromSecondToFirstList(int oldIndex, int newIndex) {
//     printLogs("TAG:reorder second to first");
//     var firstList = filteredDriverList.toList();
//     var secondList = filteredSecondaryDriverList.toList();
//
//     // If second list is empty or oldIndex is out of bounds, return early
//     if (secondList.isEmpty || oldIndex >= secondList.length || oldIndex < 0)
//       return;
//
//     newIndex = newIndex.clamp(
//         0, firstList.length); // Clamp newIndex within valid range
//
//     // Print old and new index
//     printLogs(
//         "Moving from second to first list: Old index: $oldIndex, New index: $newIndex");
//
//     final driver = secondList.removeAt(oldIndex);
//     firstList.insert(newIndex, driver);
//
//     filteredDriverList.assignAll(firstList);
//     filteredDriverList.refresh(); // Refresh first list
// /*    filteredSecondaryDriverList.assignAll(secondList);
//     filteredSecondaryDriverList.refresh();*/
//   }

  int generateRandomInteger(int max) {
    var random = Random();
    return random.nextInt(max); // Generates a random integer from 0 to max-1
  }
}
