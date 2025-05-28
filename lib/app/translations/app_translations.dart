import 'package:get/get.dart';
import 'en_US.dart';
import 'ja_JP.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en_US': enUS, 'ja_JP': jaJP};
}
