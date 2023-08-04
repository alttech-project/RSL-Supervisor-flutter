import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../shared/styles/colors.dart';

class SafeAreaContainer extends StatefulWidget {
  final Widget child;
  final bool isTabBarShown;
  final Color? statusBarColor;
  final bool themedark;
  final Color? systemNavigationBarColor;

  final bool?  NavigationBarthemedark;

  const SafeAreaContainer({
    Key? key,
    required this.child,
    this.isTabBarShown = false,
    this.statusBarColor,
    this.themedark = true,
    this.systemNavigationBarColor,this.NavigationBarthemedark=false,
  }) : super(key: key);

  @override
  SafeAreaContainerState createState() => SafeAreaContainerState();
}

class SafeAreaContainerState extends State<SafeAreaContainer> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor:
              widget.statusBarColor ?? AppColor.kStatusBarPrimaryColor.value,
          statusBarBrightness:
              widget.themedark ? Brightness.dark : Brightness.light,
          statusBarIconBrightness:
              widget.themedark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: widget.NavigationBarthemedark ==true
              ? widget.systemNavigationBarColor ??
              Colors
                  .black:widget.systemNavigationBarColor ??
                  AppColor.kBackGroundColor.value,
               // Set the background color of the navigation bar
          systemNavigationBarIconBrightness:
              widget.NavigationBarthemedark ==true? Brightness.light : Brightness.dark,
        ),
        child: widget.child);
  }
}

// bool isIphoneXorNot(BuildContext context) {
//   return Platform.isIOS
//       ? MediaQuery.of(context).size.height >= 812
//           ? true
//           : false
//       : false;
// }
