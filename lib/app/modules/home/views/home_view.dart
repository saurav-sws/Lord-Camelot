import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final homeController = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lord Camelot',
          style: TextStyle(
            fontSize: ResponsiveSize.fontSize(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Lord Camelot!',
              style: TextStyle(
                fontSize: ResponsiveSize.fontSize(24),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveSize.height(20)),
            Obx(
              () => Text(
                'You have pushed the button ${homeController.count} times',
                style: TextStyle(fontSize: ResponsiveSize.fontSize(16)),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: homeController.increment,
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }
}
