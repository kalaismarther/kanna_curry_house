import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/splash/splash_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (controller) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  AppImages.splashLeftCorner,
                  height: DeviceHelper.screenHeight(context) * 0.3,
                  width: DeviceHelper.screenWidth(context) * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  AppImages.splashRightCorner,
                  height: DeviceHelper.screenHeight(context) * 0.3,
                  width: DeviceHelper.screenWidth(context) * 0.7,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 150.sp,
                  child: Center(
                    child: Image.asset(
                      AppImages.logo,
                      height: 200.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
