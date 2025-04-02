import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/core/services/notification_service.dart';
import 'package:kanna_curry_house/firebase_options.dart';
import 'package:kanna_curry_house/view/screens/splash/splash_screen.dart';
import 'controller/dashboard/dashboard_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  await GetStorage.init();
  await NotificationService().init();
  Get.put(DashboardController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      child: GetMaterialApp(
        title: 'Kanna Curry House',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme(),
        home: const SplashScreen(),
      ),
    );
  }
}
