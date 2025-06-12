import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/dialog_helper.dart';
import '../../login/views/login_view.dart';
import '../../../../services/storage_service.dart';
import '../../../../services/api_service.dart';
import '../../../models/user_model.dart';

class ProfileController extends GetxController {
  final RxString fullName = ''.obs;
  final RxString cardNumber = ''.obs;
  final RxString mobileNumber = ''.obs;
  final RxString birthDate = ''.obs;
  final RxInt totalPoints = 0.obs;

  final RxBool isEnglish = true.obs;
  final RxBool isLoading = false.obs;
  final StorageService _storageService = Get.find<StorageService>();
  final ApiService _apiService = ApiService();

  // Text controllers for editing
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Load user data from storage
    _loadUserData();

    final locale = Get.locale;
    isEnglish.value = locale == null || locale.languageCode == 'en';
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    super.onClose();
  }

  void _loadUserData() {
    final user = _storageService.currentUser.value;
    if (user != null) {
      fullName.value = user.name ?? 'John Doe';
      cardNumber.value =
          user.cardNumber.isNotEmpty
              ? user.cardNumber
              : _storageService.cardNumber;
      mobileNumber.value = user.mobile ?? '+81 90-1234-5678';
      birthDate.value = user.dob ?? '1990-01-01';
      totalPoints.value = user.totalPoint ?? 0;
    } else {
      // Fallback values
      fullName.value = 'John Doe';
      cardNumber.value = _storageService.cardNumber;
      mobileNumber.value = '+81 90-1234-5678';
      birthDate.value = '1990-01-01';
      totalPoints.value = 0;
    }

    print('ProfileController - Loaded user data:');
    print('Name: ${fullName.value}');
    print('Card Number: ${cardNumber.value}');
    print('Mobile: ${mobileNumber.value}');
    print('DOB: ${birthDate.value}');
    print('Total Points: ${totalPoints.value}');
  }

  void toggleLanguage() {
    isEnglish.value = !isEnglish.value;

    if (isEnglish.value) {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ja', 'JP'));
    }

    DialogHelper.showInfoDialog(
      title: isEnglish.value ? 'Language: English' : '言語：日本語',
      message: isEnglish.value ? 'Switched to English' : '日本語に切り替えました',
    );
  }

  void editField(String field) {
    TextEditingController controller;
    String currentValue;
    String title;

    switch (field) {
      case 'Full Name':
        controller = nameController;
        currentValue = fullName.value;
        title = 'Edit Name';
        break;
      case 'Mobile Number':
        controller = mobileController;
        currentValue = mobileNumber.value;
        title = 'Edit Mobile Number';
        break;
      case 'Birth Date':
        controller = dobController;
        currentValue = birthDate.value;
        title = 'Edit Birth Date';
        break;
      default:
        DialogHelper.showInfoDialog(
          title: 'Edit $field',
          message: 'Editing functionality will be available soon',
        );
        return;
    }

    controller.text = currentValue;

    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter $field',
            hintStyle: const TextStyle(color: Colors.white54),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
            ),
          ),
          keyboardType:
              field == 'Mobile Number'
                  ? TextInputType.phone
                  : field == 'Birth Date'
                  ? TextInputType.datetime
                  : TextInputType.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              final newValue = controller.text.trim();
              if (newValue.isNotEmpty) {
                switch (field) {
                  case 'Full Name':
                    fullName.value = newValue;
                    break;
                  case 'Mobile Number':
                    mobileNumber.value = newValue;
                    break;
                  case 'Birth Date':
                    birthDate.value = newValue;
                    break;
                }
                Get.back();
                DialogHelper.showInfoDialog(
                  title: 'Field Updated',
                  message:
                      '$field has been updated. Click "Update" button to save changes.',
                );
              }
            },
            child: const Text('Save', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void updateProfile() async {
    try {
      isLoading.value = true;

      // Validate required fields
      if (fullName.value.trim().isEmpty) {
        DialogHelper.showErrorDialog(
          title: 'Validation Error',
          message: 'Name is required',
        );
        return;
      }

      if (mobileNumber.value.trim().isEmpty) {
        DialogHelper.showErrorDialog(
          title: 'Validation Error',
          message: 'Mobile number is required',
        );
        return;
      }

      if (cardNumber.value.trim().isEmpty) {
        DialogHelper.showErrorDialog(
          title: 'Validation Error',
          message: 'Card number is required',
        );
        return;
      }

      // Call the update API
      final response = await _apiService.updateProfile(
        name: fullName.value.trim(),
        mobile: mobileNumber.value.trim(),
        cardNumber: cardNumber.value.trim(),
        totalPoint: totalPoints.value,
        dob: birthDate.value.trim(),
      );

      print('Profile update response: $response');

      // Update local storage with new data if API returns updated user data
      if (response.containsKey('user') || response.containsKey('data')) {
        final userData = response['user'] ?? response['data'] ?? response;

        // Create updated user object
        final currentUser = _storageService.currentUser.value;
        if (currentUser != null) {
          final updatedUser = User(
            accessToken: currentUser.accessToken,
            tokenType: currentUser.tokenType,
            userId: currentUser.userId,
            cardNumber: cardNumber.value.trim(),
            name: fullName.value.trim(),
            mobile: mobileNumber.value.trim(),
            dob: birthDate.value.trim(),
            totalPoint: totalPoints.value,
          );

          // Save updated user to storage
          await _storageService.saveUser(updatedUser);

          // Reload user data
          _loadUserData();
        }
      }

      DialogHelper.showSuccessDialog(
        title: 'Profile Updated',
        message: 'Your profile has been updated successfully',
      );
    } catch (e) {
      print('Error updating profile: $e');
      DialogHelper.showErrorDialog(
        title: 'Update Failed',
        message:
            'Failed to update profile: ${e.toString().replaceAll('Exception: ', '')}',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    DialogHelper.showWarningDialog(
      title: 'log_out'.tr,
      message: 'logout_confirmation'.tr,
      buttonText: 'yes_logout'.tr,
      onConfirm: () async {
        // Clear user data from storage
        await _storageService.clearUser();
        print('User data cleared from storage');

        // Navigate to login screen and clear all previous routes
        Get.offAllNamed('/login');
      },
    );
  }

  void aboutPoints() {
    Get.toNamed('/about-points');
  }
}
