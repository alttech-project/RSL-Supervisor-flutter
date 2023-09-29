import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemController extends GetxController {
  // final items = <String>[];
  RxList<String> items = <String>[].obs;
  final searchController = TextEditingController();
  final scrollController = ScrollController();
  String searchQuery = '';

  @override
  void onInit() {
    super.onInit();
    items.assignAll(List.generate(50, (index) => 'MItem $index'));
  }

  void scrollToItem(String query) {
    if (query.isEmpty) return;

    final matchingItemIndex = items.indexWhere((item) => item.contains(query));
    if (matchingItemIndex != -1) {
      scrollController.animateTo(
        matchingItemIndex * 56.0, // Assuming ListTile height is 56
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery = '';
  }
}