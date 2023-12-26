import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';

final ThemeData themeData = ThemeData(
  textTheme: GoogleFonts.outfitTextTheme().apply(),
  brightness: Brightness.light,
  primaryColor: AppColors.kPrimaryColor.value,
  buttonTheme: ButtonThemeData(buttonColor: AppColors.kPrimaryColor.value),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.kPrimaryColor.value,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.kBlack.value,
  ),
  useMaterial3: false,
  /*colorScheme: ColorScheme(
    background: AppColors.kBlack.value,
    onBackground: AppColors.kBlack.value,
    brightness: Brightness.light,
    surface: AppColors.kPrimaryColor.value,
    onSurface: AppColors.kBlack.value,
    primary: AppColors.kWhite.value,
    onPrimary: AppColors.kWhite.value,
    secondary: AppColors.kPrimaryColor.value,
    onSecondary: AppColors.kPrimaryColor.value,
    tertiary: AppColors.kPrimaryColor.value,
    onTertiary: AppColors.kPrimaryColor.value,
    error: AppColors.kRedColor.value,
    onError: AppColors.kRedColor.value,
  ),*/
);

final ThemeData themeDataDark = ThemeData(
  textTheme: GoogleFonts.outfitTextTheme().apply(),
  brightness: Brightness.dark,
  primaryColor: AppColors.kPrimaryColor.value,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.kBlack.value,
  ),
);
