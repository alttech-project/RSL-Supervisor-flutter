import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/bindings/app_bindings.dart';
import 'package:rsl_supervisor/dashboard/views/dashboard_page.dart';
import 'package:rsl_supervisor/feeds/view/feeds_page.dart';
import 'package:rsl_supervisor/location_queue/views/fare_selection_page.dart';
import 'package:rsl_supervisor/location_queue/views/location_queue_page.dart';
import 'package:rsl_supervisor/login/view/capture_image_page.dart';
import 'package:rsl_supervisor/offlineTrip/views/offline_trip_page.dart';
import 'package:rsl_supervisor/quickTrip/views/quick_trip_page.dart';
import 'package:rsl_supervisor/trip_history/views/trip_history_page.dart';

import '../login/view/login_page.dart';
import '../place_search/views/place_search_view.dart';
import '../scanner/views/scanner_page.dart';

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
  static const tripHistoryPage = '/tripHistoryPage';
  static const captureImagePage = '/captureImagePage';
  static const feedsPage = '/feedsPage';
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
    transition: Transition.downToUp,
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
    transition: Transition.leftToRightWithFade,
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
