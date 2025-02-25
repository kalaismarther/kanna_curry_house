import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class UiHelper {
  static void showLoadingDialog() => Get.dialog(
        const PopScope(
          canPop: false,
          child: Center(
            child: SpinKitCircle(
              color: Colors.white,
            ),
          ),
        ),
      );

  static void closeLoadingDialog() =>
      Get.isDialogOpen == true ? Get.back() : null;

  static void unfocus() => FocusManager.instance.primaryFocus?.unfocus();

  static void showToast(String message, {Color bgColor = Colors.black}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 14.sp,
    );
  }

  static String getMsgFromException(dynamic error) {
    final message = error.toString().replaceFirst('Exception: ', '');
    return message;
  }

  static void showErrorMessage(dynamic error) {
    final message = getMsgFromException(error.toString());
    showToast(message);
  }
}
