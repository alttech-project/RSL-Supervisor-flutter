import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/widgets/safe_area_container.dart';
import '../utils/assets/assets.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

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
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(seconds: 4),
                width: controller.width.value,
                height: controller.height.value,
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
      ),
    );
  }
}
