import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lordcamelot_point/services/fcm_service.dart';
import 'package:lordcamelot_point/services/firebase_options.dart';
import 'package:lordcamelot_point/services/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/app_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Test SharedPreferences
  await testSharedPreferences();

  // Initialize services
  await initServices();

  await initializeFCM();

  runApp(const MyApp());
}

Future<void> testSharedPreferences() async {
  try {
    print('Testing SharedPreferences functionality...');
    final prefs = await SharedPreferences.getInstance();

    // Try writing to SharedPreferences
    final testKey = 'test_key_${DateTime.now().millisecondsSinceEpoch}';
    final testValue = 'test_value_${DateTime.now().millisecondsSinceEpoch}';

    await prefs.setString(testKey, testValue);
    final readValue = prefs.getString(testKey);

    if (readValue == testValue) {
      print('SharedPreferences test passed: write/read successful');
    } else {
      print(
        'SharedPreferences test failed: value mismatch. Expected $testValue, got $readValue',
      );
    }

    // Clean up
    await prefs.remove(testKey);
  } catch (e) {
    print('SharedPreferences test error: $e');
  }
}

Future<void> initServices() async {
  // Initialize storage service
  await Get.putAsync(() => StorageService().init());

  // Initialize FCM service
  await Get.putAsync(() => FCMService().init());

  print('All services initialized');
}

Future<void> initializeFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  String? token = await messaging.getToken();
  print('FCM Token: $token');

  FirebaseMessaging.instance.onTokenRefresh
      .listen((fcmToken) {
        print('FCM Token refreshed: $fcmToken');
      })
      .onError((err) {
        print('Error refreshing FCM token: $err');
      });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('A new onMessageOpenedApp event was published!');
    print('Message data: ${message.data}');
  });

  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    print('App opened from terminated state via notification');
    print('Initial message data: ${initialMessage.data}');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'Lord Camelot',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Montserrat',
            scaffoldBackgroundColor: Colors.black,
          ),
          // Translations
          translations: AppTranslations(),
          locale: Get.deviceLocale,
          fallbackLocale: const Locale('en', 'US'),

          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
