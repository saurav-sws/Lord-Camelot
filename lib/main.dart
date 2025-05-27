import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lordcamelot_point/services/firebase_options.dart';
import 'app/routes/app_pages.dart';


Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(
        360,
        800,
      ),
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
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    );
  }
}
