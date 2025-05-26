import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the controller
    final mainController = Get.put(MainController());

    return Scaffold(
      body: Obx(() => mainController.pages[mainController.currentIndex.value]),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          border: Border(top: BorderSide(color: Color(0xFF151515), width: 1.0)),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,
          currentIndex: mainController.currentIndex.value,
          onTap: mainController.changePage,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white,
          selectedLabelStyle: TextStyle(
            fontSize: ResponsiveSize.fontSize(12),
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: ResponsiveSize.fontSize(12),
            fontWeight: FontWeight.w600,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: ResponsiveSize.padding(top: 10, bottom: 5),
                child: Image.asset(
                  'assets/images/Splash.png',
                  width: ResponsiveSize.width(24),
                  height: ResponsiveSize.height(24),
                  color:
                      mainController.currentIndex.value == 0
                          ? Colors.green
                          : Colors.white,
                ),
              ),
              label: 'News',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: ResponsiveSize.padding(top: 10, bottom: 5),
                child: Image.asset(
                  'assets/images/Splash.png',
                  width: ResponsiveSize.width(24),
                  height: ResponsiveSize.height(24),
                  color:
                      mainController.currentIndex.value == 1
                          ? Colors.green
                          : Colors.white,
                ),
              ),
              label: 'My Points',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: ResponsiveSize.padding(top: 10, bottom: 5),
                child: Image.asset(
                  'assets/images/Splash.png',
                  width: ResponsiveSize.width(24),
                  height: ResponsiveSize.height(24),
                  color:
                      mainController.currentIndex.value == 2
                          ? Colors.green
                          : Colors.white,
                ),
              ),
              label: 'Redeem Points',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: ResponsiveSize.padding(top: 10, bottom: 5),
                child: Image.asset(
                  'assets/images/Splash.png',
                  width: ResponsiveSize.width(24),
                  height: ResponsiveSize.height(24),
                  color:
                      mainController.currentIndex.value == 3
                          ? Colors.green
                          : Colors.white,
                ),
              ),
              label: 'History',
            ),
          ],
        ),
      ),
    );
  }
}
