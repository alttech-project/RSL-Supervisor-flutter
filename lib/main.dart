import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_x_sample/bindings/app_bindings.dart';
import 'package:get_x_sample/routes/app_routes.dart';
import 'package:get_x_sample/views/home_page.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialRoute: Home.routeName,
      getPages: routes,
      initialBinding: AppBind(),
    ),
  );
}
