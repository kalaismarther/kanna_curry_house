import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/auth/login_controller.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/view/screens/auth/login_screen.dart';
import 'package:kanna_curry_house/view/screens/splash/splash_screen.dart';

class AuthHelper {
  static void logoutUser({String? message}) async {
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>(force: true);
    }
    await StorageHelper.deleteAll();
    UiHelper.showToast(message ?? 'Session Expired');
    Get.offAll(() => const SplashScreen());
  }

  static bool isGuestUser() {
    final isGuestUser = StorageHelper.read('guest_login');
    return isGuestUser == true;
  }

  static void redirectGuestUserToLogin() async {
    if (Get.isRegistered<LoginController>()) {
      Get.delete<LoginController>(force: true);
    }
    await StorageHelper.deleteAll();
    Get.offAll(() => LoginScreen());
  }
}
