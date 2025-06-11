import 'dart:async';
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
  late final TextEditingController pinController = TextEditingController();

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxString pin = ''.obs;
  final RxString formattedPhoneNumber = ''.obs;
  final RxBool canResend = false.obs;
  final RxInt resendTimer = 60.obs;
  final RxBool isDisposed = false.obs;

  // Focus node for PIN input
  late final focusNode = FocusNode();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    // Format the phone number for display (e.g. +81 90-XXXX-5678)
    formattedPhoneNumber.value = formatPhoneNumber(phoneNumber);
    // Start the resend timer
    startResendTimer();
  }

  @override
  void onClose() {
    isDisposed.value = true;
    pinController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }

  // Format phone number for display
  String formatPhoneNumber(String number) {
    // Check if number is already formatted
    if (number.contains('-') || number.contains(' ')) {
      return number;
    }

    // Basic formatting - can be customized based on your needs
    if (number.length >= 10) {
      String prefix = number.substring(0, 3);
      String middle = number.substring(3, 7);
      String last = number.substring(7);
      return '+81 $prefix-$middle-$last';
    }
    return number;
  }

  // Update PIN when user enters code
  void updatePin(String value) {
    pin.value = value;
  }

  // Start the resend timer
  void startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // Verify OTP
  void verifyOTP() {
    if (pin.value.length != 6) {
      DialogHelper.showErrorDialog(
        title: 'invalid_otp'.tr,
        message: 'enter_valid_otp'.tr,
      );
      return;
    }

    // Show loading dialog
    DialogHelper.showLoading(message: 'verifying_otp'.tr);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Hide loading dialog
      DialogHelper.hideLoading();

      // Show success dialog and navigate to main page
      DialogHelper.showSuccessDialog(
        title: 'success'.tr,
        message: 'otp_verified'.tr,
        buttonText: 'continue'.tr,
        onConfirm: () => Get.offAllNamed(Routes.MAIN),
      );
    });
  }

  // Resend OTP
  void resendOTP() {
    if (!canResend.value) return;

    isResending.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isResending.value = false;
      startResendTimer(); // Restart the timer

      DialogHelper.showSuccessDialog(
        title: 'otp_resent'.tr,
        message: 'new_otp_sent'.tr,
      );
    });
  }
}
