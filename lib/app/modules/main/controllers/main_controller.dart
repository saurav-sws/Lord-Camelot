import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../history/views/history_view.dart';
import '../../my_points/views/my_points_view.dart';
import '../../news/views/news_view.dart';
import '../../redeem_points/views/redeem_points_view.dart';
import '../../../../services/storage_service.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 2.obs;
  final StorageService _storageService = Get.find<StorageService>();

  final List<Widget> pages = [
    NewsView(),
    MyPointsView(),
    RedeemPointsView(),
    HistoryView(),
  ];

  @override
  void onInit() {
    super.onInit();
    // Test if access token is available
    checkToken();
  }

  Future<void> checkToken() async {
    try {
      final token = await _storageService.getAccessToken();
      final user = _storageService.currentUser.value;

      if (token != null && token.isNotEmpty) {
        print(
          'MainController - User authenticated with token: ${token.substring(0, min(10, token.length))}...',
        );
        print('MainController - User ID: ${user?.userId}');
      } else {
        print('MainController - No authentication token found');
      }
    } catch (e) {
      print('MainController - Error checking token: $e');
    }
  }

  int min(int a, int b) => a < b ? a : b;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
