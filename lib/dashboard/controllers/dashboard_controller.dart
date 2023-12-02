import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rsl_supervisor/dashboard/data/car_model_type_api.dart';
import 'package:rsl_supervisor/dashboard/data/logout_api_data.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';
import 'package:rsl_supervisor/utils/helpers/alert_helpers.dart';
import 'package:rsl_supervisor/widgets/app_loader.dart';

import '../../location_queue/controllers/location_queue_controller.dart';
import '../../network/app_config.dart';
import '../../place_search/data/get_place_details_response.dart';
import '../../quickTrip/controllers/quick_trip_controller.dart';
import '../../utils/helpers/app_info.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';
import '../data/dashboard_api_data.dart';
import '../data/shift_in_api_data.dart';
import '../service/dashboard_service.dart';

class Car {
  final String name;
  final String imageUrl;
  final String modelId;

  Car({required this.name, required this.imageUrl, required this.modelId});
}

class DashBoardController extends GetxController {
  RxBool isShiftIn = true.obs;
  RxBool useCustomDrop = false.obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  List<DropOffList> dropList = <DropOffList>[].obs;
  RxList<DropOffList> dropSearchList = <DropOffList>[].obs;
  RxString searchTxt = "".obs;
  RxString noDropOffDataMsg = "No Drop-off found".obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldKey1 = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldKey2 = GlobalKey<ScaffoldState>();
  RxString locationType = "".obs;

  final LocationManager locationManager = LocationManager();
  late LogoutApiResponse logoutApiResponse = LogoutApiResponse();
  RxList<CarmodelList> carModelList = <CarmodelList>[].obs;

  Rx<SupervisorInfo> supervisorInfo = SupervisorInfo().obs;
  var deviceToken = "";
  RxString appVersion = "".obs;
  RxString appBuildNumber = "".obs;
  RxString apk = "".obs;
  RxBool apiLoading = true.obs;
  RxBool showLoader = false.obs;
  RxBool logOutLoader = false.obs;
  int selectedCarIndex = 0;

  final GetStorageController controller = Get.find<GetStorageController>();

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
    _getAppInfo();
  }

  _getUserInfo() async {
    await getAppInfo();
    supervisorInfo.value = await GetStorageController().getSupervisorInfo();
    deviceToken = await GetStorageController().getDeviceToken();
    bool shiftStatus = await GetStorageController().getShiftStatus();
    locationType.value = await GetStorageController().getLocationType();
    if (!shiftStatus) {
      isShiftIn.value = false;
    } else {
      isShiftIn.value = true;
    }
    callDashboardApi();
    callCarModelApi();
  }

  void callDashboardApi() async {
    apiLoading.value = true;
    dashboardApi(DasboardApiRequest(
      kioskId: supervisorInfo.value.kioskId,
      supervisorId: supervisorInfo.value.supervisorId,
      cid: supervisorInfo.value.cid,
      deviceToken: await GetStorageController().getDeviceToken(),
    )).then((response) {
      if ((response.status ?? 0) == 1) {
        dropList = response.dropOffList ?? [];
        dropSearchList.value = response.dropOffList ?? [];
        dropSearchList.refresh();
        apiLoading.value = false;
        noDropOffDataMsg.value = response.message ?? "";
      } else {
        noDropOffDataMsg.value = response.message ?? "No Dropoff found";
        dropList = [];
        dropSearchList.value = [];
        dropSearchList.refresh();
        apiLoading.value = false;
      }
    }).onError((error, stackTrace) {
      apiLoading.value = false;
      printLogs("Dashboard api error: ${error.toString()}");
      dropList = [];
      dropSearchList.value = [];
      dropSearchList.refresh();
    });
  }

  void callCarModelApi() async {
    // apiLoading.value = true;
    carModelApi(CarModelTypeRequestData(
      kioskId: supervisorInfo.value.kioskId,
      supervisorId: supervisorInfo.value.supervisorId,
      dropLatitude: "",
      dropLongitude: "",
      cid: supervisorInfo.value.cid,
      deviceToken: await GetStorageController().getDeviceToken(),
    )).then((response) {
      // apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        carModelList.value = response.carmodelList ?? [];
        carModelList.refresh();
      } else {
        noDropOffDataMsg.value = response.message ?? "No Dropoff found";
        carModelList.value = [];
        carModelList.refresh();
      }
    }).onError((error, stackTrace) {
      // apiLoading.value = false;
      printLogs("CarModel api error: ${error.toString()}");
      carModelList.value = [];
      carModelList.refresh();
    });
  }

  void _callShiftInApi(String type, bool shiftType) async {
    showLoader.value = true;
    shiftInApi(
      ShiftInRequest(
        kioskId: supervisorInfo.value.kioskId,
        supervisorId: supervisorInfo.value.supervisorId,
        cid: supervisorInfo.value.cid,
        type: type,
      ),
    ).then(
      (response) {
        showLoader.value = false;
        controller.saveShiftStatus(value: shiftType);
        printLogs("Shift in message: ${response.message ?? ""}");
      },
    ).onError(
      (error, stackTrace) {
        showLoader.value = false;
        printLogs("Shift in error: ${error.toString()}");
      },
    );
  }

  shiftInOutAction(bool newValue) {
    isShiftIn.value = newValue;
    _callShiftInApi(newValue ? "1" : "2", newValue);
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

  void moveToPlaceSearch() async {
    final result = await Get.toNamed(
      AppRoutes.placeSearchPage,
    );

    if (result is PlaceDetails) {
      final QuickTripController controller = Get.find<QuickTripController>();
      controller
        ..dropLocationController.text = '${result.formattedAddress}'
        ..dropLatitude = result.geometry?.location?.lat ?? 0.0
        ..dropLongitude = result.geometry?.location?.lng ?? 0.0
        ..fareController.text = '';
      Get.toNamed(AppRoutes.quickTripPage);
    }
  }

  void moveToPlaceSearchDispatch() async {
    final result = await Get.toNamed(
      AppRoutes.placeSearchPage,
    );

    final LocationQueueController controller =
        Get.find<LocationQueueController>();
    controller
      ..dropAddress = '${result.formattedAddress}'
      ..dropLatitude =
          double.tryParse('${result.geometry?.location?.lat}') ?? 0.0
      ..dropLongitude =
          double.tryParse('${result.geometry?.location?.lng}') ?? 0.0
      ..fare = ''
      ..fromDashboard = 0
      ..zoneFareApplied = "0";

    Get.toNamed(AppRoutes.locationQueuePage);
  }

  void moveToQuickTrip() async {
    final result = await Get.toNamed(
      AppRoutes.placeSearchPage,
    );

    if (result is PlaceDetails) {
      final QuickTripController controller = Get.find<QuickTripController>();
      controller
        ..dropLocationController.text = '${result.formattedAddress}'
        ..dropLatitude = result.geometry?.location?.lat ?? 0.0
        ..dropLongitude = result.geometry?.location?.lng ?? 0.0
        ..fareController.text = '';
      Get.back();
      // Get.offAndToNamed(AppRoutes.quickTripPage);
    }
  }

  openMenu() {
    scaffoldKey.currentState?.openDrawer();
  }

  menuAction(String title) {
    scaffoldKey.currentState?.closeDrawer();
    switch (title) {
      case "Logout":
        _showLogoutAlert();
        scaffoldKey.currentState?.openDrawer();
        break;
      case 'Quick Trips':
        Get.toNamed(AppRoutes.quickTripPage);
        break;
      case 'Offline Trips':
        Get.toNamed(AppRoutes.offlineTripPage);
        break;
      case 'Bookings':
        Get.toNamed(AppRoutes.bookings);
        break;
      case "Location Queue":
        Get.toNamed(AppRoutes.locationQueuePage);
        break;
      case "Trip History":
        Get.toNamed(AppRoutes.tripHistoryPage);
        break;
      case "Feeds":
        Get.toNamed(AppRoutes.feedsPage);
        break;
      case "Subscribers":
        Get.toNamed(AppRoutes.subscriberPage);
        break;
      case "My Trips":
        Get.toNamed(AppRoutes.tripListPage);
        break;
      case "Rider Referral":
        Get.toNamed(AppRoutes.riderRefferalPage);
        break;
      case "Leaderboard":
        Get.toNamed(AppRoutes.leaderBoaradPage);
        break;
      case "Dispatch":
        Get.toNamed(AppRoutes.dispatchPage);
        break;
      case "Driver List":
        Get.toNamed(AppRoutes.driverListPage);
        break;
      case 'Reorder List':
        Get.toNamed(AppRoutes.reOrderPage);
        break;

      default:
        break;
    }
  }

  void _showLogoutAlert() {
    showDefaultDialog(
      context: Get.context!,
      title: "Alert",
      message: "Are you sure you want to logout?",
      isTwoButton: true,
      acceptBtnTitle: "Yes, Logout",
      acceptAction: () {
        _callLogoutApi();
      },
      cancelBtnTitle: "No",
    );
  }

  void moveToCaptureImagePage(data) async {
    final imageUrl = await Get.toNamed(AppRoutes.captureImagePage);
    if (imageUrl is String) {
      logOutLoader.value = true;
      logoutApi(
        LogoutApiRequest(
          supervisorId: supervisorInfo.value.supervisorId,
          cid: supervisorInfo.value.cid,
          latitude: data!.latitude,
          longitude: data!.longitude,
          accuracy: data!.accuracy,
          photoUrl: imageUrl,
        ),
      ).then(
        (response) {
          if ((response.status ?? 0) == 1) {
            logoutApiResponse = response;
            GetStorageController().removeSupervisorInfo();
            showSnackBar(title: "Message", msg: response.message ?? "");
            Get.offAndToNamed(AppRoutes.loginPage);
            logOutLoader.value = false;
          } else {
            logOutLoader.value = false;
            showSnackBar(
              title: 'Error',
              msg: response.message ?? "Something went wrong...",
            );
          }
        },
      ).onError(
        (error, stackTrace) {
          logOutLoader.value = false;
          showSnackBar(
            title: 'Error',
            msg: error.toString(),
          );
        },
      );
    } else {
      logOutLoader.value = false;
      showSnackBar(
        title: 'Error',
        msg: "Something went wrong...",
      );
    }
  }

  void _callLogoutApi() async {
    logOutLoader.value = true;
    LocationResult<Position> result =
        await locationManager.getCurrentLocation();
    if (result.data != null) {
      moveToCaptureImagePage(result.data);
    } else {
      showSnackBar(
        title: 'ERROR!',
        msg: result.error ?? "Error occurred while fetching current location",
      );
    }
  }

  void _getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appVersion.value = packageInfo.version;
    appBuildNumber.value = packageInfo.buildNumber;
    apk.value =
        AppConfig.currentEnvironment == Environment.demo ? "Demo" : "Live";
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

  void showCustomDialog(BuildContext context) {
    final List<dynamic> staticImageUrls = [
      {'motor_id': 1, 'image': "assets/dashboard_page/sedan.png"},
      {'motor_id': 10, 'image': "assets/dashboard_page/xl.png"},
      {'motor_id': 23, 'image': "assets/dashboard_page/vip.png"},
      {'motor_id': 19, 'image': "assets/dashboard_page/vip_plus.png"},
    ];
    final List<Car> cars = [];
    for (final carModel in carModelList) {
      final imageUrl = staticImageUrls.firstWhere(
          (element) => element['motor_id'] == carModel.motorId,
          orElse: () => {'image': "assets/dashboard_page/tesla.png"})['image'];

      final car = Car(
          name: carModel.motorName ?? "",
          imageUrl: imageUrl,
          modelId: carModel.motorId?.toString() ?? "");
      cars.add(car);
    }

    final AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: Navigator.of(context),
    );

    final Tween<double> verticalPositionTween = Tween<double>(
      begin: 1.0,
      end: 0.0,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return (selectedCarIndex >= cars.length)
                ? const SizedBox.shrink()
                : AnimatedBuilder(
                    animation: animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          0,
                          MediaQuery.of(context).size.height *
                              verticalPositionTween
                                  .evaluate(animationController),
                        ),
                        child: AlertDialog(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 30.w, vertical: 24.h),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Available Cars',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: AppFontWeight.bold.value,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        animationController
                                            .reverse()
                                            .then((value) {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: Icon(
                                        CupertinoIcons.multiply_circle,
                                        color: AppColors
                                            .kSecondaryContainerBorder.value,
                                        size: 35.r,
                                      ),
                                    ),
                                  ],
                                ),
                                Image.asset(
                                  cars[selectedCarIndex].imageUrl,
                                  width: 250.w,
                                  height: 250.h,
                                ),
                                // SizedBox(width: 10.w),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        selectPreviousCar();
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        CupertinoIcons.chevron_left,
                                        color: selectedCarIndex > 0
                                            ? AppColors.kPrimaryColor.value
                                            : Colors
                                                .grey, // Gray if not available
                                        size: 30.r,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(
                                          cars[selectedCarIndex].name,
                                          style: TextStyle(
                                            fontSize: 17.r,
                                            fontWeight:
                                                AppFontWeight.bold.value,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        selectNextCar(cars);
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        CupertinoIcons.chevron_right,
                                        color:
                                            selectedCarIndex < cars.length - 1
                                                ? AppColors.kPrimaryColor.value
                                                : Colors.grey,
                                        size: 30.r,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        );
      },
    );
    animationController.forward(); // Start the animation
  }

  void selectNextCar(cars) {
    if (selectedCarIndex < cars.length - 1) {
      selectedCarIndex++;
    }
  }

  void selectPreviousCar() {
    if (selectedCarIndex > 0) {
      selectedCarIndex--;
    }
  }
}
