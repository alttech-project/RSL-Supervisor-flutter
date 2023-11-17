import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/place_search/data/get_place_details_response.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/data/car_model_type_api.dart';
import '../../dashboard/service/dashboard_service.dart';
import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';
import '../../widgets/custom_button.dart';

class BookingsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final LocationManager locationManager = LocationManager();
  var selectedTabBar = 0.obs;
  TabController? tabController;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  final TextEditingController priceController = TextEditingController();
  final TextEditingController extraChargesController = TextEditingController();

  final TextEditingController noteToDriverController = TextEditingController();
  final TextEditingController flightNumberController = TextEditingController();
  final TextEditingController refNumberController = TextEditingController();
  final TextEditingController noteToAdminController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  var countryCode = '971'.obs;
  double pickupLatitude = 0.0, pickupLongitude = 0.0;
  double dropLatitude = 0.0, dropLongitude = 0.0;

  var taxiModel = 'SEDAN'.obs;
  var taxiId = '1'.obs;

  var selectedPaymentMethod = 'CASH'.obs;
  var selectedPaymentId = '1'.obs;

  RxBool showCustomPricing = false.obs;
  RxBool showAdditionalElements = false.obs;

  // RxBool showPaymentOption = false.obs;
  // final selectedRadio = 1.obs;
  int selectedCarIndex = 0;
  RxList<CarmodelList> carModelList = <CarmodelList>[].obs;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  var apiLoading = false.obs;
  SupervisorInfo? supervisorInfo;

  @override
  void onInit() {
    super.onInit();
    getDate();
    _getUserInfo();
  }

  void goBack() {
    Get.back();
  }

  changeTabIndex(int value) {
    selectedTabBar.value = value;
  }

  void clearAllData() {
    taxiModel.value = "SEDAN";
    taxiId.value = "1";
    selectedPaymentMethod.value = "CASH";
    selectedPaymentId.value = "1";
    countryCode.value = "971";
    nameController.clear();
    phoneController.clear();
    emailController.clear();
    priceController.clear();
    extraChargesController.clear();
    noteToAdminController.clear();
    noteToDriverController.clear();
    flightNumberController.clear();
    refNumberController.clear();
    remarksController.clear();
    clearPickUpLocation();
    clearDropLocation();
  }

  void clearPickUpLocation() {
    pickupLocationController.clear();
  }

  void clearDropLocation() {
    dropLocationController.clear();
  }

  /*  void clearCarModel() {
    carModelController.clear();
  }*/

  void checkNewBookingValidation() async {
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      if (formKey.currentState!.validate()) {
        final name = nameController.text.trim();
        final phone = phoneController.text.trim();
        final email = emailController.text.trim();
        final pickupLocation = pickupLocationController.text.trim();
        final dropLocation = dropLocationController.text.trim();
        final date = dateController.text.trim();
        final price = priceController.text.trim();
        final extraCharges = extraChargesController.text.trim();
        final noteToDriver = noteToDriverController.text.trim();
        final noteToAdmin = noteToAdminController.text.trim();
        final flightNumber = flightNumberController.text.trim();
        final refNumber = refNumberController.text.trim();
        final remarks = remarksController.text.trim();

        if (name.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid name!');
        } else if (phone.isEmpty || !GetUtils.isPhoneNumber(phone)) {
          _showSnackBar('Validation!', 'Enter a valid phone number!');
        } else if (email.isEmpty || !GetUtils.isEmail(email)) {
          _showSnackBar('Validation!', 'Enter a valid Email!');
        } else if (pickupLocation.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid pickup location!');
        } else if (dropLocation.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid drop location!');
        } else if (date.isEmpty) {
          _showSnackBar('Validation!', 'Kindly select date!');
        } else if (price.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid price!');
        } else if (extraCharges.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid extra charges!');
        } else if (remarks.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid remarks!');
        } else {
          if (supervisorInfo == null) {
            _showSnackBar('Error!', 'Invalid user login status!');
            return;
          }
          apiLoading.value = true;
          // callNewBookingApi();
        }
      }
    }
  }

  void callCarModelApi(SupervisorInfo? supervisorInfo) async {
    carModelApi(CarModelTypeRequestData(
      kioskId: supervisorInfo?.kioskId ?? "",
      supervisorId: supervisorInfo?.supervisorId ?? "",
      dropLatitude: "",
      dropLongitude: "",
      cid: supervisorInfo?.cid ?? "",
      deviceToken: await GetStorageController().getDeviceToken(),
    )).then((response) {
      // apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        carModelList.value = response.carmodelList ?? [];
        carModelList.refresh();
      } else {
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

  void _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    if (supervisorInfo == null) {
      return;
    }
    callCarModelApi(supervisorInfo);

    LocationResult<Position> result =
        await locationManager.getCurrentLocation();
    pickupLatitude = result.data!.latitude ?? 0.0;
    pickupLongitude = result.data!.longitude ?? 0.0;

    List<Placemark> locations =
        await placemarkFromCoordinates(pickupLatitude, pickupLongitude);
    pickupLocationController.text =
        "${locations[0].name},${locations[0].locality} ${locations[0].country}";
  }

  void getDate() {
    dateController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void _showSnackBar(String title, String message) =>
      showSnackBar(msg: message, title: title);

  void navigateToPickUpPlaceSearchPage() async {
    final result = await Get.toNamed(
      AppRoutes.placeSearchPage,
    );

    if (result is PlaceDetails) {
      pickupLocationController.text = result.formattedAddress ?? '';
      pickupLatitude = result.geometry?.location?.lat ?? 0.0;
      pickupLongitude = result.geometry?.location?.lng ?? 0.0;
    }
  }

  void navigateToPlaceSearchPage() async {
    final result = await Get.toNamed(
      AppRoutes.placeSearchPage,
    );

    if (result is PlaceDetails) {
      dropLocationController.text = result.formattedAddress ?? '';
      dropLatitude = result.geometry?.location?.lat ?? 0.0;
      dropLongitude = result.geometry?.location?.lng ?? 0.0;
    }
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
                          content: Column(
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
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        cars[selectedCarIndex].name,
                                        style: TextStyle(
                                          fontSize: 17.r,
                                          fontWeight: AppFontWeight.bold.value,
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
                                      color: selectedCarIndex < cars.length - 1
                                          ? AppColors.kPrimaryColor.value
                                          : Colors.grey,
                                      size: 30.r,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              CustomButton(
                                  width: double.maxFinite,
                                  linearColor: primaryButtonLinearColor,
                                  height: 38.h,
                                  borderRadius: 38.h / 2,
                                  style: AppFontStyle.body(color: Colors.white),
                                  text: 'Submit',
                                  onTap: () => {
                                        /* carModelController.text =
                                            cars[selectedCarIndex].name,*/
                                        taxiModel.value =
                                            cars[selectedCarIndex].name,
                                        taxiId.value =
                                            cars[selectedCarIndex].modelId,
                                        animationController.reverse().then(
                                          (value) {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      }),
                            ],
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
