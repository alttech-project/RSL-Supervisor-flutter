import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/styles/app_color.dart';
import '../shared/styles/app_font.dart';
import 'app_loader.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  final String? secondaryText;
  final TextStyle? style;
  final TextStyle? secondaryTextStyle;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? height;
  final double? width;
  final bool? isLoader;
  final double? borderRadius;
  final LinearGradient? linearColor;

  const CustomButton({
    super.key,
    required this.text,
    this.secondaryText,
    this.onTap,
    this.style,
    this.secondaryTextStyle,
    this.padding,
    this.color,
    this.height,
    this.width,
    this.borderRadius,
    this.isLoader = false,
    this.linearColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 15.r),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 25.r),
        child: Material(
          color: color ?? AppColors.kPrimaryButtonBackGround.value,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: height ?? 50.h,
              width: width ?? double.maxFinite,
              decoration: BoxDecoration(
                  gradient: linearColor ?? primaryButtonLinearColor),
              child: isLoader == true
                  ? AppLoader(
                      color: AppColors.kBackGroundColor.value,
                    )
                  : Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            text,
                            style: style ??
                                TextStyle(
                                  color: AppColors.kSecondaryTextColor.value,
                                  fontSize: AppFontSize.medium.value,
                                  fontWeight: AppFontWeight.semibold.value,
                                ),
                          ),
                          if ((secondaryText ?? "").isNotEmpty) ...[
                            Text(
                              secondaryText!,
                              style: secondaryTextStyle ??
                                  TextStyle(
                                    color: AppColors.kSecondaryTextColor.value,
                                    fontSize: AppFontSize.verySmall.value,
                                    fontWeight: AppFontWeight.light.value,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  final double width;
  final double height;

  final String leftDescription;
  final String rightDescription;

  final Color toggleColor;
  final Color toggleBackgroundColor;
  final Color toggleBorderColor;

  final Color inactiveTextColor;
  final Color activeTextColor;

  final double _leftToggleAlign = 1;
  final double _rightToggleAlign = -1;

  final VoidCallback onLeftToggleActive;
  final VoidCallback onRightToggleActive;

  const ToggleButton({
    Key? key,
    required this.width,
    required this.height,
    required this.toggleBackgroundColor,
    required this.toggleBorderColor,
    required this.toggleColor,
    required this.activeTextColor,
    required this.inactiveTextColor,
    required this.leftDescription,
    required this.rightDescription,
    required this.onLeftToggleActive,
    required this.onRightToggleActive,
  }) : super(key: key);

  @override
  ToggleButtonState createState() => ToggleButtonState();
}

class ToggleButtonState extends State<ToggleButton> {
  double _toggleXAlign = -1;

  late Color _leftDescriptionColor;
  late Color _rightDescriptionColor;

  @override
  void initState() {
    super.initState();

    _leftDescriptionColor = widget.activeTextColor;
    _rightDescriptionColor = widget.inactiveTextColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.toggleBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(widget.height / 2),
        ),
        border: Border.all(color: widget.toggleBorderColor),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(_toggleXAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: widget.width * 0.5,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.toggleColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.height / 2),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  _toggleXAlign = widget._rightToggleAlign;
                  _leftDescriptionColor = widget.activeTextColor;
                  _rightDescriptionColor = widget.inactiveTextColor;
                },
              );

              widget.onLeftToggleActive();
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: widget.width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  widget.leftDescription,
                  style: TextStyle(
                    color: _leftDescriptionColor,
                    fontWeight: AppFontWeight.bold.value,
                    fontSize: AppFontSize.small.value,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(
                () {
                  _toggleXAlign = widget._leftToggleAlign;
                  _leftDescriptionColor = widget.inactiveTextColor;
                  _rightDescriptionColor = widget.activeTextColor;
                },
              );

              widget.onRightToggleActive();
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: widget.width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  widget.rightDescription,
                  style: TextStyle(
                    color: _rightDescriptionColor,
                    fontWeight: AppFontWeight.bold.value,
                    fontSize: AppFontSize.small.value,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.title,
    required this.icon,
    this.height,
    this.cornerRadius,
    this.borderColor,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.onTap,
    this.showLoader,
  });

  final String title;
  final IconData icon;
  final double? height;
  final double? cornerRadius;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;
  final bool? showLoader;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height ?? 25.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.kPrimaryColor.value),
          color: backgroundColor ?? Colors.black,
          borderRadius:
              BorderRadius.circular(cornerRadius ?? ((height ?? 25.h) / 2)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$title ",
                  style: AppFontStyle.smallText(
                      color: (showLoader ?? false)
                          ? Colors.transparent
                          : (titleColor ?? AppColors.kPrimaryColor.value)),
                ),
                Icon(
                  icon,
                  color: (showLoader ?? false)
                      ? Colors.transparent
                      : (iconColor ?? AppColors.kPrimaryColor.value),
                  size: AppFontSize.verySmall.value,
                )
              ],
            ),
            Visibility(
              visible: (showLoader ?? false),
              child: AppLoader(size: (height ?? 25.h) * 0.8),
            ),
          ],
        ),
      ),
    );
  }
}
