import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'responsive_size.dart';
import 'typography.dart';

class DialogHelper {

  DialogHelper._();


  static void showSuccessDialog({
    required String title,
    required String message,
    String? buttonText,
    Function()? onConfirm,
  }) {
    _showCustomDialog(
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      backgroundColor: const Color(0xFF003A20),
      iconColor: Colors.green,
      icon: Icons.check_circle,
    );
  }


  static void showErrorDialog({
    required String title,
    required String message,
    String? buttonText,
    Function()? onConfirm,
  }) {
    _showCustomDialog(
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      backgroundColor: const Color(0xFF3A0000),
      iconColor: Colors.red,
      icon: Icons.error,
    );
  }


  static void showWarningDialog({
    required String title,
    required String message,
    String? buttonText,
    Function()? onConfirm,
  }) {
    _showCustomDialog(
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      backgroundColor: const Color(0xFF3A2A00),
      iconColor: Colors.orange,
      icon: Icons.warning,
    );
  }


  static void showInfoDialog({
    required String title,
    required String message,
    String? buttonText,
    Function()? onConfirm,
  }) {
    _showCustomDialog(
      title: title,
      message: message,
      buttonText: buttonText ?? 'OK',
      onConfirm: onConfirm,
      backgroundColor: const Color(0xFF002A3A),
      iconColor: Colors.blue,
      icon: Icons.info,
    );
  }


  static void _showCustomDialog({
    required String title,
    required String message,
    required String buttonText,
    required Function()? onConfirm,
    required Color backgroundColor,
    required Color iconColor,
    required IconData icon,
  }) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveSize.width(20),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0XFF0F0F0F),
            borderRadius: BorderRadius.circular(ResponsiveSize.radius(20)),
            border: Border.all(color: backgroundColor, width: 2),
          ),
          padding: ResponsiveSize.padding(all: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/Splash.png',
                  width: ResponsiveSize.width(60),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(15)),

              // Icon
              Icon(icon, color: iconColor, size: ResponsiveSize.width(40)),
              SizedBox(height: ResponsiveSize.height(15)),

              // Title
              Text(
                title,
                style: AppTextStyles.heading.copyWith(
                  color: Colors.white,
                  fontSize: ResponsiveSize.fontSize(20),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveSize.height(10)),

              // Message
              Text(
                message,
                style: AppTextStyles.subheading.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ResponsiveSize.height(25)),

              // Button
              SizedBox(
                width: double.infinity,
                height: ResponsiveSize.height(45),
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    if (onConfirm != null) {
                      onConfirm();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveSize.radius(10),
                      ),
                    ),
                  ),
                  child: Text(buttonText, style: AppTextStyles.buttonText),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }


  static void showLoading({String message = 'Loading...'}) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: ResponsiveSize.padding(all: 20),
          decoration: BoxDecoration(
            color: const Color(0XFF0F0F0F),
            borderRadius: BorderRadius.circular(ResponsiveSize.radius(15)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/Splash.png',
                  width: ResponsiveSize.width(60),
                ),
              ),
              SizedBox(height: ResponsiveSize.height(20)),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
              SizedBox(height: ResponsiveSize.height(15)),
              Text(
                message,
                style: AppTextStyles.subheading.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoading() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }
}
