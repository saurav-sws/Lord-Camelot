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

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await _initializeFirebase();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);




  await initServices();


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


      await Future.delayed(Duration(milliseconds: 500));
    }
  }
}



Future<void> initServices() async {
  try {
    print('Initializing services...');


    await Get.putAsync(() => StorageService().init());
    print('StorageService initialized');


    await Get.putAsync(() => FCMService().init());
    print('FCMService initialized');


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



    FirebaseMessaging.instance.onTokenRefresh
        .listen((fcmToken) {
      print('🔄 FCM Token refreshed!');
      print('🆕 NEW FCM TOKEN: $fcmToken');
      print('═══════════════════════════════════════');
      print('COPY THIS REFRESHED FCM TOKEN:');
      print(fcmToken);
      print('═══════════════════════════════════════');


      if (Get.isRegistered<FCMService>()) {
        FCMService.to.fcmToken.value = fcmToken;
      }
    })
        .onError((err) {
      print('❌ Error refreshing FCM token: $err');
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

    print('FCM setup completed successfully');


    if (Get.isRegistered<FCMService>()) {
      print('📱 FINAL FCM TOKEN CHECK:');
      FCMService.to.printTokenStatus();
    }
  } catch (e) {
    print('Error setting up FCM: $e');

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