import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/routes/app_routes.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import 'package:rsl_supervisor/utils/helpers/getx_storage.dart';
import 'package:rsl_supervisor/views/services/splash_services.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../utils/assets/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final storageController = Get.find<GetStorageController>();

  double? _height = 0.h;
  double? _width = 0.w;
  @override
  void initState() {
    super.initState();
    _callGetCoreApi();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        setState(
          () {
            _height = ScreenUtil().screenHeight / 2;
            _width = ScreenUtil().screenWidth / 2;
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      statusBarColor: Colors.black,
      themedark: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25.r),
            child: AnimatedContainer(
              duration: const Duration(seconds: 4),
              width: _width,
              height: _height,
              curve: Curves.fastOutSlowIn,
              child: const ClipRRect(
                child: Image(
                  image: AssetImage(Assets.appIcon),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    /* return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          image: const AssetImage(Assets.appIcon),
          width: _width,
          height: _height,
        ),
      ),
    ); */
  }

  void _callGetCoreApi() {
    getCoreApi().then(
      (response) {
        if ((response.status ?? 0) == 1) {
          if (response.details != null) {
            var details = response.details;
            storageController.saveMonitorNodeUrl(
                url: details?.monitorNodeUrl ?? "");
            storageController.saveNodeUrl(url: details?.referralNodeUrl ?? "");
            storageController.saveRiderReferralUrl(
                url: details?.supervisorRiderReferral ?? 0);
            storageController.saveVideoDate(date: details?.videoDate ?? "");
            storageController.saveImageDate(date: details?.imgDate ?? "");
          }
          _checkLoginStatus();
        } else {
          showSnackBar(
            title: 'Alert',
            msg: response.message ?? "Something went wrong...",
          );
        }
      },
    ).onError(
      (error, stackTrace) {
        showSnackBar(
          title: 'Error',
          msg: error.toString(),
        );
      },
    );
  }

  void _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final userInfo = await storageController.getSupervisorInfo();
    if ((userInfo.supervisorId ?? "").isEmpty) {
      Get.offAllNamed(AppRoutes.loginPage);
    } else {
      Get.offAllNamed(AppRoutes.dashboardPage);
    }
  }
}
