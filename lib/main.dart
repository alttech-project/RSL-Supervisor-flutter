import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_x_sample/bindings/app_bindings.dart';
import 'package:get_x_sample/routes/app_routes.dart';
import 'package:get_x_sample/views/home_page.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Stock Counting',
        //theme: themeData,
       initialRoute: Home.routeName,
        themeMode: ThemeMode.system,
        initialBinding: AppBind(),
        getPages:routes,
      )
  );
}
