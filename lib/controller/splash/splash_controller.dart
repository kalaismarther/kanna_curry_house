import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/internet_services.dart';
import 'package:kanna_curry_house/core/utils/location_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';
import 'package:kanna_curry_house/view/screens/splash/get_started_screen.dart';
import 'package:permission_handler/permission_handler.dart';

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
            await startApp();
            return;
          }
        } else {
          turnOnLocation();
        }
      } else {
        await startApp();
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

  Future<void> startApp() async {
    bool? alreadyLoggedIn = await StorageHelper.read('logged');

    if (alreadyLoggedIn == true) {
      Get.offAll(() => const DashboardScreen());
    } else {
      Get.offAll(() => const GetStartedScreen());
    }
  }
}
