import 'package:get/get.dart';
import '../../../../services/storage_service.dart';

class MyProfileController extends GetxController {
  final StorageService _storageService = Get.find<StorageService>();

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    final token = await _storageService.getAccessToken();
    final authHeader = await _storageService.getAuthHeader();

    print('Current auth token: $token');
    print('Current auth header: $authHeader');

    if (token != null && token.isNotEmpty) {
      print('User is authenticated with token: ${token.substring(0, 10)}...');
    } else {
      print('No authentication token found');
    }
  }

  void logout() {
    _storageService.clearUser();
    Get.offAllNamed('/login');
  }
}
