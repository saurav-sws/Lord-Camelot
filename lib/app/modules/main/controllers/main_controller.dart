import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../history/views/history_view.dart';
import '../../my_points/views/my_points_view.dart';
import '../../news/views/news_view.dart';
import '../../redeem_points/views/redeem_points_view.dart';

class MainController extends GetxController {
  // Track the current tab index (starting with Redeem Points as default: index 2)
  final RxInt currentIndex = 2.obs;

  // List of pages for the bottom navigation
  final List<Widget> pages = [
    const NewsView(),
    const MyPointsView(),
    const RedeemPointsView(),
    const HistoryView(),
  ];

  // Change the current tab
  void changePage(int index) {
    currentIndex.value = index;
  }
}
