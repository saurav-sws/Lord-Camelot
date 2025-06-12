import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';
import '../../../../services/api_service.dart';
import '../../../../services/fcm_service.dart';

class SignupController extends GetxController {
  final ApiService _apiService = ApiService();

  // We'll create these controllers when they're needed
  Rx<TextEditingController?> fullNameController = Rx<TextEditingController?>(
    null,
  );
  Rx<TextEditingController?> cardNumberController = Rx<TextEditingController?>(
    null,
  );
  Rx<TextEditingController?> phoneNumberController = Rx<TextEditingController?>(
    null,
  );

  // Observable variables
  final RxBool isLoading = false.obs;
  final RxBool isFullNameValid = false.obs;
  final RxBool isCardNumberValid = false.obs;
  final RxBool isPhoneNumberValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    fullNameController.value = TextEditingController();
    cardNumberController.value = TextEditingController();
    phoneNumberController.value = TextEditingController();
  }

  @override
  void onClose() {
    // Safely dispose controllers
    fullNameController.value?.dispose();
    fullNameController.value = null;

    cardNumberController.value?.dispose();
    cardNumberController.value = null;

    phoneNumberController.value?.dispose();
    phoneNumberController.value = null;

    super.onClose();
  }

  // Validate full name
  void validateFullName(String value) {
    isFullNameValid.value = value.isNotEmpty;
  }

  // Validate card number
  void validateCardNumber(String value) {
    isCardNumberValid.value = value.isNotEmpty;
  }

  // Validate phone number
  void validatePhoneNumber(String value) {
    isPhoneNumberValid.value = value.isNotEmpty;
  }

  // Handle get OTP
  Future<void> getOTP() async {
    if (!isFullNameValid.value ||
        !isCardNumberValid.value ||
        !isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'missing_information'.tr,
        message: 'fill_all_fields'.tr,
      );
      return;
    }

    final phoneNumber = phoneNumberController.value?.text ?? '';
    final fullName = fullNameController.value?.text ?? '';
    final cardNumber = cardNumberController.value?.text ?? '';
    final fcmToken = FCMService.to.fcmToken.value;

    // Show loading dialog
    DialogHelper.showLoading(message: 'sending_otp'.tr);

    try {
      // Call the API to send OTP
      final response = await _apiService.sendOTP(
        mobile: phoneNumber,
        name: fullName,
        cardNumber: cardNumber,
        fcmToken: fcmToken,
      );

      // Hide loading dialog
      DialogHelper.hideLoading();

      // Check if the API returned the OTP value (for testing purposes)
      String? otpValue;
      if (response.containsKey('otp')) {
        otpValue = response['otp'].toString();
        print('OTP received: $otpValue');
      }

      // Navigate to OTP verification screen
      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {
          'phoneNumber': phoneNumber,
          'fullName': fullName,
          'cardNumber': cardNumber,
          'fcmToken': fcmToken,
          'otpValue': otpValue, // Pass the OTP value if available (for testing)
        },
      );
    } catch (e) {
      DialogHelper.hideLoading();
      DialogHelper.showErrorDialog(title: 'error'.tr, message: e.toString());
    }
  }

  // Navigate to login
  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
