import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parrotpos/config/config.dart';
import 'package:parrotpos/screens/splash_screen.dart';

import 'package:parrotpos/style/colors.dart';
import 'package:parrotpos/style/theme.dart';

import 'controllers/internet_controller.dart';
import 'firebase/firebase_option.dart';

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: kWhite,
      systemNavigationBarColor: kWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return GetMaterialApp(
      title: Config().appName,
      debugShowCheckedModeBanner: false,
      theme: themeData,
      home: const SplashScreen(),
      // initialBinding: InternetBinding(),
      // onReady: InternetController.new,
    );
  }
}

// class InternetBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.put(InternetController());
//   }
// }
