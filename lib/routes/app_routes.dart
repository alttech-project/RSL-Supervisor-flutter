import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/app.dart';
import 'package:rsl_supervisor/views/details_page.dart';
import 'package:rsl_supervisor/views/home_page.dart';
import 'package:rsl_supervisor/views/others_page.dart';

List<GetPage> routes = [
  GetPage(name: Home.routeName, page: () => Home()),
  GetPage(name: AppStart.routeName, page: () => Home()),
  GetPage(
    name: Other.routeName,
    page: () => const Other(),
    customTransition: SizeTransitions(),
  ),
// GetPage with default transitions
  GetPage(
    name: DetailsPage.routeName,
    transition: Transition.cupertino,
    page: () => const DetailsPage(),
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
