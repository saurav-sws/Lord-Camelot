import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class FCMService extends GetxService {
  static FCMService get to => Get.find();

  final RxString fcmToken = ''.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> getToken() async {
    try {

      if (Firebase.apps.isEmpty) {
        print('❌ Firebase not initialized yet, cannot get FCM token');
        fcmToken.value = 'firebase_not_ready';
        return;
      }

      print('🔄 Attempting to get FCM token...');
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null && token.isNotEmpty) {
        fcmToken.value = token;
        print('✅ FCM Token obtained successfully!');
        print('📱 FULL FCM TOKEN: $token');
        print('📋 TOKEN PREVIEW: ${token.substring(0, 20)}...');
        print('📏 TOKEN LENGTH: ${token.length} characters');


        print('═══════════════════════════════════════');
        print('COPY THIS FCM TOKEN:');
        print(token);
        print('═══════════════════════════════════════');
      } else {
        print('❌ FCM token is null or empty');
        fcmToken.value = 'token_null';
      }
    } catch (e) {
      print('❌ Error getting FCM token: $e');
      fcmToken.value = 'token_error';
    }
  }

  Future<FCMService> init() async {
    try {
      print('Initializing FCMService...');


      await Future.delayed(Duration(milliseconds: 100));


      if (Firebase.apps.isEmpty) {
        print('Warning: Firebase not initialized when FCMService.init() called');
        isInitialized.value = false;
        return this;
      }

      await getToken();
      isInitialized.value = true;
      print('FCMService initialization completed');

    } catch (e) {
      print('Error initializing FCMService: $e');
      isInitialized.value = false;
    }

    return this;
  }


  Future<void> retryGetToken() async {
    if (!isInitialized.value || fcmToken.value.startsWith('token_') || fcmToken.value == 'firebase_not_ready') {
      print('🔄 Retrying FCM token retrieval...');
      await getToken();
    }
  }


  void printTokenStatus() {
    print('📊 FCM SERVICE STATUS:');
    print('   Initialized: ${isInitialized.value}');
    print('   Token Status: ${fcmToken.value.length > 50 ? "✅ Valid Token" : "❌ ${fcmToken.value}"}');
    if (fcmToken.value.length > 50) {
      print('   Current Token: ${fcmToken.value}');
    }
  }


  String get currentToken => fcmToken.value;
}