import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/bookings/controller/booking_list_controller.dart';
import 'package:rsl_supervisor/bookings/data/save_booking_data.dart';
import 'package:rsl_supervisor/network/app_config.dart';
import 'package:rsl_supervisor/place_search/data/get_place_details_response.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rsl_supervisor/trip_history/data/export_pdf_data.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/data/car_model_type_api.dart';
import '../../dashboard/service/dashboard_service.dart';
import '../../my_trip/controller/my_trip_list_controller.dart';
import '../../routes/app_routes.dart';
import '../../shared/styles/app_color.dart';
import '../../shared/styles/app_font.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';
import '../../widgets/app_loader.dart';
import '../../widgets/custom_button.dart';
import '../data/all_car_makes_data.dart';
import '../data/get_car_make_fare_data.dart';
import '../data/get_package_data.dart';
import '../data/motor_details_data.dart';
import '../service/booking_service.dart';
import '../upcoming_bookings_tab.dart';

double doubleWithTwoDigits(double value) =>
    double.parse(value.toStringAsFixed(2));

class BookingsController extends GetxController
    with GetSingleTickerProviderStateMixin {
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
  final TextEditingController roomNumberController = TextEditingController();
  final TextEditingController customRateController = TextEditingController();

  Rx<TripType> selectedBookingType = bookingTypeList[0].obs;
  Rx<TripType> selectedPackageType = packageTypeList[0].obs;
  RxList<CorporatePackageList> packageList = <CorporatePackageList>[].obs;
  Rx<CorporatePackageList> packageData = CorporatePackageList().obs;
  Rx<CarMakeFareDetails> carMakeFareDetails = CarMakeFareDetails().obs;

  var countryCode = '971'.obs;
  double pickupLatitude = 0.0, pickupLongitude = 0.0;
  double dropLatitude = 0.0, dropLongitude = 0.0;

  var taxiModel = ''.obs;
  var taxiId = ''.obs;
  var carMakeId = ''.obs;

  Rx<Payments> selectedPayment = paymentList[0].obs;

  RxBool showCustomPricing = false.obs;
  RxBool showAdditionalElements = false.obs;
  String originalPrice = "0";

  // RxBool showPaymentOption = false.obs;
  // final selectedRadio = 1.obs;
  int selectedCarIndex = 0;
  RxList<CarMakeList> carModelList = <CarMakeList>[].obs;

  List<FareDetailList> motorModelList = <FareDetailList>[];

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  var overViewPolyLine = "".obs;
  var approximateTime = 0.0.obs;
  var approximateTrafficTime = 0.0.obs;
  var approximateDistance = 0.0.obs;
  var approximateFare = "0".obs;

  var zoneFareApplied = 0.obs;
  num rslShare = 0;
  num driverShare = 0;
  num corporateShare = 0;
  int pickupZoneId = 0;
  int pickupZoneGroupId = 0;
  int dropZoneId = 0;
  int dropZoneGroupId = 0;

  var apiLoading = false.obs;
  var saveBookingApiLoading = false.obs;
  SupervisorInfo? supervisorInfo;
  RxInt selectedTripRadioValue = 1.obs;
  RxInt roundTripselectedTripRadioValue = 1.obs;

  RxBool isDoubleTheFare = false.obs;
  RxDouble calculatedValue = 0.0.obs;
  RxDouble price = 0.0.obs;

/*  String customerPriceValue = "0";
  bool isExtraChargesApplied = false;*/

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    getDate();
    getUserInfo();
  }

  void goBack() {
    Get.back();
  }

  changeTabIndex(int value) {
    selectedTabBar.value = value;
  }

  void clearAllData() {
    if (carModelList.isNotEmpty) {
      taxiModel.value = carModelList[0].car_make_name.toString();
      taxiId.value = carModelList[0].model_id.toString();
      carMakeId.value = carModelList[0].car_make_id.toString();
    } else {
      taxiModel.value = "";
      taxiId.value = "";
      carMakeId.value = "";
    }
    /*taxiModel.value = "SEDAN";
    taxiId.value = "1";
    carMakeId.value = "1";*/
    selectedPayment.value = paymentList[0];
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
    roomNumberController.clear();
    customRateController.clear();
    selectedBookingType.value = bookingTypeList[0];
    selectedPackageType.value = packageTypeList[0];
    packageData.value = packageList[0];
    remarksController.clear();
    selectedTripRadioValue.value = 1;
    roundTripselectedTripRadioValue.value = 0;
    clearPickUpLocation();
    clearDropLocation();
  }

  void clearPickUpLocation() {
    _resetApproximateTimeDistance();
    pickupLatitude = 0.0;
    pickupLongitude = 0.0;
    pickupLocationController.clear();
  }

  void clearDropLocation() {
    _resetApproximateTimeDistance();
    dropLatitude = 0.0;
    dropLongitude = 0.0;
    dropLocationController.clear();
  }

  void calculateShares(String customerPriceValue) {
    if (GetPlatform.isIOS) {
      String cleanedValue =
          customerPriceValue.toString().replaceAll(RegExp(r'[^0-9.-]'), '');
      priceController.text = cleanedValue;
    }
    var price = double.parse(customerPriceValue);
    double rslShareValue = (price * 0.15 * 100).round() / 100;
    if (price <= 20.0) {
      rslShareValue = price;
    } else if (rslShareValue < 20.0) {
      rslShareValue = 20.0;
    }
    double driverShareValue = price - rslShareValue;
    double driverShares = driverShareValue.clamp(0, double.infinity);
    rslShare = rslShareValue;
    driverShare = driverShares;
  }

  void handleExtraCharge(String value) {
    if (GetPlatform.isIOS) {
      String cleanedValue = value.replaceAll(RegExp(r'[^0-9.-]'), '');
      extraChargesController.text = cleanedValue;
    }
    if (value.contains('-')) {
      if (originalPrice.isEmpty) {
        originalPrice = "0";
      }
      String absoluteValue = value.replaceAll('-', '');
      double enteredValue =
          absoluteValue.isEmpty ? 0.0 : double.parse(absoluteValue);
      if (enteredValue > double.parse(originalPrice)) {
        setExtraChargeError(true);
        return;
      } else {
        setExtraChargeError(false);
      }
      double extraChargeValue = enteredValue.isNaN ? 0 : enteredValue;
      double adjustedCustomerPrice =
          double.parse(originalPrice) - extraChargeValue;
      calculateShares(adjustedCustomerPrice.toString());
      priceController.text = adjustedCustomerPrice.toString();
      // customerPriceValue = adjustedCustomerPrice.toString();
      /* if (roundTripselectedTripRadioValue.value == 1 &&
          zoneFareApplied.value == 1) {
        isExtraChargesApplied = true;
      } else {
        isExtraChargesApplied = false;
      }*/
    } else {
      if (originalPrice.isEmpty) {
        originalPrice = "0";
      }
      double extraChargeValue = value.isEmpty ? 0 : double.parse(value) ?? 0;
      double adjustedCustomerPrice =
          double.parse(originalPrice ?? "0") + extraChargeValue;
      calculateShares(adjustedCustomerPrice.toString());
      priceController.text = adjustedCustomerPrice.toString();
      /* customerPriceValue = adjustedCustomerPrice.toString();

      if (roundTripselectedTripRadioValue.value == 1 &&
          zoneFareApplied.value == 1) {
        isExtraChargesApplied = true;
      } else {
        isExtraChargesApplied = false;
      }*/
    }
  }

  void setExtraChargeForMinus() {
    if (extraChargesController.text.contains('-')) {
      extraChargesController.clear();
      extraChargesController.text = "";
    }
  }

  void setExtraChargeError(bool extraCharge) {
    if (extraCharge) {
      Future.delayed(const Duration(seconds: 1), () {
        extraChargesController.clear();
        if (originalPrice != "0") {
          priceController.text = originalPrice.toString();
        }
      });
      showSnackBar(
        title: 'Error',
        msg: "Extra Charges cannot be greater than the Customer Price",
      );
    }
  }

  void callGetCorporatePackageListApi(showLoader) async {
    var corporateId = "0";
    var corporateID = await GetStorageController().getCorporateId();
    if (corporateID.isNotEmpty) {
      corporateId = corporateID;
    }
    int? carMake = 0;
    if (carMakeId.value.isNotEmpty) {
      carMake = int.parse(carMakeId.value);
    } else {
      carMake = 0;
    }

    if (showLoader) {
      apiLoading.value = true;
    } else {
      apiLoading.value = false;
    }
    getCorporatePackageListApi(
      GetCorporatePackageListRequest(
        corporateId: int.parse(corporateId ?? "0"),
        modelId: int.parse(taxiId.value),
        packageType: selectedPackageType.value.id,
        car_make_id: carMake,
      ),
    ).then(
      (response) {
        apiLoading.value = false;
        if (response.status == 1) {
          packageList.clear();
          packageList.value = response.packageDetails?.packageList ?? [];
          packageList.insert(
              0, CorporatePackageList(id: 001, typeLabel: "Select Package"));
          packageList.refresh();
          packageData.value = packageList[0];
        } else {
          showSnackBar(
            title: 'Error',
            msg: response.message ?? "Something went wrong",
          );
          packageList.clear();
          packageList.insert(
              0, CorporatePackageList(id: 001, typeLabel: "Select Package"));
          packageList.refresh();
          packageData.value = packageList[0];
        }
      },
    ).onError(
      (error, stackTrace) {
        apiLoading.value = false;
        packageList.clear();
        packageList.insert(
            0, CorporatePackageList(id: 001, typeLabel: "Select Package"));
        packageList.refresh();
        packageData.value = packageList[0];
        showDefaultDialog(
          context: Get.context!,
          title: "Error",
          message: error.toString(),
        );
      },
    );
    // callCorporateApi();
  }

  void tripTypeSelectedRadio(int? value) {
    selectedTripRadioValue.value = value ?? 0;
    if (selectedTripRadioValue.value == 2) {
      isDoubleTheFare.value = true;
      roundTripselectedTripRadioValue.value = 1;

      price.value = double.tryParse(priceController.text) ?? 0;
      calculatedValue.value = price.value * 2;
      originalPrice = calculatedValue.value.toString();
      priceController.text = calculatedValue.value.toString();
    } else {
      roundTripselectedTripRadioValue.value = 0;

      if (isDoubleTheFare.value) {
        price.value = double.tryParse(priceController.text) ?? 0;
        calculatedValue.value = price.value / 2;
        isDoubleTheFare.value = false;
        originalPrice = calculatedValue.value.toString();
        priceController.text = calculatedValue.value.toString();
      }
    }
  }

  void roundedSelectedRadio(int? value) {
    roundTripselectedTripRadioValue.value = value ?? 0;
    doubleTheFareCalculation();
  }

  void doubleTheFareCalculation() {
    price.value = double.tryParse(priceController.text) ?? 0;
    //double
    if (roundTripselectedTripRadioValue.value == 1 &&
        selectedTripRadioValue.value == 2) {
      isDoubleTheFare.value = true;
      calculatedValue.value = price.value * 2;
    } else {
      //single
      if (isDoubleTheFare.value == true) {
        calculatedValue.value = price.value / 2;
        isDoubleTheFare.value = false;
      } else {
        calculatedValue.value = price.value;
        isDoubleTheFare.value = false;
      }
    }
    originalPrice = calculatedValue.value.toString();
    priceController.text = calculatedValue.value.toString();
  }

  void checkNewBookingValidation() async {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
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
      final roomNo = roomNumberController.text.trim();

      if (name.isEmpty) {
        _showSnackBar('Validation!', 'Enter a valid name!');
      } else if (phone.isEmpty || !GetUtils.isPhoneNumber(phone)) {
        _showSnackBar('Validation!', 'Enter a valid phone number!');
      } else if (email.isEmpty || !GetUtils.isEmail(email)) {
        _showSnackBar('Validation!', 'Enter a valid Email!');
      } else if ((pickupLatitude == 0.0 && pickupLongitude == 0.0) ||
          pickupLocation.isEmpty) {
        _showSnackBar('Validation!', 'Enter a valid pickup location!');
      } else if ((dropLatitude == 0.0 && dropLongitude == 0.0) ||
          dropLocation.isEmpty) {
        _showSnackBar('Validation!', 'Enter a valid drop location!');
      } else if (date.isEmpty) {
        _showSnackBar('Validation!', 'Kindly select date!');
      } else if (taxiId.isEmpty || carMakeId.isEmpty) {
        _showSnackBar('Validation!', 'Kindly select car model!');
      } else if (selectedBookingType.value.id == 3 &&
          (packageData.value.id == null || packageData.value.id == 001)) {
        _showSnackBar('Validation!', 'Kindly select package!');
      } else if (selectedTripRadioValue.value == 0) {
        _showSnackBar('Validation!', 'Kindly select trip type!');
      } else if (price.isEmpty || double.parse(price) <= 0) {
        _showSnackBar('Validation!', 'Enter a valid price!');
      }
      /*else if (extraCharges.isNotEmpty && double.parse(extraCharges) <= 0) {
        _showSnackBar('Validation!', 'Enter a valid extra charges!');
      }*/
      /* else if (remarks.isEmpty) {
        _showSnackBar('Validation!', 'Enter a valid remarks!');
      }*/
      else {
        if (supervisorInfo == null) {
          _showSnackBar('Error!', 'Invalid user login status!');
          return;
        }
        callSaveBookingApi();
      }
    }
  }

  void callSaveBookingApi() async {
    saveBookingApiLoading.value = true;
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
    final roomNo = roomNumberController.text.trim();
    final customerRate = customRateController.text.trim();

    var corporateId = "0";
    var corporateID = await GetStorageController().getCorporateId();
    if (corporateID.isNotEmpty) {
      corporateId = corporateID;
    }

    supervisorInfo = await GetStorageController().getSupervisorInfo();
    var customerPrice = "0";
    if (price.isNotEmpty) {
      customerPrice = price;
    }

    int packageType = 0;
    int? packageId = 0;
    String packageAmount = "0";
    if (selectedBookingType.value.id == 3) {
      packageType = selectedPackageType.value.id;
      packageId = packageData.value.id == 001 ? 0 : packageData.value.id;
      if (packageId == 0) {
        packageAmount = "0";
      } else {
        packageAmount = packageData.value.amount.toString();
      }
    } else {
      packageType = 0;
      packageId = 0;
      packageAmount = "0";
    }

    printLogs("hi package: $packageType $packageId $packageAmount");
    int? fareType = 0;
    if (selectedTripRadioValue.value == 2) {
      fareType = roundTripselectedTripRadioValue.value;
    } else {
      fareType = 0;
    }

    int? taxi = 0;
    if (taxiId.value.isNotEmpty) {
      taxi = int.parse(taxiId.value);
    } else {
      taxi = 0;
    }

    int? carMake = 0;
    if (carMakeId.value.isNotEmpty) {
      carMake = int.parse(carMakeId.value);
    } else {
      carMake = 0;
    }

    saveBookingApi(SaveBookingRequest(
            approx_distance: "${approximateDistance.value.toString()} km",
            approx_duration: "${approximateTime.value.toString()} mins",
            // approx_trip_fare: double.parse(approximateFare.value),
            approx_trip_fare: selectedBookingType.value.id == 3
                ? double.parse(packageAmount)
                : double.parse(approximateFare.value),
            drop_latitude: dropLatitude,
            drop_longitude: dropLongitude,
            dropplace: dropLocation,
            guest_name: name,
            guest_country_code: "+${countryCode.value}",
            guest_phone: phone,
            guest_email: email,
            latitude: pickupLatitude,
            longitude: pickupLongitude,
            motor_model: taxi,
            car_make_id: carMake,
            now_after: selectedBookingType.value.id,
            corporate_id: int.parse(corporateId ?? "0"),
            passenger_payment_option:
                int.parse(selectedPayment.value.paymentId),
            pickupplace: pickupLocation,
            pickup_time: date,
            note_to_driver: noteToDriver,
            note_to_admin: noteToAdmin,
            flight_number: flightNumber,
            reference_number: refNumber,
            customer_price: double.parse(customerPrice),
            route_polyline: overViewPolyLine.value,
            customer_rate: customerRate,
            extra_charge: extraCharges,
            remarks: remarks,
            zone_fare_applied: zoneFareApplied.value,
            rsl_share: rslShare,
            driver_share: driverShare,
            corporate_share: corporateShare,
            pickup_zone_id: pickupZoneId,
            pickup_zone_group_id: pickupZoneGroupId,
            drop_zone_id: dropZoneId,
            drop_zone_group_id: dropZoneGroupId,
            supervisorId: supervisorInfo?.supervisorId ?? "",
            kioskId: supervisorInfo?.kioskId ?? "",
            cid: supervisorInfo?.cid ?? "",
            roomNo: roomNo,
            package_type: packageType,
            package_id: packageId,
            trip_type: selectedTripRadioValue.value,
            double_the_fare: fareType))
        .then((response) {
      saveBookingApiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        showDefaultDialog(
          context: Get.context!,
          title: "Alert",
          message: "Do you want to track this trip?",
          isTwoButton: true,
          acceptBtnTitle: "Yes",
          acceptAction: () {
            changeTabIndex(1);
            tabController?.animateTo(1);
            Get.find<BookingsListController>().startTripListTimer();
            Get.find<BookingsListController>().callTripListOngoingApi(type: 1);
          },
          cancelBtnTitle: "No",
        );
        clearAllData();
      } else {
        saveBookingApiLoading.value = false;
        showDefaultDialog(
          context: Get.context!,
          title: "Alert",
          message: response.message ?? "Something went wrong...",
        );
      }
    }).onError((error, stackTrace) {
      saveBookingApiLoading.value = false;
      printLogs("SaveBooking api error: ${error.toString()}");
    });
  }

  void callCarMakeListApi(SupervisorInfo? supervisorInfo) async {
    allCarMakesApi().then((response) {
      // apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        carModelList.value = response.carMakeDetails?.carMakeList ?? [];
        carModelList.refresh();
        if (carModelList.isNotEmpty) {
          taxiModel.value = carModelList[0].car_make_name.toString();
          taxiId.value = carModelList[0].model_id.toString();
          carMakeId.value = carModelList[0].car_make_id.toString();
        }
        callGetCorporatePackageListApi(false);
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

  void carMakeFareApi() async {
    if (pickupLatitude != 0.0 && dropLatitude != 0.0) {
      apiLoading.value = true;
      var corporateId = await GetStorageController().getCorporateId();
      supervisorInfo = await GetStorageController().getSupervisorInfo();
      getCarMakeFareApi(CarMakeFareRequest(
              supervisorId: supervisorInfo?.supervisorId ?? "",
              kioskId: supervisorInfo?.kioskId ?? "",
              corporateId: corporateId,
              cid: supervisorInfo?.cid ?? "",
              pickup_latitude: pickupLatitude,
              pickup_longitude: pickupLongitude,
              drop_latitude: dropLatitude,
              drop_longitude: dropLongitude,
              distance: approximateDistance.value,
              modelId: taxiId.value.toString(),
              carMakeId: carMakeId.value.toString()))
          .then((response) {
        apiLoading.value = false;
        if ((response.status ?? 0) == 1) {
          // motorModelList = response.fareDetailList ?? [];
          updateModelFareDetails(response.carMakeDetails?.carMakeFareDetails);
          carMakeFareDetails.value =
              response.carMakeDetails?.carMakeFareDetails ??
                  CarMakeFareDetails();
          // extraChargesController.clear();
        }
      }).onError((error, stackTrace) {
        apiLoading.value = false;
        printLogs("CarModel api error: ${error.toString()}");
      });
    }
  }

  void updateModelFareDetails(CarMakeFareDetails? carMakeFareDetails) {
    approximateFare.value = carMakeFareDetails?.fare?.toString() ?? "0";
    zoneFareApplied.value = carMakeFareDetails?.zoneFareApplied ?? 0;

    if (zoneFareApplied.value == 1) {
      rslShare = carMakeFareDetails?.rslShare ?? 0;
      driverShare = carMakeFareDetails?.driverShare ?? 0;
      corporateShare = carMakeFareDetails?.corporateShare ?? 0;
      pickupZoneId = carMakeFareDetails?.pickupZoneId ?? 0;
      pickupZoneGroupId = carMakeFareDetails?.pickupZoneGroupId ?? 0;
      dropZoneId = carMakeFareDetails?.dropZoneId ?? 0;
      dropZoneGroupId = carMakeFareDetails?.dropZoneGroupId ?? 0;
      priceController.text = carMakeFareDetails?.fare?.toString() ?? "";
      originalPrice = priceController.text;
      // customerPriceValue = carMakeFareDetails?.fare?.toString() ?? "";
      doubleTheFareCalculation();
    } else {
      rslShare = 0;
      driverShare = 0;
      corporateShare = 0;
      pickupZoneId = 0;
      pickupZoneGroupId = 0;
      dropZoneId = 0;
      dropZoneGroupId = 0;
      priceController.clear();
      originalPrice = "0";
      // customerPriceValue = "0";
    }
  }

  void _calculateTimeAndDistance() async {
    apiLoading.value = true;
    googleMapApi(pickupLatitude, pickupLongitude, dropLatitude, dropLongitude)
        .then((response) {
      fetchOverviewPolyline(response);
    });
  }

  void fetchOverviewPolyline(Map<String, dynamic> response) {
    double time = 0.0, distance = 0.0, trafficTime = 0.0;
    try {
      apiLoading.value = false;
      if (response['routes'] != null) {
        final routeArray = response['routes'] as List<dynamic>;
        if (routeArray.isNotEmpty) {
          final routes = routeArray[0] as Map<String, dynamic>;

          final overviewPolyLines =
              routes['overview_polyline'] as Map<String, dynamic>;

          final overViewPoly = overviewPolyLines['points'] as String? ?? '';

          overViewPolyLine.value = overViewPoly;

          final legsArray = routes['legs'] as List<dynamic>;
          for (var i = 0; i < legsArray.length; i++) {
            final timeObject =
                legsArray[i]['duration'] as Map<String, dynamic>?;
            final legTime = timeObject?['value'] as int?;
            if (legTime != null) {
              time += legTime;
            }

            final distanceObject =
                legsArray[i]['distance'] as Map<String, dynamic>?;
            final legDistance = distanceObject?['value'] as int?;
            if (legDistance != null) {
              distance += legDistance;
            }

            final trafficTimeObject =
                legsArray[i]['duration_in_traffic'] as Map<String, dynamic>?;
            final legTrafficTime = trafficTimeObject?['value'] as int?;
            if (legTrafficTime != null) {
              trafficTime += legTrafficTime;
            }
          }

          approximateTime.value = doubleWithTwoDigits((time / 60));
          approximateTrafficTime.value = doubleWithTwoDigits(trafficTime / 60);
          approximateDistance.value = doubleWithTwoDigits(distance / 1000);
          carMakeFareApi();
          print(
              "POLYLINE  Time:${approximateTime.value} Distance:${approximateDistance.value} RoutePolyline:${overViewPoly.toString()}");
        }
      }
    } catch (e) {
      printLogs(e);
      _resetApproximateTimeDistance();
      apiLoading.value = false;
    }
  }

  void _resetApproximateTimeDistance() {
    approximateTime.value = 0;
    approximateTrafficTime.value = 0;
    approximateDistance.value = 0;
    overViewPolyLine.value = "";
    approximateFare.value = "0";
    motorModelList.clear();
    zoneFareApplied.value = 0;
    rslShare = 0;
    driverShare = 0;
    corporateShare = 0;
    pickupZoneId = 0;
    pickupZoneGroupId = 0;
    dropZoneId = 0;
    dropZoneGroupId = 0;
  }

  void getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    if (supervisorInfo == null) {
      return;
    }

    var corporateInfo = await GetStorageController().getCorporateInfo();
    if (corporateInfo == null) {
      return;
    }
    nameController.text = corporateInfo.corporateName ?? "";
    var country = corporateInfo.corporateCountryCode ?? "971";
    if (country.contains("+")) {
      String countryCodeValue = country.replaceAll('+', '');
      countryCode.value = countryCodeValue;
    } else {
      countryCode.value = country;
    }

    phoneController.text = corporateInfo.corporatePhoneNumber ?? "";
    emailController.text = corporateInfo.corporateEmail ?? "";
    pickupLocationController.text = corporateInfo.corporateLocation ?? "";
    pickupLatitude = (corporateInfo.corporateLat ?? 0).toDouble();
    pickupLongitude = (corporateInfo.corporateLong ?? 0).toDouble();

    callCarMakeListApi(supervisorInfo);

    if (pickupLatitude == 0.0 && pickupLongitude == 0.0) {
      LocationResult<Position> result =
          await locationManager.getCurrentLocation();
      pickupLatitude = result.data!.latitude ?? 0.0;
      pickupLongitude = result.data!.longitude ?? 0.0;

      List<Placemark> locations =
          await placemarkFromCoordinates(pickupLatitude, pickupLongitude);
      pickupLocationController.text =
          "${locations[0].name},${locations[0].locality} ${locations[0].country}";
    }
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
      if (pickupLatitude != 0.0 && dropLatitude != 0.0) {
        _calculateTimeAndDistance();
      }
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

      if (pickupLatitude != 0.0 && dropLatitude != 0.0) {
        _calculateTimeAndDistance();
      }
    }
  }

  void showCustomDialog(BuildContext context) {
/*    final List<dynamic> staticImageUrls = [
      {'model_id': 1, 'image': "assets/dashboard_page/sedan.png"},
      {'model_id': 10, 'image': "assets/dashboard_page/xl.png"},
      {'model_id': 23, 'image': "assets/dashboard_page/vip.png"},
      {'model_id': 19, 'image': "assets/dashboard_page/vip_plus.png"},
    ];*/
    final List<Car> cars = [];
    for (final carModel in carModelList) {
      /*
      final imageUrl = staticImageUrls.firstWhere(
          (element) => element['model_id'] == carModel.model_id,
          orElse: () => {'image': "assets/dashboard_page/tesla.png"})['image'];
     */
      final car = Car(
        name: carModel.car_make_name ?? "",
        imageUrl: carModel.beforeSelect ?? "",
        modelId: carModel.model_id?.toString() ?? "",
        carMakeId: carModel.car_make_id?.toString() ?? "",
      );
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
                          backgroundColor: Colors.white,
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
                                /*Image.asset(
                                  cars[selectedCarIndex].imageUrl,
                                  width: 250.w,
                                  height: 250.h,
                                ),*/
                                Center(
                                  child: CachedNetworkImage(
                                    imageUrl: cars[selectedCarIndex].imageUrl,
                                    placeholder: (context, url) => const Center(
                                      child: AppLoader(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    width: 250.w,
                                    height: 250.h,
                                  ),
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
                                const SizedBox(
                                  height: 25,
                                ),
                                CustomButton(
                                    width: double.maxFinite,
                                    linearColor: primaryButtonLinearColor,
                                    height: 38.h,
                                    borderRadius: 38.h / 2,
                                    style:
                                        AppFontStyle.body(color: Colors.white),
                                    text: 'Submit',
                                    onTap: () => {
                                          /* carModelController.text =
                                            cars[selectedCarIndex].name,*/
                                          taxiModel.value =
                                              cars[selectedCarIndex].name,
                                          taxiId.value =
                                              cars[selectedCarIndex].modelId,
                                          carMakeId.value =
                                              cars[selectedCarIndex].carMakeId,
                                          carMakeFareApi(),
                                          callGetCorporatePackageListApi(true),
                                          /*if (selectedBookingType.value.id == 3)
                                        {
                                          callGetCorporatePackageListApi(
                                              true),
                                        },*/
                                          animationController.reverse().then(
                                            (value) {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        }),
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
