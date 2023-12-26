import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';

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

Widget defaultAlertConfirm({String text = 'Ok', VoidCallback? onPressed}) =>
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

Future<void> showDefaultDialog({
  required BuildContext context,
  required String title,
  required String message,
  bool isTwoButton = false,
  String? acceptBtnTitle,
  VoidCallback? acceptAction,
  String? cancelBtnTitle,
  VoidCallback? cancelAction,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: AppFontStyle.body(
            weight: AppFontWeight.semibold.value,
          ),
        ),
        content: Text(
          message,
          style: AppFontStyle.body(),
        ),
        actions: isTwoButton
            ? <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (cancelAction != null) {
                      cancelAction();
                    }
                  },
                  child: Text(
                    cancelBtnTitle ?? 'Cancel',
                    style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (acceptAction != null) {
                      acceptAction();
                    }
                  },
                  child: Text(
                    acceptBtnTitle ?? 'OK',
                    style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                      color: AppColors.kPrimaryColor.value,
                    ),
                  ),
                ),
              ]
            : <Widget>[
                TextButton(
                  child: Text(
                    'OK',
                    style: AppFontStyle.body(
                      weight: AppFontWeight.semibold.value,
                      color: AppColors.kPrimaryColor.value,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
      );
    },
  );
}
