import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/auth/login_controller.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/auth/resend_otp_request_model.dart';
import 'package:kanna_curry_house/model/auth/verification_request_model.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';
import 'package:kanna_curry_house/view/screens/profile/update_profile_screen.dart';

class VerificationController extends GetxController {
  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();
  late Timer timer;
  var remainingSeconds = 30.obs;

  void startTimer() async {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (remainingSeconds.value == 0) {
        timer.cancel();
      } else {
        remainingSeconds.value--;
      }
    });
  }

  void resetTimer() {
    remainingSeconds.value = 30;
    startTimer();
  }

  void cancelTimer() async {
    timer.cancel();
  }

  Future<void> resendOTP() async {
    try {
      UiHelper.unfocus();

      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();

      final input = ResendOtpRequestModel(
        userId: user.id,
        mobileNo: Get.find<LoginController>().mobileController.text.trim(),
      );

      final result = await ApiServices.resendVerificationCode(input);

      if (result != null) {
        UiHelper.showToast(result);
        resetTimer();
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> submit() async {
    try {
      UiHelper.unfocus();
      if (formKey.currentState?.validate() == true) {
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();

        final device = await DeviceHelper.getDeviceInfo();

        final fcmToken = await DeviceHelper.getFCM();

        final input = VerificationRequestModel(
            userId: user.id,
            otp: otpController.text.trim(),
            mobile: Get.find<LoginController>().mobileController.text.trim(),
            deviceId: device.id,
            deviceType: device.type,
            fcmToken: fcmToken);

        final result = await ApiServices.verifyMobileNumber(input);

        await StorageHelper.write('user', result);
        UiHelper.closeLoadingDialog();
        if (result['step']?.toString() == '3') {
          await StorageHelper.write('logged', true);
          Get.find<DashboardController>().changeTab(0);
          Get.offAll(() => const DashboardScreen());
        } else {
          Get.off(() => const UpdateProfileScreen());
        }
      }
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
