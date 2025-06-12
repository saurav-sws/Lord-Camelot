import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FCMService extends GetxService {
  static FCMService get to => Get.find();

  final RxString fcmToken = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getToken();
  }

  Future<void> getToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null && token.isNotEmpty) {
        fcmToken.value = token;
        print('FCM Token: $token');
      }
    } catch (e) {
      print('Error getting FCM token: $e');
      fcmToken.value = 'token_error';
    }
  }

  Future<FCMService> init() async {
    await getToken();
    return this;
  }
}
