import 'package:get/get.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/view/screens/splash/splash_screen.dart';

class AuthHelper {
  static void logoutUser({String? message}) async {
    await StorageHelper.deleteAll();
    UiHelper.showToast(message ?? 'Session Expired');
    Get.offAll(() => const SplashScreen());
  }

  static bool isGuestUser() {
    final isGuestUser = StorageHelper.read('guest_login');

    return isGuestUser == true;
  }
}
