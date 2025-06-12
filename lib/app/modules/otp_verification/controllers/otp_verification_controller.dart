import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';
import '../../../../services/api_service.dart';
import '../../../../services/storage_service.dart';

class OtpVerificationController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();

  final String phoneNumber;
  final String fullName;
  final String cardNumber;
  final String fcmToken;
  final String? otpValue; // OTP value for auto-fill (testing only)

  OtpVerificationController({
    required this.phoneNumber,
    required this.fullName,
    required this.cardNumber,
    required this.fcmToken,
    this.otpValue,
  });

  final TextEditingController pinController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxString pin = ''.obs;
  final RxString formattedPhoneNumber = ''.obs;
  final RxBool canResend = false.obs;
  final RxInt resendTimer = 60.obs;

  final focusNode = FocusNode();
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();

    formattedPhoneNumber.value = formatPhoneNumber(phoneNumber);

    startResendTimer();

    // Auto-fill OTP if available (for testing purposes)
    if (otpValue != null && otpValue!.isNotEmpty) {
      pin.value = otpValue!;
      pinController.text = otpValue!;
    }
  }

  @override
  void onClose() {
    pinController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }

  String formatPhoneNumber(String number) {
    String cleanNumber = number.replaceAll(RegExp(r'[^\d]'), '');
    return cleanNumber;
  }

  void updatePin(String value) {
    pin.value = value;
  }

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

  Future<void> verifyOTP() async {
    if (pin.value.length != 4) {
      DialogHelper.showErrorDialog(
        title: 'invalid_otp'.tr,
        message: 'enter_valid_otp'.tr,
      );
      return;
    }

    DialogHelper.showLoading(message: 'verifying_otp'.tr);

    try {
      print('Verifying OTP: ${pin.value}');
      final response = await _apiService.verifyOtpAndRegister(
        mobile: phoneNumber,
        name: fullName,
        cardNumber: cardNumber,
        fcmToken: fcmToken,
        otp: pin.value,
      );

      print('Verification response: $response');
      DialogHelper.hideLoading();

      try {
        // Create a user from the response
        final user = User.fromJson(response);
        print('User created: ${user.userId} with token: ${user.accessToken}');

        // Save user data (this might fail but we'll continue anyway)
        try {
          await _storageService.saveUser(user);
          print('User data saved successfully');
        } catch (saveError) {
          // If saving fails, we'll still proceed with the registration
          print(
            'Error saving user but proceeding with registration: $saveError',
          );

          // Ensure the user is at least available in memory
          _storageService.currentUser.value = user;
          _storageService.isLoggedIn.value = true;
        }

        // Navigate directly to the main screen without showing success dialog
        print('Navigating directly to MAIN route');
        Get.offAllNamed(Routes.MAIN);
      } catch (userError) {
        print('Error creating user object: $userError');
        print(
          'Registration was successful, but user parsing failed. Navigating anyway.',
        );

        // Even if user object creation fails, navigate directly to main screen
        print('Forced direct navigation to MAIN route');
        Get.offAllNamed(Routes.MAIN);
      }
    } catch (e) {
      print('Error during OTP verification: $e');
      DialogHelper.hideLoading();

      String errorMessage = e.toString();
      // Simplify error message if it's too technical
      if (errorMessage.contains('Exception: Error:')) {
        errorMessage = errorMessage.replaceAll('Exception: Error: ', '');
      }

      DialogHelper.showErrorDialog(
        title: 'error'.tr,
        message: errorMessage,
        buttonText: 'OK',
        onConfirm: () {
          // Ensure that the error dialog is properly dismissed
          if (Get.isDialogOpen ?? false) {
            Get.back();
          }
        },
      );
    }
  }

  Future<void> resendOTP() async {
    if (!canResend.value) return;

    isResending.value = true;

    DialogHelper.showLoading(message: 'sending_otp'.tr);

    try {
      // Call the API to resend OTP
      final response = await _apiService.resendOTP(mobile: phoneNumber);

      DialogHelper.hideLoading();
      isResending.value = false;
      startResendTimer();

      // Auto-fill OTP if available (for testing purposes)
      if (response.containsKey('otp')) {
        String newOtp = response['otp'].toString();
        pin.value = newOtp;
        pinController.text = newOtp;
        print('New OTP received: $newOtp');
      }

      DialogHelper.showSuccessDialog(
        title: 'otp_resent'.tr,
        message: 'new_otp_sent'.tr,
      );
    } catch (e) {
      DialogHelper.hideLoading();
      isResending.value = false;

      String errorMessage = e.toString();
      // Simplify error message if it's too technical
      if (errorMessage.contains('Exception: Error:')) {
        errorMessage = errorMessage.replaceAll('Exception: Error: ', '');
      }

      DialogHelper.showErrorDialog(title: 'error'.tr, message: errorMessage);
    }
  }
}
