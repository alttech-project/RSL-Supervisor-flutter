import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsl_supervisor/shared/styles/colors.dart';

import '../utils/assets/assets.dart';
import '../widgets/safe_area_container.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeAreaContainer(
      statusBarColor: AppColor.kPrimaryColor.value,
      themedark: false,
      systemNavigationBarColor: AppColor.kPrimaryColor.value,
      NavigationBarthemedark: true,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: AppColor.kPrimaryColor.value,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.h,
                  width: 150.w,
                  child: Image.asset(
                    Assets.splash,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
