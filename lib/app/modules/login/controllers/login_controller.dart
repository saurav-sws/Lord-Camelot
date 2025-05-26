import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';

class LoginController extends GetxController {
  // Text editing controllers
  final cardNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isCardNumberValid = false.obs;
  final RxBool isPhoneNumberValid = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    phoneNumberController.dispose();
    super.onClose();
  }

  // Validate card number
  void validateCardNumber(String value) {
    isCardNumberValid.value = value.isNotEmpty;
  }

  // Validate phone number
  void validatePhoneNumber(String value) {
    isPhoneNumberValid.value = value.isNotEmpty;
  }

  // Handle login
  void login() {
    if (!isCardNumberValid.value || !isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'Missing Information',
        message: 'Please enter both Card Number and Phone Number',
      );
      return;
    }

    // Show loading dialog
    DialogHelper.showLoading(message: 'Logging in...');

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Hide loading dialog
      DialogHelper.hideLoading();

      // Navigate to main page
      Get.offAllNamed(Routes.MAIN);
    });
  }

  // Handle forgot card number
  void getOtp() {
    if (!isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'Missing Information',
        message: 'Please enter your Phone Number first',
      );
      return;
    }

    // Show loading dialog
    DialogHelper.showLoading(message: 'Sending OTP...');

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Hide loading dialog
      DialogHelper.hideLoading();

      // Navigate to OTP verification screen
      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {'phoneNumber': phoneNumberController.text},
      );
    });
  }

  // Navigate to sign up
  void goToSignUp() {
    Get.toNamed(Routes.SIGNUP);
  }
}
