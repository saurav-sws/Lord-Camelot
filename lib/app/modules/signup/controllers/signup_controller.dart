import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';

class SignupController extends GetxController {
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
  void getOTP() {
    if (!isFullNameValid.value ||
        !isCardNumberValid.value ||
        !isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'missing_information'.tr,
        message: 'fill_all_fields'.tr,
      );
      return;
    }

    // Show loading dialog
    DialogHelper.showLoading(message: 'processing_request'.tr);

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      // Hide loading dialog
      DialogHelper.hideLoading();

      final phoneNumber = phoneNumberController.value?.text ?? '';

      // Navigate to OTP verification screen
      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {'phoneNumber': phoneNumber},
      );
    });
  }

  // Navigate to login
  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
