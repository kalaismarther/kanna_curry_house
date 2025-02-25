import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
}
