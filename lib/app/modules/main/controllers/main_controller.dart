import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../history/views/history_view.dart';
import '../../my_points/views/my_points_view.dart';
import '../../news/views/news_view.dart';
import '../../redeem_points/views/redeem_points_view.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 2.obs;

  final List<Widget> pages = [
    NewsView(),
    MyPointsView(),
    RedeemPointsView(),
    HistoryView(),
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
