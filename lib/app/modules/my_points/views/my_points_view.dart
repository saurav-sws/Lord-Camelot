import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/responsive_size.dart';

class MyPointsView extends StatelessWidget {
  const MyPointsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/Splash.png',
                width: ResponsiveSize.width(100),
                color: Colors.white,
              ),
              SizedBox(height: ResponsiveSize.height(20)),
              Text(
                'My Points',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveSize.fontSize(24),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ResponsiveSize.height(10)),
              Text(
                'Coming Soon',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: ResponsiveSize.fontSize(16),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
