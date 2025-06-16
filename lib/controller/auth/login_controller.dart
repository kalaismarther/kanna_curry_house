import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/auth/country_model.dart';
import 'package:kanna_curry_house/model/auth/login_request_model.dart';
import 'package:kanna_curry_house/view/screens/auth/verification_screen.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';
import 'package:kanna_curry_house/view/widgets/countries_dialog.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();

  var selectedCountry = Rxn<CountryModel>();

  Future<void> submit() async {
    try {
      UiHelper.unfocus();

      if (formKey.currentState?.validate() == true) {
        UiHelper.showLoadingDialog();
        final input = LoginRequestModel(
            countryId: selectedCountry.value?.id ?? '',
            mobile: mobileController.text.trim());
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

  Future<void> continueAsGuest() async {
    try {
      UiHelper.unfocus();

      UiHelper.showLoadingDialog();
      await ApiServices.guestLogin();
      UiHelper.closeLoadingDialog();
      Get.to(() => DashboardScreen());
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void chooseCountry() => Get.dialog(
        CountriesDialog(
          onSelectCountry: (country) => selectedCountry.value = country,
        ),
      );
}
