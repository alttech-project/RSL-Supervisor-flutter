import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
  final TextInputAction textInputAction;
  final FormFieldValidator? validator;
  final bool readOnly;
  final GestureTapCallback? onTap;
  final int? maxLines;
  final Color? hintColor;
  final FocusNode? focusNode; // Added FocusNode property

  const UnderlinedTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.inputLblTxt,
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
    this.validator,
    this.textInputAction = TextInputAction.done,
    this.readOnly = false,
    this.onTap,
    this.maxLines,
    this.hintColor,
    this.onChanged,
    this.focusNode, // Include FocusNode in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: textStyle ?? AppFontStyle.body(color: Colors.white),
      onTap: onTap,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      cursorColor: cursorColor ?? AppColors.kPrimaryColor.value,
      autofocus: false,
      onFieldSubmitted: onSubmit,
      decoration: InputDecoration(
        labelText: inputLblTxt,
        labelStyle: inputLblStyle ??
            AppFontStyle.body(
                weight: AppFontWeight.semibold.value, color: Colors.white70),
        hintText: hint,
        hintStyle: AppFontStyle.hint(color: hintColor ?? Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
              color: borderColor ?? AppColors.kLightTextSecondary.value,
              width: 0.5),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: focusColor ?? Colors.white),
        ),
        focusColor: focusColor ?? Colors.white,
        suffixIcon: suffix,
      ),
      textInputAction: textInputAction,
      validator: validator,
      readOnly: readOnly,
      onChanged: onChanged,
    );
  }
}

class CountryCodeTextField extends StatelessWidget {
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
  final TextInputAction textInputAction;
  final ValueChanged<Country>? onCountryChanged;
  final InputDecoration? decoration;
  final String initialCountryCode;

  const CountryCodeTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.inputLblTxt,
    this.initialCountryCode = 'AE',
    this.onChanged,
    this.isEnabled,
    this.decoration,
    this.textStyle,
    this.suffix,
    this.keyboardType,
    this.cursorColor,
    this.onSubmit,
    this.inputLblStyle,
    this.hintStyle,
    this.borderColor,
    this.focusColor,
    this.onCountryChanged,
    this.textInputAction = TextInputAction.done,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      controller: controller,
      style: textStyle ?? AppFontStyle.body(color: Colors.white),
      cursorColor: cursorColor ?? AppColors.kPrimaryColor.value,
      autofocus: false,
      onSubmitted: onSubmit,
      initialCountryCode: initialCountryCode,
      dropdownIconPosition: IconPosition.trailing,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.start,
      showCountryFlag: true,
      languageCode: 'en',
      dropdownTextStyle: const TextStyle(color: Colors.white),
      dropdownIcon: Icon(
        Icons.arrow_drop_down,
        color: Colors.white,
        size: 14.r,
      ),
      decoration: decoration ??
          InputDecoration(
            labelText: inputLblTxt,
            labelStyle: inputLblStyle ??
                AppFontStyle.body(
                    weight: AppFontWeight.semibold.value,
                    color: Colors.white70),
            hintText: hint,
            hintStyle: AppFontStyle.hint(color: Colors.white70),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? AppColors.kLightTextSecondary.value,
                  width: 0.5),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusColor: focusColor ?? Colors.white,
          ),
      textInputAction: textInputAction,
      onCountryChanged: onCountryChanged,
    );
  }
}

class BoxTextField extends StatelessWidget {
  const BoxTextField({
    this.hintText,
    this.keyboardType,
    this.textController,
    this.decoration,
    this.enable = false,
    this.autocorrect,
    super.key,
    this.suffix,
    this.style,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
  });

  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? textController;
  final InputDecoration? decoration;
  final bool? enable;
  final bool? autocorrect;
  final TextStyle? style;
  final FocusNode? focusNode;
  final bool? autofocus;
  final Widget? suffix;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      enabled: enable,
      autofocus: autofocus ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: AppColors.kPrimaryColor.value,
      controller: textController,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: style ?? AppFontStyle.body(),
      autocorrect: autocorrect ?? false,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText ?? "search...",
            hintStyle: AppFontStyle.hint(
              color: Colors.grey.shade500,
              size: AppFontSize.small.value,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.kPrimaryColor.value),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.kPrimaryColor.value),
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            suffixIcon: suffix,
            //isDense: true,
            contentPadding: contentPadding ?? EdgeInsets.all(10.r),
          ),
    );
  }
}

class BoxTextFieldTransparent extends StatelessWidget {
  const BoxTextFieldTransparent({
    this.hintText,
    this.keyboardType,
    this.textController,
    this.decoration,
    this.enable = false,
    this.autocorrect,
    super.key,
    this.suffix,
    this.style,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
    this.textInputAction = TextInputAction.done,
  });

  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? textController;
  final InputDecoration? decoration;
  final bool? enable;
  final bool? autocorrect;
  final TextStyle? style;
  final FocusNode? focusNode;
  final bool? autofocus;
  final Widget? suffix;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      enabled: enable,
      autofocus: autofocus ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: AppColors.kPrimaryColor.value,
      controller: textController,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: style ?? AppFontStyle.body(color: Colors.white),
      autocorrect: autocorrect ?? false,
      textAlignVertical: TextAlignVertical.top,
      textInputAction: textInputAction,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText ?? "search...",
            hintStyle: AppFontStyle.body(color: Colors.white70),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: suffix,
            //isDense: true,
            contentPadding: contentPadding ?? EdgeInsets.all(10.r),
          ),
    );
  }
}

class RemarksTextFieldTransparent extends StatelessWidget {
  const RemarksTextFieldTransparent({
    this.hintText,
    this.keyboardType,
    this.textController,
    this.decoration,
    this.enable = false,
    this.autocorrect,
    super.key,
    this.suffix,
    this.style,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.contentPadding,
    this.textInputAction = TextInputAction.done,
  });

  final String? hintText;
  final TextInputType? keyboardType;
  final TextEditingController? textController;
  final InputDecoration? decoration;
  final bool? enable;
  final bool? autocorrect;
  final TextStyle? style;
  final FocusNode? focusNode;
  final bool? autofocus;
  final Widget? suffix;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction textInputAction;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      enabled: enable,
      autofocus: autofocus ?? false,
      keyboardType: keyboardType ?? TextInputType.text,
      cursorColor: AppColors.kPrimaryColor.value,
      controller: textController,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      style: style ?? AppFontStyle.body(color: Colors.white),
      autocorrect: autocorrect ?? false,
      textAlignVertical: TextAlignVertical.top,
      textInputAction: textInputAction,
      maxLines: null,
      expands: true,
      decoration: decoration ??
          InputDecoration(
            hintText: hintText ?? "search...",
            hintStyle: AppFontStyle.body(color: Colors.white70),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: suffix,
            //isDense: true,
            contentPadding: contentPadding ?? EdgeInsets.all(10.r),
          ),
    );
  }
}
