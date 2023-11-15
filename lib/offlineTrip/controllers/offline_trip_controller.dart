import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rsl_supervisor/place_search/data/get_place_details_response.dart';

import '../../routes/app_routes.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/offline_trip_api_data.dart';
import '../data/taxi_list_api_data.dart';
import '../services/offline_trip_service.dart';
import '../../utils/helpers/alert_helpers.dart';

class OfflineTripController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController taxiNoController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController searchCarController = TextEditingController();
  final TextEditingController referenceNumberController =
      TextEditingController();

  var taxiModel = ''.obs;
  var taxiId = ''.obs;
  var countryCode = '971'.obs;
  var apiLoading = false.obs;

  List<TaxiDetails> initialTaxiList = <TaxiDetails>[].obs;
  RxList<TaxiDetails> taxiList = <TaxiDetails>[].obs;

  SupervisorInfo? supervisorInfo;
  double dropLatitude = 0.0, dropLongitude = 0.0;

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
    taxiNoController.clear();
    taxiModel.value = "";
    taxiId.value = "";
  }

  void clearDropLocation() {
    dropLocationController.clear();
  }

  void filterCarNoResults(String text) {
    if (text.isEmpty) {
      getAllCarNoResults();
      return;
    }
    taxiList.value = initialTaxiList
        .where((taxiList) =>
            (taxiList.taxiNo ?? "").toLowerCase().contains(text.toLowerCase()))
        .toList();

    taxiList.refresh();
  }

  void clearSearchedCarNumber() {
    searchCarController.clear();
    getAllCarNoResults();
  }

  void getAllCarNoResults() {
    taxiList.value = initialTaxiList;
    taxiList.refresh();
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
        final taxiNo = taxiNoController.text.trim();
        final dropLocation = dropLocationController.text.trim();
        final fare = fareController.text.trim();
        final name = nameController.text.trim();
        final phone = phoneController.text.trim();
        final email = emailController.text.trim();
        final date = dateController.text.trim();
        final referenceNumber = referenceNumberController.text.trim();

        //GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)
        if (taxiNo.isEmpty) {
          _showSnackBar('Validation!', 'Enter a valid Car No!');
        } else if (fare.isEmpty) {
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
          offlineTripApi(
            DispatchOfflineTripRequestData(
                dropLatitude: dropLatitude,
                dropLongitude: dropLongitude,
                fare: fare,
                kioskId: supervisorInfo!.kioskId,
                taxiId: taxiId.value,
                supervisorName: supervisorInfo!.supervisorName,
                supervisorId: supervisorInfo!.supervisorId,
                supervisorUniqueId: supervisorInfo!.supervisorUniqueId,
                taxiModel: taxiModel.value,
                cid: supervisorInfo!.cid,
                name: name,
                countryCode: countryCode.value,
                mobileNo: phone,
                email: email,
                pickupDateTime: date,
                referenceNumber: referenceNumber),
          ).then((response) {
            apiLoading.value = false;
            _handleOfflineTripResponse(response);
          }).catchError((onError) {
            apiLoading.value = false;
            _showSnackBar('Error', 'Server Connection Error!');
          });
        }
      }
    }
  }

  void _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    // deviceToken = await GetStorageController().getDeviceToken();
    if (supervisorInfo == null) {
      return;
    }
    _callTaxiListApi();
  }

  void getDate() {
    dateController.text = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  void _callTaxiListApi() {
    apiLoading.value = true;
    taxiListApi(
      TaxiListRequestData(
        kioskId: '${supervisorInfo!.kioskId}',
        cid: '${supervisorInfo!.cid}',
      ),
    ).then((response) {
      apiLoading.value = false;
      _handleTaxiListResponse(response);
    }).catchError((onError) {
      apiLoading.value = false;
      showSnackBar(
        title: 'Error',
        msg: 'Server Connection Error!',
      );
    });
  }

  void _handleTaxiListResponse(TaxiListResponseData response) {
    switch (response.status) {
      case 1:
        initialTaxiList = response.details ?? [];
        taxiList.value = response.details ?? [];
        taxiList.refresh();
        break;
      default:
        showSnackBar(
            msg: response.message ?? 'Server Connection Error!',
            title: 'Error');
    }
  }

  void _showSnackBar(String title, String message) =>
      showSnackBar(msg: message, title: title);

  void _handleOfflineTripResponse(DispatchOfflineTripResponseData response) {
    switch (response.status) {
      case 1:
        showDefaultDialog(
          context: Get.context!,
          title: "Alert",
          message: response.message ?? "Something went wrong...",
        );
        dropLatitude = 0.0;
        dropLongitude = 0.0;
        dropLocationController.text = "";
        taxiNoController.text = "";
        fareController.text = "";
        nameController.text = "";
        phoneController.text = "";
        emailController.text = "";
        break;
      default:
        _showSnackBar('Error', response.message ?? 'Server Connection Error!');
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
