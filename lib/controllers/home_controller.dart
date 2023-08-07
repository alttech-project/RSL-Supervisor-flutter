import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsl_supervisor/data/product_data.dart';

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var viewEnable = false.obs;
  var count = 0.obs;
  final product = Product(name: "Battery", cartCount: 0).obs;

  late AnimationController animationController;

  increment() => count++;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );
  }

  dashboardApiCall() {}

  updateProduct(Product productNew) {
    product.update((val) {
      val!.name = productNew.name;
      val.cartCount = productNew.cartCount;
    });
  }

  incrementCartCount() {
    print("hiTamil incrementCartCount");
    if (product.value.cartCount <= 0) {
      animationController.forward();
    }

    product.update((val) {
      print("hiTamil incrementCartCount2: ${val?.cartCount}");
      val!.cartCount += 1;
    });
  }

  decrementCartCount() {
    print("hiTamil decrementCartCount");
    if (product.value.cartCount > 0) {
      product.update((val) {
        print("hiTamil decrementCartCount2: ${val?.cartCount}");
        val!.cartCount -= 1;
      });
    }

    if (product.value.cartCount <= 0) {
      animationController.reverse();
    }
  }
}
