import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rsl_supervisor/bindings/app_bindings.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rsl_supervisor/utils/helpers/app_info.dart';
import 'package:rsl_supervisor/views/splash_screen.dart';

import 'local_notification/flutter_local_notification.dart';
import 'login/controller/login_controller.dart';
import 'shared/styles/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initServices();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) {
    runApp(const AppMain());
  });
}

Future<void> initServices() async {
  await Get.putAsync(() => GetStorage.init());
  await Firebase.initializeApp();
  await getAppInfo();
  final FlutterLocalNotify flutterLocalNotify = FlutterLocalNotify();
  flutterLocalNotify.initializeNotifications();
}

class AppMain extends StatelessWidget {
  const AppMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).orientation == Orientation.landscape
          ? const Size(640, 360) // Landscape design size
          : const Size(360, 640),
      // Portrait design size
      minTextAdapt: true,
      splitScreenMode: true,
      child: const SplashScreen(),
      builder: (BuildContext context, Widget? child) {
        return _runMainApp(child: child);
      },
    );
  }

  GetMaterialApp _runMainApp({required Widget? child}) {
    Get.put(LoginController());

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
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child ?? Container(),
        );
      },
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
