import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsl_supervisor/supporting_classes/app_color.dart';

final ThemeData themeData = ThemeData(
    textTheme: GoogleFonts.outfitTextTheme().apply(),
    brightness: Brightness.light,
    primaryColor: AppColors.kPrimaryColor.value,
    buttonTheme: ButtonThemeData(buttonColor: AppColors.kPrimaryColor.value),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.kPrimaryColor.value,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.kPrimaryColor.value,
    ));

final ThemeData themeDataDark = ThemeData(
  textTheme: GoogleFonts.outfitTextTheme().apply(),
  brightness: Brightness.dark,
  primaryColor: AppColors.kPrimaryColor.value,
);
