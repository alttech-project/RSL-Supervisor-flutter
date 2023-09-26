
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../routes/app_routes.dart';
import '../../trip_history/data/trip_history_map_data.dart';
import '../../trip_history/service/trip_history_services.dart';
import '../../utils/helpers/alert_helpers.dart';
import '../../utils/helpers/basic_utils.dart';
import '../../utils/helpers/getx_storage.dart';
import 'my_trip_list_controller.dart';

class MyTripListMapController extends GetxController {
  // RxList<MapDatas> mapdatas = <MapDatas>[].obs;
  // RxList<Marker> markers = <Marker>[].obs;
  // RxInt selectedTriId = 0.obs;
  // SupervisorInfo supervisorInfo = SupervisorInfo();
  // RxString getTripId = "".obs;
  // RxBool showLoader = false.obs;
  // final tripListController = Get.find<MyTripListController>();
  //
  // @override
  // void onInit() {
  //   super.onInit();
  //   callTripHistoryMapApi(int.parse(getTripId.value), supervisorInfo.cid);
  // }
  //
  // void callTripHistoryMapApi(int? tripId, String? cid) async {
  //   FocusScope.of(Get.context!).requestFocus(FocusNode());
  //   showLoader.value = true;
  //   tripHistoryMapApi(
  //     TripHistoryMapRequestedData(tripId: tripId, cid: cid),
  //   ).then(
  //     (response) {
  //       showLoader.value = false;
  //       if (response.status == 1) {
  //         mapdatas.value = response.detail?.mapDatas ?? [];
  //         mapdatas.refresh();
  //         if (mapdatas.isNotEmpty) {
  //           _pickUpMarker();
  //           _dropMarker();
  //         }
  //       } else {
  //         showSnackBar(
  //           title: 'Error',
  //           msg: response.message ?? "Something went wrong",
  //         );
  //       }
  //     },
  //   ).onError(
  //     (error, stackTrace) {
  //       showLoader.value = false;
  //       showDefaultDialog(
  //         context: Get.context!,
  //         title: "Error",
  //         message: error.toString(),
  //       );
  //     },
  //   );
  // }
  //
  // void moveToMapPage(String tripId) {
  //   getTripId.value = tripId ?? "";
  //   Get.toNamed(
  //     AppRoutes.tripListMapPage,
  //   );
  // }
  //
  // _dropMarker() async {
  //   LatLng endLocation = LatLng(
  //       mapdatas.value[mapdatas.length - 1].latitude ?? 0,
  //       mapdatas.value[mapdatas.length - 1].longitude ?? 0);
  //   tripListController.addMarker(
  //       endLocation, "Drop", await tripListController.getDropIcons());
  // }
  //
  // _pickUpMarker() async {
  //   LatLng startLocation = LatLng(
  //       mapdatas.value[0].latitude ?? 0, mapdatas.value[0].longitude ?? 0);
  //   tripListController.addMarker(
  //       startLocation, "PickUp", await tripListController.getPickUpIcons());
  // }
}
