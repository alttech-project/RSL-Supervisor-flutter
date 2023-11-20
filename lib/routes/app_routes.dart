import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/bindings/app_bindings.dart';
import 'package:rsl_supervisor/bookings/bookings_page.dart';
import 'package:rsl_supervisor/bookings/edit_booking.dart';
import 'package:rsl_supervisor/dashboard/views/dashboard_page.dart';
import 'package:rsl_supervisor/driver_list/view/driver_list_page.dart';
import 'package:rsl_supervisor/leaderboard/views/leaderBoard_view_page.dart';
import 'package:rsl_supervisor/feeds/view/feeds_page.dart';
import 'package:rsl_supervisor/location_queue/views/fare_selection_page.dart';
import 'package:rsl_supervisor/location_queue/views/location_queue_page.dart';
import 'package:rsl_supervisor/login/view/capture_image_page.dart';
import 'package:rsl_supervisor/my_trip/views/my_trip_list_edit_fare_page.dart';
import 'package:rsl_supervisor/my_trip/views/my_trip_list_page.dart';
import 'package:rsl_supervisor/offlineTrip/views/offline_trip_page.dart';
import 'package:rsl_supervisor/quickTrip/views/drop_location_page.dart';
import 'package:rsl_supervisor/quickTrip/views/quick_trip_page.dart';
import 'package:rsl_supervisor/reorderable_list_page.dart';
import 'package:rsl_supervisor/rider_refferral/views/rider_referral_page.dart';
import 'package:rsl_supervisor/subscribers/views/subscriber_list_page.dart';
import 'package:rsl_supervisor/trip_details/views/qr_page.dart';
import 'package:rsl_supervisor/trip_details/views/trip_details_page.dart';
import 'package:rsl_supervisor/trip_history/views/trip_history_map_page.dart';
import 'package:rsl_supervisor/trip_history/views/trip_history_page.dart';

import '../dispatch/dispatch_page.dart';
import '../login/view/login_page.dart';
import '../my_trip/views/my_trip_list_map_page.dart';
import '../my_trip/views/my_trip_list_qr_page.dart';
import '../my_trip/views/my_trip_list_detail_page.dart';
import '../place_search/views/place_search_view.dart';
import '../rider_refferral/views/referral_history_page.dart';
import '../scanner/views/scanner_page.dart';
import '../trip_details/views/edit_fare_page.dart';
import '../video/upload_video_page.dart';

class AppRoutes {
  static const home = '/';
  static const loginPage = '/loginPage';
  static const dashboardPage = '/dashboardPage';
  static const placeSearchPage = '/placeSearchPage';
  static const quickTripPage = '/quickTripPage';
  static const locationQueuePage = '/locationQueuePage';
  static const fareSelectionPage = '/fareSelectionPage';
  static const qrScannerPage = '/qrScannerPage';
  static const offlineTripPage = '/offlineTripPage';
  static const bookings = "/bookings";
  static const editBookings = "/editBookings";
  static const tripHistoryPage = '/tripHistoryPage';
  static const subscriberPage = '/subscriberPage';
  static const tripDetailPage = '/tripDetailPage';
  static const qrPage = '/qrPage';
  static const editFarePage = '/editFarePage';
  static const riderRefferalPage = '/riderRefferalPage';
  static const riderReferralHistoryPage = '/riderReferralHistoryPage';
  static const leaderBoaradPage = '/leaderBoaradPage';
  static const captureImagePage = '/captureImagePage';
  static const feedsPage = '/feedsPage';
  static const tripHistoryMapPage = '/tripHistoryMapPage';
  static const dispatchPage = '/dispatchPage';
  static const uploadVideoPage = '/uploadVideoPage';
  static const tripListPage = '/tripListPage';
  static const tripListMapPage = '/tripListMapPage';
  static const mytripDetailPage = '/mytripDetailPage';
  static const mytripQrPage = '/mytripQrPage';
  static const mytripEditfarepage = '/mytripEditfarepage';

  static const driverListPage = '/driverListPage';
  static const dropLocationPage = '/dropLocationPage';
  static const reOrderPage = '/reOrderPage';
}

List<GetPage> routes = [
  GetPage(
    name: AppRoutes.loginPage,
    page: () => const LoginPage(),
    binding: AppBind(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.dashboardPage,
    page: () => const DashboardPage(),
    binding: AppBind(),
    transition: Transition.fadeIn,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.placeSearchPage,
    page: () => const PlaceSearchPage(),
    binding: AppBind(),
    transition: Transition.downToUp,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.quickTripPage,
    page: () => const QuickTripPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.locationQueuePage,
    page: () => const LocationQueuePage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.fareSelectionPage,
    page: () => const FareSelectionPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.qrScannerPage,
    page: () => const ScannerPage(),
    binding: AppBind(),
    transition: Transition.downToUp,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.offlineTripPage,
    page: () => const OfflineTripPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.bookings,
    page: () => const BookingsPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.editBookings,
    page: () => const EditBooking(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.tripHistoryPage,
    page: () => const TripHistoryPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.captureImagePage,
    page: () => const CaptureImageScreen(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.feedsPage,
    page: () => const FeedsScreen(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.subscriberPage,
    page: () => const SubscribersPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.tripDetailPage,
    page: () => TripDetailsPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.qrPage,
    page: () => QRCodeGenerator(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.editFarePage,
    page: () => const EditFarePage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.riderRefferalPage,
    page: () => const RiderReferralPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.riderReferralHistoryPage,
    page: () => const RiderReferralHistoryPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.leaderBoaradPage,
    page: () => const LeaderBoardPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.tripHistoryMapPage,
    page: () => TripHistoryMapPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.dispatchPage,
    page: () => const DispatchPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.uploadVideoPage,
    page: () => const UploadVideoPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.driverListPage,
    page: () => const DriverListScreen(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.dropLocationPage,
    page: () => const DropLocationPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.tripListPage,
    page: () => const MyTripListPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.tripListMapPage,
    page: () => const MyTripListMapPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.mytripDetailPage,
    page: () => const ListTripDetailsPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.mytripQrPage,
    page: () => MyTripListQRCodeGenerator(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.mytripEditfarepage,
    page: () => const MyTripListEditFarePage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
  GetPage(
    name: AppRoutes.reOrderPage,
    page: () => ReorderableListPage(),
    binding: AppBind(),
    transition: Transition.rightToLeft,
    transitionDuration: const Duration(milliseconds: 200),
  ),
];

class SizeTransitions extends CustomTransition {
  @override
  Widget buildTransition(
      BuildContext context,
      Curve? curve,
      Alignment? alignment,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    return Align(
      alignment: Alignment.center,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: curve!,
        ),
        child: child,
      ),
    );
  }
}
