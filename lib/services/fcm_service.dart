import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../app/routes/app_pages.dart';
import '../app/modules/main/controllers/main_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}

class FCMService extends GetxService {
  static FCMService get to => Get.find();

  final RxString fcmToken = ''.obs;
  final RxBool isInitialized = false.obs;

  final String allUsersTopic = 'all_users';

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> subscribeToAllUsersTopic() async {
    try {
      await FirebaseMessaging.instance.subscribeToTopic(allUsersTopic);
      print('✅ Successfully subscribed to topic: $allUsersTopic');
    } catch (e) {
      print('❌ Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromAllUsersTopic() async {
    try {
      await FirebaseMessaging.instance.unsubscribeFromTopic(allUsersTopic);
      print('✅ Successfully unsubscribed from topic: $allUsersTopic');
    } catch (e) {
      print('❌ Error unsubscribing from topic: $e');
    }
  }

  Future<void> setupNotificationHandlers() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
          'Message also contained a notification: ${message.notification!.title}',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      _handleNotification(message);
    });

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state via notification');
      _handleNotification(initialMessage);
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _handleNotification(RemoteMessage message) {
    print('Handling notification: ${message.messageId}');
    print('Notification data: ${message.data}');

    Get.offAllNamed(Routes.MAIN);

    Future.delayed(Duration(milliseconds: 300), () {
      try {
        if (Get.isRegistered<MainController>()) {
          final mainController = Get.find<MainController>();
          mainController.changePage(0);
        }
      } catch (e) {
        print('Error navigating to news tab: $e');
      }
    });
  }

  Future<void> getToken() async {
    try {
      if (Firebase.apps.isEmpty) {
        print('Firebase not initialized yet, cannot get FCM token');
        fcmToken.value = 'firebase_not_ready';
        return;
      }

      print('🔄 Attempting to get FCM token...');
      String? token = await FirebaseMessaging.instance.getToken();

      if (token != null && token.isNotEmpty) {
        fcmToken.value = token;
        print('✅ FCM Token obtained successfully!');
        print('📱 FULL FCM TOKEN: $token');
        print('TOKEN PREVIEW: ${token.substring(0, 20)}...');
        print('📏 TOKEN LENGTH: ${token.length} characters');

        print('═══════════════════════════════════════');
        print('COPY THIS FCM TOKEN:');
        print(token);
        print('═══════════════════════════════════════');

        await subscribeToAllUsersTopic();
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
        print(
          'Warning: Firebase not initialized when FCMService.init() called',
        );
        isInitialized.value = false;
        return this;
      }

      await setupNotificationHandlers();

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
    if (!isInitialized.value ||
        fcmToken.value.startsWith('token_') ||
        fcmToken.value == 'firebase_not_ready') {
      print('🔄 Retrying FCM token retrieval...');
      await getToken();
    }
  }

  void printTokenStatus() {
    print('📊 FCM SERVICE STATUS:');
    print('   Initialized: ${isInitialized.value}');
    print(
      '   Token Status: ${fcmToken.value.length > 50 ? "✅ Valid Token" : "❌ ${fcmToken.value}"}',
    );
    if (fcmToken.value.length > 50) {
      print('   Current Token: ${fcmToken.value}');
    }
  }

  String get currentToken => fcmToken.value;
}
