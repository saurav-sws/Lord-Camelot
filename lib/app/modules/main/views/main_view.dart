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
          () => BottomNavigationBar(
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            currentIndex: mainController.currentIndex.value,
            onTap: mainController.changePage,
            selectedItemColor:  Color(0xFF288c25),
            unselectedItemColor: Colors.white70,
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
                  child: Icon(
                    Icons.newspaper,
                    color:
                        mainController.currentIndex.value == 0
                            ?   Color(0xFF288c25)
                            : Colors.white70,
                    size: ResponsiveSize.width(24),
                  ),
                ),
                label: 'News',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: ResponsiveSize.padding(top: 10, bottom: 5),
                  child: Icon(
                    Icons.card_giftcard,
                    color:
                        mainController.currentIndex.value == 1
                            ? Color(0xFF288c25)
                            : Colors.white70,
                    size: ResponsiveSize.width(24),
                  ),
                ),
                label: 'My Points',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: ResponsiveSize.padding(top: 10, bottom: 5),
                  child: Icon(
                    Icons.redeem,
                    color:
                        mainController.currentIndex.value == 2
                            ? Color(0xFF288c25)
                            : Colors.white70,
                    size: ResponsiveSize.width(24),
                  ),
                ),
                label: 'Redeem Points',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: ResponsiveSize.padding(top: 10, bottom: 5),
                  child: Icon(
                    Icons.history,
                    color:
                        mainController.currentIndex.value == 3
                            ? Color(0xFF288c25)
                            : Colors.white70,
                    size: ResponsiveSize.width(24),
                  ),
                ),
                label: 'History',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
