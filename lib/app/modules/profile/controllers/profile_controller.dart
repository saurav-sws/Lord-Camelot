import 'dart:ui';

import 'package:get/get.dart';
import '../../../utils/dialog_helper.dart';
import '../../login/views/login_view.dart';

class ProfileController extends GetxController {
  final RxString fullName = ''.obs;
  final RxString cardNumber = ''.obs;
  final RxString mobileNumber = ''.obs;
  final RxString birthDate = ''.obs;

  final RxBool isEnglish = true.obs;

  @override
  void onInit() {
    super.onInit();


    fullName.value = 'John Doe';
    cardNumber.value = '678543';
    mobileNumber.value = '+81 90-1234-5678';
    birthDate.value = '1990-01-01';


    final locale = Get.locale;
    isEnglish.value = locale == null || locale.languageCode == 'en';
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
    DialogHelper.showInfoDialog(
      title: 'Edit $field',
      message: 'Editing functionality will be available soon',
    );
  }

  void updateProfile() {
    DialogHelper.showSuccessDialog(
      title: 'Profile Updated',
      message: 'Your profile has been updated successfully',
    );
  }

  void logout() {
    DialogHelper.showWarningDialog(
      title: 'Log Out',
      message: 'Are you sure you want to log out?',
      buttonText: 'Yes, Log Out',
      onConfirm: () {
        Get.offAll(() => const LoginView());
      },
    );
  }

  void aboutPoints() {
    Get.toNamed('/about-points');
  }
}
