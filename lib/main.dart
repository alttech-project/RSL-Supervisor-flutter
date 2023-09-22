import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/bindings/app_bindings.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';

import 'app.dart';
import 'shared/styles/theme.dart';

Future<void> main() async {

  await initServices();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    runApp(const AppMain());
  });
}

Future<void> initServices() async {
  await Get.putAsync(() => GetStorage.init());
  await Firebase.initializeApp();
}

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      child: const AppStart(),
      builder: (BuildContext context, Widget? child) {
        return _runMainApp(child: child);
      },
    );
  }

  GetMaterialApp _runMainApp({required Widget? child}) {
    return GetMaterialApp(
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'RSL-Supervisor',
      theme: themeData,
      home: child,
      initialBinding: AppBind(),
      getPages: routes,
      initialRoute: "/",
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child ?? Container(),
        );
      },
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
