import 'dart:html';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/place_search/data/get_place_details_response.dart';

import '../../routes/app_routes.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../../utils/helpers/location_manager.dart';

class BookingsController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final LocationManager locationManager = LocationManager();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController pickupLocationController =
      TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController fareController = TextEditingController();

  double pickupLatitude = 0.0, pickupLongitude = 0.0;
  double dropLatitude = 0.0, dropLongitude = 0.0;
  var countryCode = '971'.obs;
  var taxiModel = ''.obs;
  var taxiId = ''.obs;

  var apiLoading = false.obs;
  SupervisorInfo? supervisorInfo;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    getDate();
    _getUserInfo();
  }

  void clearTaxiNumber() {
    taxiModel.value = "";
    taxiId.value = "";
  }

  void clearDropLocation() {
    dropLocationController.clear();
  }

  void clearPickUpLocation() {
    pickupLocationController.clear();
  }

  void checkValidation() async {
    bool shiftStatus = await GetStorageController().getShiftStatus();
    if (!shiftStatus) {
      showSnackBar(
        title: 'Alert',
        msg: "You are not shift in.Please make shift in and try again!",
      );
    } else {
      FocusScope.of(Get.context!).requestFocus(FocusNode());
      if (formKey.currentState!.validate()) {
        final dropLocation = dropLocationController.text.trim();
        final fare = fareController.text.trim();
        final name = nameController.text.trim();
        final phone = phoneController.text.trim();
        final email = emailController.text.trim();
        final date = dateController.text.trim();

        //GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)
        /*  if (taxiNo.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid Car No!');
        }*/
        if (fare.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid fare!');
        } else if (phone.isNotEmpty && !GetUtils.isPhoneNumber(phone)) {
          _showSnackBar('Validation!', 'Enter a valid phone number!');
        } else if (email.isNotEmpty && !GetUtils.isEmail(email)) {
          _showSnackBar('Validation!', 'Enter a valid Email!');
        } else {
          if (supervisorInfo == null) {
            _showSnackBar('Error!', 'Invalid user login status!');
            return;
          }
          apiLoading.value = true;
        }
      }
    }
  }

  void _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    if (supervisorInfo == null) {
      return;
    }

    LocationResult<Position> result =
        await locationManager.getCurrentLocation();
    pickupLatitude = result.data!.latitude ?? 0.0;
    pickupLongitude = result.data!.longitude ?? 0.0;

    List<Placemark> locations =
        await placemarkFromCoordinates(pickupLatitude, pickupLongitude);
    print("locations ${locations}");
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
}
