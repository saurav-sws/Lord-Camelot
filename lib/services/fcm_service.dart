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
    // Don't call getToken() here - let init() handle it
  }

  Future<void> getToken() async {
    try {
      // Check if Firebase is initialized first
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

        // Also print to make it easy to copy
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

      // Wait a bit to ensure Firebase is fully ready
      await Future.delayed(Duration(milliseconds: 100));

      // Verify Firebase is initialized
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

  // Method to retry getting token if it failed initially
  Future<void> retryGetToken() async {
    if (!isInitialized.value || fcmToken.value.startsWith('token_') || fcmToken.value == 'firebase_not_ready') {
      print('🔄 Retrying FCM token retrieval...');
      await getToken();
    }
  }

  // Method to print current token status
  void printTokenStatus() {
    print('📊 FCM SERVICE STATUS:');
    print('   Initialized: ${isInitialized.value}');
    print('   Token Status: ${fcmToken.value.length > 50 ? "✅ Valid Token" : "❌ ${fcmToken.value}"}');
    if (fcmToken.value.length > 50) {
      print('   Current Token: ${fcmToken.value}');
    }
  }

  // Get token as a getter for easy access
  String get currentToken => fcmToken.value;
}