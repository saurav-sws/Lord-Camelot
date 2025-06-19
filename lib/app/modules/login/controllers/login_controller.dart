import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/dialog_helper.dart';
import '../../../../services/api_service.dart';
import '../../../../services/storage_service.dart';
import '../../../../services/fcm_service.dart';

class LoginController extends GetxController {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = Get.find<StorageService>();
  final FCMService _fcmService = Get.find<FCMService>();

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

      if (response['access_token'] == null) {
        throw Exception('No access token received from server. Login failed.');
      }

      // Create a user from the response
      final user = User.fromJson(response);

      print('User created with token: ${user.accessToken.substring(0, 10)}...');

      if (user.accessToken.isEmpty || user.userId == 0) {
        throw Exception('Invalid user data received. Login failed.');
      }

      // Save user data (this might fail but we'll continue anyway)
      bool savedSuccessfully = false;
      try {
        await _storageService.saveUser(user);
        savedSuccessfully = true;
        print('User saved successfully to storage');
      } catch (saveError) {
        // If saving fails, we'll still proceed with the login
        print('Error saving user but proceeding with login: $saveError');

        // Ensure the user is at least available in memory
        _storageService.currentUser.value = user;
        _storageService.isLoggedIn.value = true;
      }

      // Subscribe to FCM topic for all users
      await _fcmService.subscribeToAllUsersTopic();

      // Verify login status
      final loggedIn = _storageService.hasUser;
      print(
        'After login process - Is user logged in: $loggedIn (data saved: $savedSuccessfully)',
      );

      if (!loggedIn) {
        throw Exception('Failed to establish login session. Please try again.');
      }

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
