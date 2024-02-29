import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:rsl_supervisor/bookings/controller/booking_list_controller.dart';
import 'package:rsl_supervisor/bookings/data/edit_trip_details_data.dart';
import 'package:rsl_supervisor/place_search/data/get_place_details_response.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../dashboard/data/car_model_type_api.dart';
import '../../dashboard/service/dashboard_service.dart';
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
import '../data/edit_details_data.dart';
import '../data/get_car_make_fare_data.dart';
import '../data/get_package_data.dart';
import '../data/motor_details_data.dart';
import '../service/booking_service.dart';

double doubleWithTwoDigits(double value) =>
    double.parse(value.toStringAsFixed(2));

class EditBookingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final LocationManager locationManager = LocationManager();
  var selectedTabBar = 0.obs;
  TabController? tabController;
  RxInt editBookingTripId = 0.obs;
  RxString initialCountryCode = 'AE'.obs;

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

  var countryCode = '971'.obs;
  double pickupLatitude = 0.0, pickupLongitude = 0.0;
  double dropLatitude = 0.0, dropLongitude = 0.0;

  var taxiModel = ''.obs;
  var taxiId = ''.obs;
  var carMakeId = ''.obs;

  Rx<Payments> selectedPayment = paymentList[0].obs;

  RxBool showCustomPricing = false.obs;
  RxBool showAdditionalElements = false.obs;

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
  RxBool isValueChanged = false.obs;
  String originalPrice = "0";

  var packageId = "".obs;
  RxInt selectedTripRadioValue = 1.obs;
  RxInt roundTripselectedTripRadioValue = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getDate();
    _getUserInfo();
  }

  void goBack() {
    Get.back();
  }

  void tripTypeSelectedRadio(int? value) {
    selectedTripRadioValue.value = value ?? 0;
  }

  void roundedSelectedRadio(int? value) {
    roundTripselectedTripRadioValue.value = value ?? 0;
  }

  void callGetByPassengerDetailsApi({String? tripId}) async {
    apiLoading.value = true;
    var corporateId = await GetStorageController().getCorporateId();
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    getByPassengerEditDetails(GetByPassengerEditDetailsRequest(
      id: "$tripId",
    )).then((response) {
      apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        updatePassengerDetails(response.responseData);
      }
    }).onError((error, stackTrace) {
      apiLoading.value = false;
      printLogs("GetByPassengerDetails Api Error: ${error.toString()}");
    });
  }

  void updatePassengerDetails(PassengerDetails? details) {
    if (details != null) {
      editBookingTripId.value = details.id ?? 0;
      nameController.text = details.guest_name ?? "";
      if (details.guest_country_code != null) {
        countryCode.value = details.guest_country_code!.replaceAll("+", "");
      } else {
        countryCode.value = "971";
      }
      convertDialCodeToCountryIso();
      phoneController.text = details.guest_phone ?? "";
      emailController.text = details.guest_email ?? "";
      pickupLocationController.text = details.current_location ?? "";
      dropLocationController.text = details.drop_location ?? "";
      pickupLatitude = details.pickup_latitude ?? 0.0;
      pickupLongitude = details.pickup_longitude ?? 0.0;
      dropLatitude = details.drop_latitude ?? 0.0;
      dropLongitude = details.drop_longitude ?? 0.0;
      dateController.text = details.pickup_time ?? "";
      priceController.text = (details.customer_price ?? "").toString();
      originalPrice = priceController.text.toString();
      extraChargesController.text = (details.extra_charge ?? "").toString();
      noteToDriverController.text = details.note_to_driver ?? "";
      noteToAdminController.text = details.note_to_admin ?? "";
      flightNumberController.text = details.flight_number ?? "";
      refNumberController.text = details.reference_number ?? "";
      roomNumberController.text = details.room_number ?? "";
      remarksController.text = details.remarks ?? "";
      customRateController.text = details.customer_rate.toString() ?? "";
      taxiModel.value = details.car_make_info?.car_make_name ?? "";
      taxiId.value = (details.motor_model_info?.modelId ?? "").toString();
      carMakeId.value = (details.car_make_info?.car_make_id ?? "").toString();
      rslShare = details.rsl_share ?? 0;
      driverShare = details.driver_share ?? 0;
      corporateShare = details.corporate_share ?? 0;
      zoneFareApplied.value = details.zone_fare_applied ?? 0;
      pickupZoneId = details.pickup_zone_id ?? 0;
      pickupZoneGroupId = details.pickup_zone_group_id ?? 0;
      dropZoneId = details.drop_zone_id ?? 0;
      dropZoneGroupId = details.drop_zone_group_id ?? 0;
      approximateTime.value =
          double.parse(details.approx_duration.toString() ?? "0");
      approximateDistance.value =
          double.parse(details.approx_distance.toString() ?? "0");
      approximateFare.value = details.approx_trip_fare.toString() ?? "0";

      overViewPolyLine.value = details.route_polyline ?? "";
      for (var value in paymentList) {
        if (details.passenger_payment_option.toString() == value.paymentId) {
          selectedPayment.value = value;
        }
      }

      for (var value in bookingTypeList) {
        if (details.now_after == value.id) {
          selectedBookingType.value = value;
        }
      }

      for (var value in packageTypeList) {
        if (details.package_type == value.id) {
          selectedPackageType.value = value;
        }
      }

      /*for (var value in packageList) {
        if (details.package_id == value.id) {
          packageData.value = value;
        }
      }*/
      packageId.value = details.package_id.toString();
      selectedTripRadioValue.value = details.trip_type ?? 0;
      roundTripselectedTripRadioValue.value = details.double_the_fare ?? 1;
      // carMakeFareApi();
      callGetCorporatePackageListApi(false, packageId: packageId.value);
    }
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
      /*else if (extraCharges.isNotEmpty &&
          extraCharges != "0" &&
          double.parse(extraCharges) <= 0) {
        _showSnackBar('Validation!', 'Enter a valid extra charges!');
      }*/
      /* else if (remarks.isEmpty) {
        _showSnackBar('Validation!', 'Enter a valid remarks!');
      } */
      else {
        if (supervisorInfo == null) {
          _showSnackBar('Error!', 'Invalid user login status!');
          return;
        }
        showDefaultDialog(
          context: Get.context!,
          title: "Alert",
          message: "Do you want to update booking details?",
          isTwoButton: true,
          acceptBtnTitle: "Yes",
          acceptAction: () {
            callEditBookingApi();
          },
          cancelBtnTitle: "No",
        );
      }
    }
  }

  void calculateShares(double customerPriceValue) {
    double rslShareValue = (customerPriceValue * 0.15 * 100).round() / 100;

    if (customerPriceValue <= 20.0) {
      rslShareValue = customerPriceValue;
    } else if (rslShareValue < 20.0) {
      rslShareValue = 20.0;
    }

    double driverShareValue = customerPriceValue - rslShareValue;
    double driverShares = driverShareValue.clamp(0, double.infinity);
    rslShare = rslShareValue;
    driverShare = driverShares;
    printLogs("hello rslShare ${rslShare} ${driverShare}");
  }

  void handleExtraCharge(String value) {
    // printLogs("hello originalPrice ${originalPrice}");
    if (value.contains('-')) {
      String absoluteValue = value.replaceAll('-', '');
      double enteredValue = double.parse(absoluteValue) ?? 0;
      if (enteredValue > double.parse(originalPrice)) {
        setExtraChargeError(true);
        return;
      } else {
        setExtraChargeError(false);
      }
      double extraChargeValue = enteredValue.isNaN ? 0 : enteredValue;
      double adjustedCustomerPrice =
          double.parse(originalPrice) - extraChargeValue;
      calculateShares(adjustedCustomerPrice);
      // setExtraChargeForMinus(true);
      priceController.text = adjustedCustomerPrice.toString();
    } else {
      double extraChargeValue = value.isEmpty ? 0 : double.parse(value) ?? 0;
      double adjustedCustomerPrice =
          double.parse(originalPrice) + extraChargeValue;
      calculateShares(adjustedCustomerPrice);
      // setExtraChargeForMinus(false);
      priceController.text = adjustedCustomerPrice.toString();
    }
  }

  void setExtraChargeForMinus() {
    extraChargesController.clear();
  }

  void setExtraChargeError(bool extraCharge) {
    if (extraCharge) {
      showSnackBar(
        title: 'Error',
        msg: "Extra Charges cannot be greater than the Customer Price",
      );
    }
  }

  void callEditBookingApi() async {
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

    supervisorInfo = await GetStorageController().getSupervisorInfo();
    var customerPrice = "0";
    if (price.isNotEmpty) {
      customerPrice = price;
    }

    var extraCharge = "0";
    if (extraCharges.isNotEmpty) {
      extraCharge = extraCharges;
    }

    int packageType = 0;
    int? packageId = 0;
    if (selectedBookingType.value.id == 3) {
      packageType = selectedPackageType.value.id;
      packageId = packageData.value.id == 001 ? 0 : packageData.value.id;
    } else {
      packageType = 0;
      packageId = 0;
    }

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

    editBookingApi(EditCorporateBookingRequestData(
            id: editBookingTripId.value,
            motor_model: taxi,
            // car_make_id: carMake,
            car_make_info: CarMakeInfo(
                car_make_id: carMake, car_make_name: taxiModel.value),
            pickupTime: date,
            extraCharge: double.parse(extraCharge),
            customerPrice: double.parse(priceController.text.trim()),
            rsl_share: rslShare,
            driver_share: driverShare,
            corporate_share: corporateShare,
            remarks: remarks,
            zone_fare_applied: zoneFareApplied.value,
            pickup_zone_id: pickupZoneId,
            pickup_zone_group_id: pickupZoneGroupId,
            drop_zone_id: dropZoneId,
            drop_zone_group_id: dropZoneGroupId,
            noteToDriver: noteToDriver,
            flightNumber: flightNumber,
            referenceNumber: refNumber,
            noteToAdmin: noteToAdmin,
            currentLocation: pickupLocation,
            dropLocation: dropLocation,
            pickupNotes: "",
            dropNotes: "",
            passengerPaymentOption: selectedPayment.value.paymentId,
            finalPaymentOption: selectedPayment.value.paymentId,
            now_after: selectedBookingType.value.id,
            customer_rate: customerRate,
            pickupLatitude: pickupLatitude,
            pickupLongitude: pickupLongitude,
            dropLatitude: dropLatitude,
            dropLongitude: dropLongitude,
            guestEmail: email,
            guestName: name,
            guestPhone: phone,
            guestCountryCode: "+${countryCode.value}",
            approx_distance: "${approximateDistance.value.toString()} km",
            approx_duration: "${approximateTime.value.toString()} mins",
            approx_trip_fare: double.parse(approximateFare.value),
            roomNo: roomNo,
            package_type: packageType,
            package_id: packageId,
            trip_type: selectedTripRadioValue.value,
            double_the_fare: fareType,
            route_polyline: overViewPolyLine.value))
        .then((response) {
      saveBookingApiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        clearAllData();
        goBackPage();
      } else {
        showDefaultDialog(
          context: Get.context!,
          title: "Alert",
          message: response.message ?? "Something went wrong...",
        );
      }
    }).onError((error, stackTrace) {
      saveBookingApiLoading.value = false;
      printLogs("EditBooking api error: ${error.toString()}");
    });
  }

  void goBackPage() {
    Get.back();
    Get.find<BookingsListController>().startTripListTimer();
    Get.find<BookingsListController>().callTripListOngoingApi(type: 1);
    changeTabIndex(1);
    tabController?.animateTo(1);
  }

  void callGetCorporatePackageListApi(showLoader,
      {String packageId = "0"}) async {
    var corporateId = "0";
    var corporateID = await GetStorageController().getCorporateId();
    if (corporateID.isNotEmpty) {
      corporateId = corporateID;
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
          packageType: selectedPackageType.value.id),
    ).then(
      (response) {
        apiLoading.value = false;
        if (response.status == 1) {
          packageList.clear();
          packageList.value = response.packageDetails?.packageList ?? [];
          packageList.insert(
              0, CorporatePackageList(id: 001, typeLabel: "Select Package"));
          packageList.refresh();

          //update package id
          if (packageId.isNotEmpty && packageId != "0") {
            for (var value in response.packageDetails?.packageList ?? []) {
              if (packageId == value.id.toString()) {
                packageData.value = value;
              }
            }
          } else {
            packageData.value = packageList[0];
          }
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

  void callCarMakeListApi() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();

    allCarMakesApi().then((response) {
      // apiLoading.value = false;
      if ((response.status ?? 0) == 1) {
        carModelList.value = response.carMakeDetails?.carMakeList ?? [];
        carModelList.refresh();
        // printLogs("hi carModelList ${taxiModel.value} ${carModelList}");
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
      originalPrice = priceController.text.toString();
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
    }
  }

  changeTabIndex(int value) {
    selectedTabBar.value = value;
  }

  String convertDialCodeToCountryIso() {
    try {
      String dialCode = countryCode.value.replaceAll("+", "");
      Country country = countries.firstWhere(
        (country) => country.dialCode == (dialCode),
      );
      initialCountryCode.value = country.code;
      return country.code;
    } catch (e) {
      initialCountryCode.value = 'AE';
      return 'AE';
    }
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
    selectedPayment.value = paymentList[0];
    countryCode.value = "971";
    initialCountryCode.value = "AE";
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
    roomNumberController.clear();
    clearPickUpLocation();
    clearDropLocation();
    overViewPolyLine.value = "";
    approximateTime.value = 0.0;
    approximateTrafficTime.value = 0.0;
    approximateDistance.value = 0.0;
    approximateFare.value = "0";
    customRateController.clear();
    selectedBookingType.value = bookingTypeList[0];
    selectedPackageType.value = packageTypeList[0];
    packageData.value = packageList[0];
    zoneFareApplied.value = 0;
    selectedTripRadioValue.value = 1;
    roundTripselectedTripRadioValue.value = 0;
    rslShare = 0;
    driverShare = 0;
    corporateShare = 0;
    pickupZoneId = 0;
    pickupZoneGroupId = 0;
    dropZoneId = 0;
    dropZoneGroupId = 0;
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
              "POLYLINE: Time:${approximateTime.value} Distance:${approximateDistance.value} RoutePolyline:${overViewPoly.toString()}");
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

  void _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    if (supervisorInfo == null) {
      return;
    }
    callCarMakeListApi();
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
    /* final List<dynamic> staticImageUrls = [
      {'motor_id': 1, 'image': "assets/dashboard_page/sedan.png"},
      {'motor_id': 10, 'image': "assets/dashboard_page/xl.png"},
      {'motor_id': 23, 'image': "assets/dashboard_page/vip.png"},
      {'motor_id': 19, 'image': "assets/dashboard_page/vip_plus.png"},
    ];*/
    final List<Car> cars = [];
    for (final carModel in carModelList) {
      /* final imageUrl = staticImageUrls.firstWhere(
          (element) => element['motor_id'] == carModel.model_id,
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
                                        carMakeId.value =
                                            cars[selectedCarIndex].carMakeId,
                                        isValueChanged.value = true,
                                        // updateModelFareDetails(),
                                        carMakeFareApi(),
                                        if (selectedBookingType.value.id == 3)
                                          {
                                            callGetCorporatePackageListApi(
                                                true),
                                          },
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
