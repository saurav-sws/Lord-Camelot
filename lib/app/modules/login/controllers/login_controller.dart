import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';
import '../../../../services/api_service.dart';
import '../../../../services/storage_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();

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
    cardNumberController.value = null;

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

  Future<void> login() async {
    if (!isCardNumberValid.value || !isPhoneNumberValid.value) {
      DialogHelper.showErrorDialog(
        title: 'missing_information'.tr,
        message: 'enter_both'.tr,
      );
      return;
    }

    final String cardNumber = cardNumberController.value?.text ?? '';
    final String password = phoneNumberController.value?.text ?? '';

    DialogHelper.showLoading(message: 'logging_in'.tr);

    try {
      final response = await _apiService.login(cardNumber, password);

      print('Login response: $response');

      // Create a user from the response
      final user = User.fromJson(response);

      print('User created with token: ${user.accessToken}');

      // Save user data (this might fail but we'll continue anyway)
      try {
        await _storageService.saveUser(user);
        print('User saved successfully');
      } catch (saveError) {
        // If saving fails, we'll still proceed with the login
        print('Error saving user but proceeding with login: $saveError');

        // Ensure the user is at least available in memory
        _storageService.currentUser.value = user;
        _storageService.isLoggedIn.value = true;
      }

      print('User saved, navigating to main screen');

      DialogHelper.hideLoading();

      // Navigate to the main screen
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      print('Login error: $e');
      DialogHelper.hideLoading();
      DialogHelper.showErrorDialog(title: 'error'.tr, message: e.toString());
    }
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
