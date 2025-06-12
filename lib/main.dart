import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lordcamelot_point/services/fcm_service.dart';
import 'package:lordcamelot_point/services/firebase_options.dart';
import 'package:lordcamelot_point/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/app_translations.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Test SharedPreferences
  try {
    final prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized successfully');

    // Test writing and reading
    await prefs.setString('test_key', 'test_value');
    final testValue = prefs.getString('test_key');
    print('SharedPreferences test value: $testValue');
  } catch (e) {
    print('Error initializing SharedPreferences: $e');
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize services
  await initServices();

  await initializeFCM();

  runApp(const MyApp());
}

Future<void> initServices() async {
  try {
    // Initialize storage service
    final storageService = await Get.putAsync(() => StorageService().init());
    print('Storage service initialized: ${storageService.hasUser}');

    // Initialize FCM service
    await Get.putAsync(() => FCMService().init());

    print('All services initialized');
  } catch (e) {
    print('Error initializing services: $e');
  }
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
