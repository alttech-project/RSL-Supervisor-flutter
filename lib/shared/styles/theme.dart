import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';

final ThemeData themeData = ThemeData(
  textTheme: GoogleFonts.outfitTextTheme().apply(),
  brightness: Brightness.light,
  primaryColor: AppColors.kPrimaryColor.value,
  backgroundColor: AppColors.kBlack.value,
  buttonTheme: ButtonThemeData(buttonColor: AppColors.kPrimaryColor.value),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.kPrimaryColor.value,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.kBlack.value,
  ),
);

final ThemeData themeDataDark = ThemeData(
  textTheme: GoogleFonts.outfitTextTheme().apply(),
  brightness: Brightness.dark,
  primaryColor: AppColors.kPrimaryColor.value,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.kBlack.value,
  ),
);