import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/dashboard/views/dashboard_page.dart';
import 'package:rsl_supervisor/utils/helpers/getx_storage.dart';
import 'package:rsl_supervisor/views/splash_screen.dart';

import 'controllers/app_start_controller.dart';
import 'login/view/login_page.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    final storageController = Get.find<GetStorageController>();
    final appStartController = Get.find<AppStartController>();
    return FutureBuilder<Status>(
      future: appStartController.callGetCoreApi(storageController),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data?.status == 1) {
            return const DashboardPage();
          } else if (snapshot.data?.status == 2) {
            return const LoginPage();
          }
          return const SizedBox.shrink();
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}

class Status {
  int? status;

  Status({this.status});
}
