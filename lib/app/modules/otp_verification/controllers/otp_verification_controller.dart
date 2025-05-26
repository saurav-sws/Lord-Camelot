import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';

class OtpVerificationController extends GetxController {
  // The phone number from the previous screen
  final String phoneNumber;

  // Constructor to receive phone number
  OtpVerificationController({required this.phoneNumber});

  // Text editing controller for PIN input
  final TextEditingController pinController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;

  // Focus node for PIN input
  final focusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    pinController.dispose();
    focusNode.dispose();
    super.onClose();
  }

  // Verify OTP
  void verifyOTP() {
    if (pinController.text.length != 4) {
      DialogHelper.showErrorDialog(
        title: 'Invalid OTP',
        message: 'Please enter a valid 4-digit OTP',
      );
      return;
    }

    // Show loading dialog
    DialogHelper.showLoading(message: 'Verifying OTP...');

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Hide loading dialog
      DialogHelper.hideLoading();

      // Show success dialog and navigate to main page
      DialogHelper.showSuccessDialog(
        title: 'Success',
        message: 'OTP verified successfully',
        buttonText: 'Continue',
        onConfirm: () => Get.offAllNamed(Routes.MAIN),
      );
    });
  }

  // Resend OTP
  void resendOTP() {
    isResending.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isResending.value = false;

      DialogHelper.showSuccessDialog(
        title: 'OTP Resent',
        message: 'A new OTP has been sent to your phone number',
      );
    });
  }
}
