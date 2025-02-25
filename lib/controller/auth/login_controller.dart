import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/auth/login_request_model.dart';
import 'package:kanna_curry_house/view/screens/auth/verification_screen.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();

  Future<void> submit() async {
    try {
      UiHelper.unfocus();
      if (formKey.currentState?.validate() == true) {
        UiHelper.showLoadingDialog();
        final input = LoginRequestModel(mobile: mobileController.text.trim());
        await ApiServices.userLogin(input);
        UiHelper.closeLoadingDialog();
        Get.to(() => const VerificationScreen());
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
