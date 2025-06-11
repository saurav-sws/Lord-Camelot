import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';

class LoginController extends GetxController {
  // Use late initialization to ensure controllers are created only once
  late final cardNumberController = TextEditingController();
  late final phoneNumberController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isCardNumberValid = false.obs;
  final RxBool isPhoneNumberValid = false.obs;

  // Track if controller is disposed
  final RxBool isDisposed = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDisposed.value = false;
  }

  @override
  void onClose() {
    // Mark as disposed before actually disposing
    isDisposed.value = true;

    // Safely dispose controllers
    cardNumberController.dispose();
    phoneNumberController.dispose();

    super.onClose();
  }

  void validateCardNumber(String value) {
    isCardNumberValid.value = value.isNotEmpty;
  }

  void validatePhoneNumber(String value) {
    isPhoneNumberValid.value = value.isNotEmpty;
  }

  void login() {
    if (!isCardNumberValid.value || !isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'missing_information'.tr,
        message: 'enter_both'.tr,
      );
      return;
    }

    DialogHelper.showLoading(message: 'logging_in'.tr);

    Future.delayed(const Duration(seconds: 2), () {
      DialogHelper.hideLoading();
      Get.offAllNamed(Routes.MAIN);
    });
  }

  void getOtp() {
    if (!isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'missing_information'.tr,
        message: 'enter_phone_first'.tr,
      );
      return;
    }

    DialogHelper.showLoading(message: 'sending_otp'.tr);

    Future.delayed(const Duration(seconds: 2), () {
      DialogHelper.hideLoading();

      final phoneNumber = phoneNumberController.text;

      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {'phoneNumber': phoneNumber},
      );
    });
  }

  void goToSignUp() {
    Get.toNamed(Routes.SIGNUP);
  }
}
