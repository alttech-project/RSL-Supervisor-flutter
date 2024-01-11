import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';

class LocationPermissionPage extends StatelessWidget {
  const LocationPermissionPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.info,
                size: 100,
                color: AppColors.kPrimaryColor.value,
              ),
              SizedBox(height: 16.h),
              Text(
                'To continue using our app, granting location permission is necessary; without it, access will be restricted. If you wish to proceed, simply reopen your app and navigate to your device settings and grant location permission to unlock all functionalities.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: AppColors.kPrimaryColor.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}