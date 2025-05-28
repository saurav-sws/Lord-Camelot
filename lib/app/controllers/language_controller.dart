import 'dart:ui';
import 'package:get/get.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();

  final RxBool isEnglish = true.obs;

  @override
  void onInit() {
    super.onInit();


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
  }
}
