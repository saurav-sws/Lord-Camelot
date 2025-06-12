import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../../../services/storage_service.dart';

class SplashController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 3), () {
      checkAuthAndNavigate();
    });
  }

  void checkAuthAndNavigate() {
    // Check if user is logged in
    if (_storageService.hasUser) {
      print('User is logged in, navigating to main screen');
      Get.offAllNamed(Routes.MAIN);
    } else {
      print('User is not logged in, navigating to login screen');
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
