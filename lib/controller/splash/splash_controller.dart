import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/Core/Utils/device_helper.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/core/services/internet_services.dart';
import 'package:kanna_curry_house/core/utils/location_helper.dart';
import 'package:kanna_curry_house/core/utils/network_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';
import 'package:kanna_curry_house/view/screens/splash/get_started_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 1), checkLocationPermissions);
    super.onInit();
  }

  bool isNotificationTapped = false;

  Future<void> checkLocationPermissions() async {
    try {
      bool hasLocationPermission = await LocationHelper.hasLocationPermission();

      if (!hasLocationPermission) {
        final bool? goToSettings = await Get.dialog(
          AlertDialog.adaptive(
            title: const Text('Location Permission Required'),
            content: const Text(
                'We use your location to show nearby available orders and enhance your booking experience.'),
            actions: [
              TextButton(
                child: const Text('Recheck'),
                onPressed: () {
                  Get.back(result: false);
                  checkLocationPermissions();
                },
              ),
              TextButton(
                child: const Text('Open Settings'),
                onPressed: () => Get.back(result: true),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (goToSettings == true) {
          await openAppSettings();
          checkLocationPermissions();
        }
        return;
      }
      turnOnLocation();
    } catch (e) {
      SystemNavigator.pop();
    }
  }

  void turnOnLocation() async {
    try {
      bool isLocationEnabled = await LocationHelper.isLocationEnabled();

      if (!isLocationEnabled) {
        final bool? enableLocation = await Get.dialog(
          AlertDialog.adaptive(
            title: const Text('Enable Location Services'),
            content: const Text(
                'We use your location to show nearby available orders and enhance your booking experience.'),
            actions: [
              TextButton(
                child: const Text('Enable Location'),
                onPressed: () => Get.back(result: true),
              ),
            ],
          ),
          barrierDismissible: false,
        );

        if (enableLocation == true) {
          isLocationEnabled = await LocationHelper.isLocationEnabled();
          if (!isLocationEnabled) {
            turnOnLocation();
          } else {
            await checkVersionUpdate();
            return;
          }
        } else {
          turnOnLocation();
        }
      } else {
        await checkVersionUpdate();
      }
    } catch (e) {
      //
    }
  }

  @override
  void onClose() {
    Get.put(InternetServices());
    super.onClose();
  }

  Future<void> checkVersionUpdate() async {
    try {
      bool noInternet = await NetworkHelper.isNotConnected();

      if (noInternet) {
        startApp();
      } else {
        final newVersion = NewVersionPlus(
            androidId: 'com.smart.aadhicurryhourse',
            iOSId: 'com.smart.aadhicurryhourse');

        final status = await newVersion.getVersionStatus();

        if (status != null && status.canUpdate) {
          Get.dialog(
            PopScope(
              canPop: false,
              child: AlertDialog(
                title: Row(
                  children: [
                    Platform.isIOS
                        ? Image.asset(
                            AppImages.appStore,
                            height: 24,
                          )
                        : Image.asset(
                            AppImages.playStore,
                            height: 24,
                          ),
                    const SizedBox(width: 10),
                    const Text(
                      'Update Available',
                      style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1),
                    ),
                  ],
                ),
                content: Text(
                    'New version of this app is now available on ${Platform.isIOS ? 'App Store' : 'Play Store'}. Please update it'),
                actions: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            backgroundColor: Colors.green,
                          ),
                          onPressed: () {
                            launchUrlString(status.appStoreLink);
                          },
                          child: const Text('Update'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          startApp();
        }
      }
    } catch (e) {
      //
      startApp();
    }
  }

  Future<void> startApp() async {
    bool? alreadyLoggedIn = await StorageHelper.read('logged');

    if (kDebugMode) {
      final fcmToken = await DeviceHelper.getFCM();
      print('FCM TOKEN - $fcmToken');
    }

    if (alreadyLoggedIn == true) {
      Get.offAll(() => const DashboardScreen());
    } else {
      Get.offAll(() => const GetStartedScreen());
    }
  }
}
