import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../shared/styles/app_color.dart';

showAppDialog({
  required String message,
  String title = 'Confirm',
  TextStyle titleStyle = const TextStyle(color: Colors.black),
  TextStyle middleTextStyle = const TextStyle(color: Colors.black54),
  radius = 16,
  Widget? confirm,
  Widget? cancel,
  Widget? content,
}) {
  return Get.defaultDialog(
    title: title,
    middleText: message,
    backgroundColor: Colors.white,
    titleStyle: const TextStyle(color: Colors.black),
    middleTextStyle: const TextStyle(color: Colors.black54),
    cancel: cancel,
    confirm: confirm,
    content: content,
    radius: 16,
  );
}

Widget defaultAlertConfirm({String text = 'Okay', VoidCallback? onPressed}) =>
    TextButton(
      onPressed: onPressed ??
          () {
            Get.back();
          },
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.kPrimaryColor.value,
        ),
      ),
    );

Widget defaultAlertCancel({String text = 'Cancel', VoidCallback? onPressed}) =>
    TextButton(
      onPressed: onPressed ??
          () {
            Get.back();
          },
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.kLightTextPrimary.value,
        ),
      ),
    );
