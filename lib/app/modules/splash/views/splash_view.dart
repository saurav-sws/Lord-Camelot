import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/responsive_size.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    Get.put(SplashController());

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF002A20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Image.asset(
                'assets/images/Splash.png',
                width: size.width * 0.35,
              ),
              const SizedBox(height: 20),

              Text(
                '𝕷𝖔𝖗𝖉 𝕮𝖆𝖒𝖊𝖑𝖔𝖙',
                style: TextStyle(
                  fontFamily: 'OldEnglish',
                  fontSize: size.width * 0.08,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
