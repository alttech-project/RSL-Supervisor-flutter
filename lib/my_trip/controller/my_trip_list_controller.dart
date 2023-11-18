import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../trip_history/data/cancel_trip_data.dart';
import '../../trip_history/data/trip_history_map_data.dart';
import '../../trip_history/service/trip_history_services.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/my_trip_list_data.dart';
import '../data/my_trip_list_cancel_trip_data.dart';
import '../data/my_trip_list_export_pdf_data.dart';
import '../service/my_trip_list_service.dart';
import 'dart:ui' as ui;

class MyTripListController extends GetxController {
  SupervisorInfo supervisorInfo = SupervisorInfo();
  RxList<ListTripDetails> tripList = <ListTripDetails>[].obs;
  RxList<ListTripDetails> tripListOngoing = <ListTripDetails>[].obs;
  RxList<ListTripDetails> existingDataList = <ListTripDetails>[].obs;

  RxBool showLoader = false.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  TextEditingController tripIdController = TextEditingController();
  TextEditingController carNoController = TextEditingController();
  TextEditingController farEditController = TextEditingController();
  TextEditingController commentAddController = TextEditingController();
  RxList<MapDatas> mapdatas = <MapDatas>[].obs;
  RxList<Marker> markers = <Marker>[].obs;
  BitmapDescriptor? icons;
  RxInt dispatchedTrips = 0.obs;
  RxInt cancelledTrips = 0.obs;
  RxBool showBtnLoader = false.obs;
  Rx<ListTripDetails> selectedTripDetail = ListTripDetails().obs;
  RxBool isPasswordVisible = false.obs;
  TextEditingController messageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  RxInt currentPage = 1.obs;
  RxInt limit = 10.obs;
  RxInt totalCount = 10.obs;
  RxInt totalCountOngoing = 10.obs;
  RxBool pageNationLoader = false.obs;


  @override
  void onInit() {
    super.onInit();
    _scrollListenerTripList();
    _getUserInfos();
  }

  void _scrollListenerTripList() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadTripListNextPage();
      }
    });
  }

  void loadTripListNextPage() {
    if (currentPage.value * limit.value < totalCount.value) {
      currentPage.value++;
      callTripListApi(pageNation: true);
    } else {
      pageNationLoader.value = false;
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    existingDataList.refresh();
    super.onClose();
  }

  _getUserInfos() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    fromDate.value = DateTime.now().subtract(const Duration(days: 1));
    toDate.value = DateTime.now();
    callTripListApi();
  }

  void goBack() {
    if (tripIdController.text.isNotEmpty || carNoController.text.isNotEmpty) {
      tripIdController.text = "";
      carNoController.text = "";
      _getUserInfos();
    } else {
      Get.back();
    }
  }

  void moveToMapPage(String tripId) {
    callTripHistoryMapApi(int.parse(tripId), supervisorInfo.cid);
  }

  void callTripListApi({bool pageNation = false}) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    switch (pageNation) {
      case false:
        showLoader.value = true;
        pageNationLoader.value = false;
        currentPage.value = 1;
        break;
      case true:
        pageNationLoader.value = true;
        showLoader.value = false;
        break;
      default:
    }
    // showLoader.value = true;
    tripListApi(
      MyTripsRequestData(
        driverName: carNoController.text,
        tripId: tripIdController.text,
        from: DateFormat('yyyy-MM-d HH:mm').format(fromDate.value),
        to: DateFormat('yyyy-MM-d HH:mm').format(toDate.value),
        locationId: supervisorInfo.kioskId.toString(),
        supervisorId: supervisorInfo.supervisorId,
        limit: limit.value,
        start: currentPage.value,
        type: 0
      ),
    ).then((response) {
      switch (pageNation) {
        case false:
          pageNationLoader.value = false;
          if ((response.status ?? 0) == 1) {
            tripList.value = response.details?.tripDetails ?? [];
            totalCount.value = response.details!.totalCount ?? 0;
            showLoader.value = false;
            tripList.refresh();
            print("DEEPAK tripList ${tripList.length}");
          } else {
            tripList.value = [];
            dispatchedTrips.value = 0;
            cancelledTrips.value = 0;
            showLoader.value = false;
            pageNationLoader.value = false;
          }
          break;
        case true:
          if (response.status == 1) {
            tripList.addAll(response.details?.tripDetails ?? []);
            tripList.refresh();
            showLoader.value = false;
          }
          break;
      }
    }).onError(
      (error, stackTrace) {
        printLogs("$error");
        showLoader.value = false;
        pageNationLoader.value = false;
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

  void callTripListOngoingApi({bool pageNation = false,int? type}) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    switch (pageNation) {
      case false:
        showLoader.value = true;
        pageNationLoader.value = false;
        currentPage.value = 1;
        break;
      case true:
        pageNationLoader.value = true;
        showLoader.value = false;
        break;
      default:
    }
    // showLoader.value = true;
    tripListApi(
      MyTripsRequestData(
          driverName: carNoController.text,
          tripId: tripIdController.text,
          from: DateFormat('yyyy-MM-d HH:mm').format(fromDate.value),
          to: DateFormat('yyyy-MM-d HH:mm').format(toDate.value),
          locationId: supervisorInfo.kioskId.toString(),
          supervisorId: supervisorInfo.supervisorId,
          limit: limit.value,
          start: currentPage.value,
          type: type
      ),
    ).then((response) {
      switch (pageNation) {
        case false:
          pageNationLoader.value = false;
          if ((response.status ?? 0) == 1) {
            tripListOngoing.value = response.details?.tripDetails ?? [];
            totalCountOngoing.value = response.details!.totalCount ?? 0;
            showLoader.value = false;
            tripListOngoing.refresh();
            print("DEEPAK tripList ${tripList.length}");
          } else {
            tripListOngoing.value = [];
            dispatchedTrips.value = 0;
            cancelledTrips.value = 0;
            showLoader.value = false;
            pageNationLoader.value = false;
          }
          break;
        case true:
          if (response.status == 1) {
            tripListOngoing.addAll(response.details?.tripDetails ?? []);
            tripListOngoing.refresh();
            showLoader.value = false;
          }
          break;
      }
    }).onError(
          (error, stackTrace) {
        printLogs("$error");
        showLoader.value = false;
        pageNationLoader.value = false;
        tripListOngoing.value = [];
        dispatchedTrips.value = 0;
        cancelledTrips.value = 0;
        tripListOngoing.refresh();
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void callExportPdfApi() async {
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      showBtnLoader.value = true;
      listexportPdfApi(
        ExportPdfRequestData(
          supervisorId: supervisorInfo.supervisorId,
          locationId: supervisorInfo.kioskId,
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
        showCancelBottomSheet(tripId);
      },
    );
  }

  void _callCancelTripApi(int tripId) async {
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      showLoader.value = true;
      ListcancelTripApi(
        tripListCancelTripRequest(
          kioskId: supervisorInfo.kioskId,
          cid: supervisorInfo.cid,
          cancelPwd: generateMd5(passwordController.text.trim()),
          cancelMessage: messageController.text.trim(),
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
            messageController.text = "";
            passwordController.text = "";
            callTripListApi();
          } else {
            showSnackBar(
              title: 'Error',
              msg: response.message ?? "Something went wrong",
            );
          }
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
  }

  void callEditFareApi(String? comments, int? fare, int? tripId) async {
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
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
            removeRoutesUntil(routeName: AppRoutes.tripListPage);
          } else {
            showSnackBar(
              title: 'Error',
              msg: response.message ?? "Something went wrong",
            );
          }
          callTripListApi();
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
  }

  void callTripHistoryMapApi(int? tripId, String? cid) async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    showLoader.value = true;
    tripHistoryMapApi(
      TripHistoryMapRequestedData(tripId: tripId, cid: cid),
    ).then(
      (response) {
        showLoader.value = false;
        if (response.status == 1) {
          mapdatas.value = response.detail?.mapDatas ?? [];
          mapdatas.refresh();
          if (mapdatas.isNotEmpty) {
            _pickUpMarker();
            _dropMarker();
            Get.toNamed(
              AppRoutes.tripListMapPage,
            );
          }
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong",
          );
        }
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

  void getTripDetailFromList({required ListTripDetails detail}) {
    selectedTripDetail.value = detail;
    selectedTripDetail.refresh();
  }

  void fareSumbitValidation() {
    if (farEditController.text == "") {
      showSnackBar(title: "Information", msg: "Enter Your Edited Fare");
    } else if (commentAddController.text == "") {
      showSnackBar(title: "Information", msg: "Enter Your Comments");
    } else {
      callEditFareApi(
          commentAddController.text.trim(),
          int.parse(farEditController.text.trim()),
          int.parse(selectedTripDetail.value.tripId.toString()));
    }
  }

  void addMarker(LatLng position, String title, BitmapDescriptor icon) {
    markers.add(
      Marker(
        markerId: MarkerId(position.toString()),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: icon,
      ),
    );
    markers.refresh();
  }

  _pickUpMarker() async {
    // if (mapdatas.isEmpty) {
    //   LatLng startLocation = const LatLng(11.0317782,77.0185392);
    //   addMarker(startLocation, "PickUp", await getPickUpIcons());
    // } else {
    LatLng startLocation = LatLng(
        mapdatas.value[0].latitude?.toDouble() ?? 0, mapdatas.value[0].longitude?.toDouble() ?? 0);
    addMarker(startLocation, "PickUp", await getPickUpIcons());
    // }
  }

  _dropMarker() async {
    // if (mapdatas.isEmpty) {
    //   LatLng endLocation = const LatLng(77.01876831054688,11.031820297241211);
    //   addMarker(endLocation, "Drop", await getDropIcons());
    // } else {
    LatLng endLocation = LatLng(
        mapdatas.value[mapdatas.length - 1].latitude?.toDouble() ?? 0,
        mapdatas.value[mapdatas.length - 1].longitude?.toDouble() ?? 0);
    addMarker(endLocation, "Drop", await getDropIcons());
    // }
  }

  Future<BitmapDescriptor> getPickUpIcons() async {
    final Uint8List customMarker = await getBytesFromAsset(
      path: 'assets/trip_History_map_page/greenmarker.png',
      width: 40,
      height: 40,
    );
    var icon = BitmapDescriptor.fromBytes(customMarker);
    icons = icon;
    return icons!;
  }

  Future<BitmapDescriptor> getDropIcons() async {
    final Uint8List customMarker = await getBytesFromAsset(
      path: 'assets/trip_History_map_page/redmarker.png',
      //paste the custom image path
      width: 40,
      height: 40,
    );
    var icon = BitmapDescriptor.fromBytes(customMarker);
    icons = icon;
    return icons!;
  }

  Future<Uint8List> getBytesFromAsset(
      {required String path, required int width, int height = 80}) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width, targetHeight: height);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  void showCancelBottomSheet(tripId) {
    Get.bottomSheet(
        Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r))),
            margin: EdgeInsets.only(top: 70.h),
            child: bottomsheetWidget(tripId)),
        isScrollControlled: true);
  }

  Widget bottomsheetWidget(tripId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 10, left: 10, top: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Cancel Trip",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: messageController,
            decoration: InputDecoration(
              hintText: 'Message',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0.w,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.kPrimaryColor.value,
                  width: 1.0.w,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              ),
              contentPadding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
            ),
            maxLines: 5,
            minLines: 3,
          ),
          SizedBox(height: 20.h),
          Obx(() => TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible.value,
                decoration: InputDecoration(
                  hintText: 'Enter the Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1.0.w,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.kPrimaryColor.value,
                      width: 1.0.w,
                    ),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      print(isPasswordVisible.value);
                      isPasswordVisible.value = !isPasswordVisible.value;
                    },
                  ),
                  contentPadding:
                      const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
                ),
              )),
          ElevatedButton(
            onPressed: () {
              if (messageController.text == "") {
                showSnackBar(title: "Alert", msg: "Please Enter Message");
              } else if (passwordController.text == "") {
                showSnackBar(title: "Alert", msg: "Please Enter Password");
              } else {
                _callCancelTripApi(tripId);
                /* messageController.text = "";
                passwordController.text = "";*/
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(
              primary: AppColors.kPrimaryColor.value,
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

void removeRoutesUntil({String? routeName}) {
  printLogs("hi Deepak previous route : ${routeName}");
  bool condition(Route<dynamic>? route) {
    return route?.settings.name == '${routeName}';
  }

  Get.until(condition);
}
