import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final RxString currentlyEditingField = ''.obs;
  final RxBool isEditingField = false.obs;
  final StorageService _storageService = Get.find<StorageService>();
  final ApiService _apiService = ApiService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    fetchProfileData();

    final locale = Get.locale;
    isEnglish.value = locale == null || locale.languageCode == 'en';
  }

  @override
  void onClose() {
    nameController.dispose();
    mobileController.dispose();
    dobController.dispose();
    cardNumberController.dispose();
    super.onClose();
  }

  Future<void> fetchProfileData() async {
    try {
      isLoading.value = true;

      _loadUserDataFromStorage();

      final response = await _apiService.getProfile();

      if (response['success'] == true && response['data'] != null) {
        final profileData = response['data'];

        fullName.value = profileData['name'] ?? fullName.value;
        cardNumber.value = profileData['card_number'] ?? cardNumber.value;
        mobileNumber.value = profileData['mobile'] ?? mobileNumber.value;

        String apiDob = profileData['dob'] ?? '';
        birthDate.value = (apiDob.isNotEmpty) ? apiDob : birthDate.value;

        final currentUser = _storageService.currentUser.value;
        if (currentUser != null) {
          final updatedUser = User(
            accessToken: currentUser.accessToken,
            tokenType: currentUser.tokenType,
            userId: profileData['id'] ?? currentUser.userId,
            cardNumber: profileData['card_number'] ?? currentUser.cardNumber,
            name: profileData['name'] ?? currentUser.name,
            mobile: profileData['mobile'] ?? currentUser.mobile,
            dob: profileData['dob'] ?? currentUser.dob,
            totalPoint: currentUser.totalPoint,
          );

          await _storageService.saveUser(updatedUser);
        }

        print('ProfileController - Loaded user data from API:');
        print('Name: ${fullName.value}');
        print('Card Number ${cardNumber.value}');
        print('Mobile: ${mobileNumber.value}');
        print('DOB: ${birthDate.value}');
      } else {
        print(
          'Failed to fetch profile data from API, using storage data instead',
        );
      }
    } catch (e) {
      print('Error fetching profile data: $e');

      String errorMsg = e.toString().toLowerCase();
      if (errorMsg.contains('unauthenticated') ||
          errorMsg.contains('unauthorized') ||
          errorMsg.contains('token') ||
          errorMsg.contains('not found') ||
          errorMsg.contains('user not exist')) {
        print('Authentication error detected, redirecting to login screen');

        await _storageService.clearUser();

        Get.offAllNamed('/login');

        return;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void _loadUserDataFromStorage() {
    final user = _storageService.currentUser.value;
    if (user != null) {
      fullName.value = user.name ?? 'John Doe';
      cardNumber.value =
          user.cardNumber.isNotEmpty
              ? user.cardNumber
              : _storageService.cardNumber;
      mobileNumber.value = user.mobile ?? '+81 90-1234-5678';
      birthDate.value =
          (user.dob != null && user.dob!.isNotEmpty) ? user.dob! : '';
      totalPoints.value = user.totalPoint ?? 0;
    } else {
      fullName.value = 'John Doe';
      cardNumber.value = _storageService.cardNumber;
      mobileNumber.value = '+81 90-1234-5678';
      birthDate.value = '';
      totalPoints.value = 0;
    }

    print('ProfileController - Loaded user data from storage:');
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
    print('editField called with field: $field');

    switch (field) {
      case 'Full Name':
        nameController.text = fullName.value;
        print('Setting nameController text to: ${fullName.value}');
        break;
      case 'Mobile Number':
        mobileController.text = mobileNumber.value;
        print('Setting mobileController text to: ${mobileNumber.value}');
        break;
      case 'Birth Date':
        dobController.text = birthDate.value;
        print('Setting dobController text to: ${birthDate.value}');
        break;
      case 'Card Number':
        cardNumberController.text = cardNumber.value;
        print('Setting cardNumberController text to: ${cardNumber.value}');
        break;
      default:
        print('Field not recognized: $field');
        DialogHelper.showInfoDialog(
          title: 'Edit $field',
          message: 'Editing functionality will be available soon',
        );
        return;
    }

    currentlyEditingField.value = field;
    isEditingField.value = true;
    print('Set currentlyEditingField to: $field, isEditingField to: true');
  }

  void saveField(String field) {
    print('saveField called with field: $field');
    String newValue = '';

    switch (field) {
      case 'Full Name':
        newValue = nameController.text.trim();
        if (newValue.isNotEmpty) {
          fullName.value = newValue;
          print('Updated fullName to: $newValue');

          _updateUserInStorage(name: newValue);
        }
        break;
      case 'Mobile Number':
        newValue = mobileController.text.trim();
        if (newValue.isNotEmpty) {
          mobileNumber.value = newValue;
          print('Updated mobileNumber to: $newValue');

          _updateUserInStorage(mobile: newValue);
        }
        break;
      case 'Birth Date':
        newValue = dobController.text.trim();

        birthDate.value = newValue;
        print('Updated birthDate to: $newValue');

        _updateUserInStorage(dob: newValue);
        break;
      case 'Card Number':
        newValue = cardNumberController.text.trim();
        if (newValue.isNotEmpty) {
          cardNumber.value = newValue;
          print('Updated cardNumber to: $newValue');

          _updateUserInStorage(cardNumber: newValue);
        }
        break;
    }

    currentlyEditingField.value = '';
    isEditingField.value = false;
    print('Reset editing state');
  }

  void saveFieldLocally(String field) {
    print('saveFieldLocally called with field: $field');
    String newValue = '';

    switch (field) {
      case 'Full Name':
        newValue = nameController.text.trim();
        fullName.value = newValue;
        print('Updated fullName locally to: $newValue');
        break;
      case 'Mobile Number':
        newValue = mobileController.text.trim();
        mobileNumber.value = newValue;
        print('Updated mobileNumber locally to: $newValue');
        break;
      case 'Birth Date':
        newValue = dobController.text.trim();
        birthDate.value = newValue;
        print('Updated birthDate locally to: $newValue');
        break;
      case 'Card Number':
        newValue = cardNumberController.text.trim();
        cardNumber.value = newValue;
        print('Updated cardNumber locally to: $newValue');
        break;
    }

    currentlyEditingField.value = '';
    isEditingField.value = false;
    print('Reset editing state');
  }

  void cancelEditing() {
    print('cancelEditing called');

    currentlyEditingField.value = '';
    isEditingField.value = false;
    print('Reset editing state');
  }

  void updateProfile() async {
    try {
      isLoading.value = true;

      // If any field is currently being edited, save it locally first
      if (isEditingField.value && currentlyEditingField.value.isNotEmpty) {
        saveFieldLocally(currentlyEditingField.value);
      }

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

      final response = await _apiService.updateProfile(
        name: fullName.value.trim(),
        mobile: mobileNumber.value.trim(),
        cardNumber: cardNumber.value.trim(),
        totalPoint: totalPoints.value,
        dob: birthDate.value.trim(),
      );

      print('Profile update response: $response');

      if (response.containsKey('user') || response.containsKey('data')) {
        final userData = response['user'] ?? response['data'] ?? response;

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

          await _storageService.saveUser(updatedUser);

          _loadUserDataFromStorage();
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
        await _storageService.clearUser();
        print('User data cleared from storage');

        Get.offAllNamed('/login');
      },
    );
  }

  void aboutPoints() {
    Get.toNamed('/about-points');
  }

  void _updateUserInStorage({
    String? name,
    String? mobile,
    String? dob,
    String? cardNumber,
  }) {
    final currentUser = _storageService.currentUser.value;
    if (currentUser != null) {
      final updatedUser = User(
        accessToken: currentUser.accessToken,
        tokenType: currentUser.tokenType,
        userId: currentUser.userId,
        cardNumber: cardNumber ?? currentUser.cardNumber,
        name: name ?? currentUser.name,
        mobile: mobile ?? currentUser.mobile,
        dob: dob ?? currentUser.dob,
        totalPoint: currentUser.totalPoint,
      );

      _storageService.saveUser(updatedUser);

      Get.find<StorageService>().updateCurrentUser(updatedUser);
    }
  }
}
