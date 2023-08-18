import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/place_search/data/get_place_details_response.dart';

import '../../quickTrip/data/quick_trip_api_data.dart';
import '../../quickTrip/service/quick_trip_services.dart';
import '../../routes/app_routes.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import '../data/taxi_list_api_data.dart';
import '../services/offline_trip_service.dart';

class OfflineTripController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController taxiNoController = TextEditingController();
  final TextEditingController dropLocationController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  var countryCode = '971'.obs;
  var apiLoading = false.obs;
  List<TaxiDetails> taxiList = <TaxiDetails>[].obs;

  SupervisorInfo? supervisorInfo;
  double dropLatitude = 0.0, dropLongitude = 0.0;

  @override
  void onInit() {
    super.onInit();
    _getUserInfo();
  }

  void clearTaxiNumber() {
    taxiNoController.clear();
  }

  void clearDropLocation() {
    dropLocationController.clear();
  }

  void checkValidation() {
    FocusScope.of(Get.context!).requestFocus(FocusNode());
    if (formKey.currentState!.validate()) {
      final taxiNo = taxiNoController.text.trim();
      final dropLocation = dropLocationController.text.trim();
      final fare = fareController.text.trim();
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();
      final email = emailController.text.trim();
      final date = dateController.text.trim();

      //GetUtils.isEmail(text) || GetUtils.isPhoneNumber(text)
      if (taxiNo.isEmpty) {
        _showSnackBar('Validation!', 'Enter a valid Trip ID!');
      } else if (dropLocation.isEmpty) {
        _showSnackBar('Validation!', 'Select / Enter a valid drop location!');
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
        dispatchQuickTripApi(
          DispatchQuickTripRequestData(
            tripId: taxiNo,
            kioskId: supervisorInfo!.kioskId,
            companyId: supervisorInfo!.cid,
            supervisorName: supervisorInfo!.supervisorName,
            supervisorId: supervisorInfo!.supervisorId,
            supervisorUniqueId: supervisorInfo!.supervisorUniqueId,
            name: name,
            countryCode: countryCode.value,
            mobileNo: phone,
            email: email,
            fixedMeter: (fare.isEmpty) ? '2' : '1',
            kioskFare: fare,
            paymentId: date,
            dropLatitude: dropLatitude,
            dropLongitude: dropLongitude,
            dropplace: dropLocation,
          ),
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

  void _getUserInfo() async {
    supervisorInfo = await GetStorageController().getSupervisorInfo();
    // deviceToken = await GetStorageController().getDeviceToken();
    if (supervisorInfo == null) {
      return;
    }

    _callTaxiListApi();
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
      showSnackBar('Server Connection Error!', title: 'Error');
    });
  }

  void _handleTaxiListResponse(TaxiListResponseData response) {
    switch (response.status) {
      case 1:
        taxiList = response.details ?? [];
        break;
      default:
        showSnackBar(response.message ?? 'Server Connection Error!',
            title: 'Error');
    }
  }

  void _showSnackBar(String title, String message) =>
      showSnackBar(message, title: title);

  void _handleOfflineTripResponse(DispatchQuickTripResponseData response) {}

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
