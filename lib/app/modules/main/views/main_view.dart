import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainController = Get.put(MainController());

    return Scaffold(
      body: Obx(() => mainController.pages[mainController.currentIndex.value]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Color(0xFF151515), width: 1.0)),
        ),
        child: Obx(
          () => CustomBottomNavigationBar(
            currentIndex: mainController.currentIndex.value,
            onTap: mainController.changePage,
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: double.infinity,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.newspaper, 'news'.tr),
          _buildNavItem(1, Icons.card_giftcard, 'my_points'.tr),
          _buildNavItem(2, Icons.redeem, 'redeem_points'.tr),
          _buildNavItem(3, Icons.history, 'history'.tr),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    final Color iconColor = isSelected ? Color(0xFF288c25) : Colors.white70;
    final Color textColor = isSelected ? Color(0xFF288c25) : Colors.white70;

    return InkWell(
      onTap: () => onTap(index),
      splashColor: Color(0xFF288c25).withOpacity(0.2),
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(ResponsiveSize.radius(8)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(12),
          vertical: ResponsiveSize.height(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: ResponsiveSize.width(22)),
            SizedBox(height: ResponsiveSize.height(3)),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: ResponsiveSize.fontSize(11),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
