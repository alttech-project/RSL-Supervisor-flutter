import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/assets/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Center(
        child: Image(
          image: const AssetImage(Assets.appIcon),
          width: 200.w,
          height: 200.h,
        ),
      ),
    );
  }
}
