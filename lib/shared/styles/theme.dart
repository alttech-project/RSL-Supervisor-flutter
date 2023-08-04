import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

final ThemeData themeData = ThemeData(
    textTheme: GoogleFonts.outfitTextTheme().apply(),
    brightness: Brightness.light,
    primaryColor: AppColor.kPrimaryColor.value,
    buttonTheme: ButtonThemeData(buttonColor: AppColor.kPrimaryColor.value),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColor.kPrimaryColor.value,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.kPrimaryColor.value,
    ));

final ThemeData themeDataDark = ThemeData(
  textTheme: GoogleFonts.outfitTextTheme().apply(),
  brightness: Brightness.dark,
  primaryColor: AppColor.kPrimaryColor.value,
);
