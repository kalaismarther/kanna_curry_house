import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';

import 'package:kanna_curry_house/view/widgets/logout_dialog.dart';

class DashboardController extends GetxController {
  var currentTab = 0.obs;

  void changeTab(int tabNo) {
    currentTab.value = tabNo;
  }

  Future<void> exitAlert() async {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Are you sure to exit the app?',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              SystemNavigator.pop();
            },
            child: const Text('Yes'),
          )
        ],
      ),
    );
  }

  Future<void> logout() async {
    try {
      if (AuthHelper.isGuestUser()) {
        AuthHelper.logoutUser(message: 'Logged out as Guest');
        return;
      }
      if (Get.isDialogOpen == true) {
        Get.back();
      }
      UiHelper.showLoadingDialog();
      final result = await ApiServices.logout();

      UiHelper.closeLoadingDialog();

      AuthHelper.logoutUser(message: result);
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void showLogoutAlert() => Get.dialog(LogoutDialog(onLogout: logout));
}
