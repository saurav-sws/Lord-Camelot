import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';
import '../../../../services/api_service.dart';
import '../../../../services/storage_service.dart';

class OtpVerificationController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final String phoneNumber;
  final String fullName;
  final String cardNumber;
  final String fcmToken;
  final String? dob; // Optional DOB field
  final String? otpValue; // OTP value for auto-fill (testing only)

  OtpVerificationController({
    required this.phoneNumber,
    required this.fullName,
    required this.cardNumber,
    required this.fcmToken,
    this.dob,
    this.otpValue,
  });

  final TextEditingController otpController = TextEditingController();

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

    formatPhoneNumber();

    startResendTimer();

    // Auto-fill OTP if available (for testing purposes)
    if (otpValue != null && otpValue!.isNotEmpty) {
      otpController.text = otpValue!;
      pin.value = otpValue!;
    }
  }

  @override
  void onClose() {
    otpController.dispose();
    focusNode.dispose();
    _timer?.cancel();
    super.onClose();
  }

  void formatPhoneNumber() {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    formattedPhoneNumber.value = cleaned;
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

  void verifyOTP() async {
    if (pin.value.length != 4) {
      DialogHelper.showErrorDialog(
        title: 'error'.tr,
        message: 'invalid_otp'.tr,
      );
      return;
    }

    DialogHelper.showLoading(message: 'verifying_otp'.tr);

    try {
      final response = await _apiService.verifyOtpAndRegister(
        mobile: phoneNumber,
        name: fullName,
        cardNumber: cardNumber,
        fcmToken: fcmToken,
        otp: pin.value,
        dob: dob ?? '',
      );

      print('OTP verification response: $response');

      // Check if response contains the expected data
      if (!response.containsKey('user') || !response.containsKey('token')) {
        print('ERROR: Response does not contain user or token data');
        print('Response keys: ${response.keys.toList()}');
        throw Exception('Invalid response from server. Registration failed.');
      }

      // Extract user data and token
      final userData = response['user'];
      final token = response['token'];

      print('User data: $userData');
      print(
        'Token: ${token.toString().substring(0, min(10, token.toString().length))}...',
      );

      // Create a complete user object with token
      Map<String, dynamic> completeUserData = {
        'user': userData,
        'access_token': token,
        'token_type': 'Bearer',
      };

      // Create user object
      final user = User.fromJson(completeUserData);

      print(
        'Created user object: ${user.userId}, token: ${user.accessToken.substring(0, min(10, user.accessToken.length))}...',
      );

      // Save user data
      await _storageService.saveUser(user);

      // Verify login status
      final loggedIn = _storageService.hasUser;
      print('After registration - Is user logged in: $loggedIn');
      print(
        'Current user in storage: ${_storageService.currentUser.value?.userId}',
      );

      DialogHelper.hideLoading();

      // Navigate directly to main screen with redeem points view
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      print('OTP verification error: $e');
      DialogHelper.hideLoading();
      DialogHelper.showErrorDialog(title: 'error'.tr, message: e.toString());
    }
  }

  int min(int a, int b) => a < b ? a : b;

  void resendOTP() async {
    DialogHelper.showLoading(message: 'sending_otp'.tr);

    try {
      await _apiService.sendOTP(
        mobile: phoneNumber,
        name: fullName,
        cardNumber: cardNumber,
        fcmToken: fcmToken,
      );

      DialogHelper.hideLoading();
      startResendTimer();
      DialogHelper.showSuccessDialog(
        title: 'success'.tr,
        message: 'otp_sent'.tr,
      );
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showErrorDialog(title: 'error'.tr, message: e.toString());
    }
  }
}
