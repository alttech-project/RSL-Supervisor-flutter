import 'package:get/get.dart';
import 'package:rsl_supervisor/controllers/home_controller.dart';
import 'package:rsl_supervisor/dashboard/controllers/dashboard_controller.dart';
import 'package:rsl_supervisor/leaderboard/controllers/leaderboard_controller.dart';
import 'package:rsl_supervisor/feeds/controller/feeds_controller.dart';
import 'package:rsl_supervisor/login/controller/capture_image_controller.dart';
import 'package:rsl_supervisor/my_trip/controller/my_trip_list_controller.dart';
import 'package:rsl_supervisor/place_search/controller/place_search_controller.dart';
import 'package:rsl_supervisor/quickTrip/controllers/quick_trip_controller.dart';
import 'package:rsl_supervisor/rider_refferral/controllers/rider_referral_controller.dart';
import 'package:rsl_supervisor/scanner/controllers/scanner_controller.dart';
import 'package:rsl_supervisor/subscribers/controllers/subscriberpage_controller.dart';
import 'package:rsl_supervisor/trip_history/controllers/trip_history_controller.dart';
import 'package:rsl_supervisor/video/controller/upload_video_controller.dart';

import '../controllers/app_start_controller.dart';
import '../dispatch/controllers/dispatch_controller.dart';
import '../location_queue/controllers/location_queue_controller.dart';
import '../login/controller/login_controller.dart';
import '../network/services.dart';
import '../offlineTrip/controllers/offline_trip_controller.dart';
import '../utils/helpers/getx_storage.dart';

class AppBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<AppStartController>(() => AppStartController());
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<ApiProvider>(() => ApiProvider());
    Get.lazyPut<GetStorageController>(() => GetStorageController());
    Get.lazyPut<DashBoardController>(() => DashBoardController());
    Get.lazyPut<PlaceSearchController>(() => PlaceSearchController());
    Get.lazyPut<QuickTripController>(() => QuickTripController());
    Get.lazyPut<LocationQueueController>(() => LocationQueueController());
    Get.lazyPut<ScannerController>(() => ScannerController());
    Get.lazyPut<OfflineTripController>(() => OfflineTripController());
    Get.lazyPut<TripHistoryController>(() => TripHistoryController());
    Get.lazyPut<SubscribersController>(() => SubscribersController());
    Get.lazyPut<RiderReferralController>(() => RiderReferralController());
    Get.lazyPut<LeaderBoardController>(() => LeaderBoardController());
    Get.lazyPut<CaptureImageController>(() => CaptureImageController());
    Get.lazyPut<FeedsController>(() => FeedsController());
    Get.lazyPut<DispatchController>(() => DispatchController());
    Get.lazyPut<UploadVideoController>(() => UploadVideoController());
    Get.lazyPut<MyTripListController>(() => MyTripListController());

  }
}
