import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lordcamelot_point/services/api_service.dart';
import 'package:lordcamelot_point/services/fcm_service.dart';
import 'package:lordcamelot_point/services/firebase_options.dart';
import 'package:lordcamelot_point/services/storage_service.dart';
import 'app/routes/app_pages.dart';
import 'app/translations/app_translations.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Ensure Firebase is initialized for background messages
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase first - with robust error handling
  await _initializeFirebase();

  // Set up background message handler AFTER Firebase is initialized
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Test SharedPreferences (doesn't require Firebase)
  await testSharedPreferences();

  // Initialize services AFTER Firebase is ready
  await initServices();

  // Initialize FCM last (requires Firebase + services to be ready)
  await initializeFCM();

  runApp(const MyApp());
}

Future<void> _initializeFirebase() async {
  int attempts = 0;
  const maxAttempts = 3;

  while (attempts < maxAttempts) {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
        print('Firebase initialized successfully on attempt ${attempts + 1}');
        return;
      } else {
        print('Firebase already initialized');
        return;
      }
    } catch (e) {
      attempts++;
      print('Firebase initialization attempt $attempts failed: $e');

      if (e.toString().contains('duplicate-app')) {
        print('Firebase already initialized (duplicate app detected)');
        return;
      }

      if (attempts >= maxAttempts) {
        print('Failed to initialize Firebase after $maxAttempts attempts');
        rethrow;
      }

      // Wait a bit before retrying
      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}

Future<void> testSharedPreferences() async {
  try {
    print('Testing SharedPreferences functionality...');
    final prefs = await SharedPreferences.getInstance();

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

    await prefs.remove(testKey);
  } catch (e) {
    print('SharedPreferences test error: $e');
  }
}

Future<void> initServices() async {
  try {
    print('Initializing services...');

    // Initialize StorageService first (doesn't depend on Firebase)
    await Get.putAsync(() => StorageService().init());
    print('StorageService initialized');

    // Initialize FCMService (depends on Firebase being ready)
    await Get.putAsync(() => FCMService().init());
    print('FCMService initialized');

    // Register ApiService as a permanent dependency
    Get.put(ApiService(), permanent: true);
    print('ApiService initialized');

    print('All services initialized successfully');
  } catch (e) {
    print('Error initializing services: $e');
    rethrow;
  }
}

Future<void> initializeFCM() async {
  try {
    print('Setting up FCM listeners...');

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions
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

    // The FCM token is already handled by FCMService.init()
    // So we don't need to get it again here

    // Set up listeners for token refresh
    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      print('🔄 FCM Token refreshed!');
      print('🆕 NEW FCM TOKEN: $fcmToken');
      print('═══════════════════════════════════════');
      print('COPY THIS REFRESHED FCM TOKEN:');
      print(fcmToken);
      print('═══════════════════════════════════════');

      // Update the token in FCMService
      if (Get.isRegistered<FCMService>()) {
        FCMService.to.fcmToken.value = fcmToken;
      }
    })
        .onError((err) {
      print('❌ Error refreshing FCM token: $err');
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    // Handle messages when app is opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');
    });

    // Handle initial message if app was opened from notification
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state via notification');
      print('Initial message data: ${initialMessage.data}');
    }

    print('FCM setup completed successfully');

    // Print final token status
    if (Get.isRegistered<FCMService>()) {
      print('📱 FINAL FCM TOKEN CHECK:');
      FCMService.to.printTokenStatus();
    }
  } catch (e) {
    print('Error setting up FCM: $e');
    // Don't rethrow here as FCM issues shouldn't crash the app
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
      useInheritedMediaQuery: true,
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