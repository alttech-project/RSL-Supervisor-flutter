import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/bindings/app_bindings.dart';
import 'package:rsl_supervisor/dashboard/views/dashboard_page.dart';

import '../place_search/views/place_search_view.dart';
import '../login/view/login_page.dart';

class AppRoutes {
  static const home = '/';
  static const loginPage = '/loginPage';
  static const dashboardPage = '/dashboardPage';
  static const placeSearchPage = '/placeSearchPage';
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
