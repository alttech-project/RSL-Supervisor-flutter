import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';
import 'package:rsl_supervisor/shared/styles/app_font.dart';

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
      height: 40.h,
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

class UnderlinedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String)? onChanged;
  final bool? isEnabled;
  final TextStyle? textStyle;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final Function(String)? onSubmit;
  final String inputLblTxt;
  final TextStyle? inputLblStyle;
  final TextStyle? hintStyle;
  final Color? borderColor;
  final Color? focusColor;

  const UnderlinedTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.inputLblTxt,
    this.onChanged,
    this.isEnabled,
    this.textStyle,
    this.suffix,
    this.keyboardType,
    this.cursorColor,
    this.onSubmit,
    this.inputLblStyle,
    this.hintStyle,
    this.borderColor,
    this.focusColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: textStyle ?? AppFontStyle.body(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: 1,
      cursorColor: cursorColor ?? AppColors.kPrimaryColor.value,
      autofocus: false,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: inputLblTxt,
        labelStyle: inputLblStyle ??
            AppFontStyle.body(
                weight: AppFontWeight.semibold.value, color: Colors.white70),
        hintText: hint,
        hintStyle: AppFontStyle.hint(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: borderColor ?? Colors.white70),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusColor: focusColor ?? Colors.white,
      ),
    );
  }
}
