import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsl_supervisor/supporting_classes/app_font.dart';

class CapsuleTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String)? onChanged;
  final bool? isEnabled;
  final TextStyle? textStyle;
  final Widget? suffix;

  const CapsuleTextField(
      {super.key,
      required this.controller,
      required this.hint,
      this.onChanged,
      this.isEnabled,
      this.textStyle,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(45.h / 2),
      ),
      padding: EdgeInsets.only(left: 15.w, right: 8.w),
      child: Center(
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            suffixIcon: suffix,
          ),
          style: textStyle ?? AppFontStyle.body(),
          enabled: isEnabled ?? true,
        ),
      ),
    );
  }
}
