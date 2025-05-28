import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';

class LoginController extends GetxController {

  Rx<TextEditingController?> cardNumberController = Rx<TextEditingController?>(
    null,
  );
  Rx<TextEditingController?> phoneNumberController = Rx<TextEditingController?>(
    null,
  );

  final RxBool isLoading = false.obs;
  final RxBool isCardNumberValid = false.obs;
  final RxBool isPhoneNumberValid = false.obs;

  @override
  void onInit() {
    super.onInit();

    cardNumberController.value = TextEditingController();
    phoneNumberController.value = TextEditingController();
  }

  @override
  void onClose() {

    cardNumberController.value?.dispose();
    phoneNumberController.value = null;

    phoneNumberController.value?.dispose();
    phoneNumberController.value = null;

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
        title: 'Missing Information',
        message: 'Please enter both Card Number and Phone Number',
      );
      return;
    }

    DialogHelper.showLoading(message: 'Logging in...');

    Future.delayed(const Duration(seconds: 2), () {
      DialogHelper.hideLoading();
      Get.offAllNamed(Routes.MAIN);
    });
  }

  void getOtp() {
    if (!isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'Missing Information',
        message: 'Please enter your Phone Number first',
      );
      return;
    }

    DialogHelper.showLoading(message: 'Sending OTP...');

    Future.delayed(const Duration(seconds: 2), () {
      DialogHelper.hideLoading();

      final phoneNumber = phoneNumberController.value?.text ?? '';

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
