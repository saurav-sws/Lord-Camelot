import 'dart:ui';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final RxBool isEnglish = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Default to Japanese instead of English
    final locale = Get.locale;
    isEnglish.value = locale != null && locale.languageCode == 'en';
  }

  void toggleLanguage() {
    isEnglish.value = !isEnglish.value;

    // Toggle between Japanese and English
    if (isEnglish.value) {
      Get.updateLocale(const Locale('en', 'US'));
    } else {
      Get.updateLocale(const Locale('ja', 'JP'));
    }
  }
}
