import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../history/views/history_view.dart';
import '../../my_points/views/my_points_view.dart';
import '../../news/views/news_view.dart';
import '../../redeem_points/views/redeem_points_view.dart';
import '../../../../services/storage_service.dart';
import '../../../routes/app_pages.dart';

class MainController extends GetxController {
  // Default to redeem points view (index 2)
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
    // We don't need to register the controller again as it's already registered by the binding

    // Verify authentication
    verifyAuthentication();
  }

  Future<void> verifyAuthentication() async {
    try {
      // Verify if user is logged in
      if (!_storageService.hasUser) {
        print('MainController - User not authenticated, redirecting to login');
        // Redirect to login screen with small delay
        Future.delayed(Duration(milliseconds: 300), () {
          Get.offAllNamed(Routes.LOGIN);
        });
        return;
      }

      // If user is authenticated, test access token
      final token = await _storageService.getAccessToken();
      final user = _storageService.currentUser.value;

      if (token != null && token.isNotEmpty) {
        print(
          'MainController - User authenticated with token: ${token.substring(0, min(10, token.length))}...',
        );
        print('MainController - User ID: ${user?.userId}');
      } else {
        print('MainController - Token is empty or null, redirecting to login');
        Future.delayed(Duration(milliseconds: 300), () {
          Get.offAllNamed(Routes.LOGIN);
        });
      }
    } catch (e) {
      print('MainController - Error checking authentication: $e');
      // On error, redirect to login
      Future.delayed(Duration(milliseconds: 300), () {
        Get.offAllNamed(Routes.LOGIN);
      });
    }
  }

  int min(int a, int b) => a < b ? a : b;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
