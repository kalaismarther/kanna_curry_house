import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/auth/login_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/address/address_model.dart';
import 'package:kanna_curry_house/model/profile/update_profile_request_model.dart';
import 'package:kanna_curry_house/view/screens/address/add_address_screen.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';

class UpdateProfileController extends GetxController {
  @override
  void onInit() {
    mobileController.text =
        Get.find<LoginController>().mobileController.text.trim();
    super.onInit();
  }

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  DateTime? dob;
  final dobController = TextEditingController();
  var address = Rxn<AddressModel>();
  final locationController = TextEditingController();
  RxBool isAgreed = false.obs;

  void selectDOB(BuildContext context) async {
    final date = await showDatePicker(
      initialDate: dob,
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppTheme.red,
          colorScheme: const ColorScheme.light(
            primary: AppTheme.red,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: Colors.white, // Background color
        ),
        child: child ?? const SizedBox(),
      ),
    );
    if (date != null) {
      dob = date;
      dobController.text = DateFormat("dd MMM, yyyy").format(date);
    }
  }

  Future<void> chooseLocation() async {
    final chosenAddress =
        await Get.to(() => const AddAddressScreen(fromUpdateProfile: true));

    if (chosenAddress != null && chosenAddress.runtimeType == AddressModel) {
      address.value = chosenAddress;
      locationController.text = address.value?.location ?? '';
    }
  }

  void toggleAgree(bool? v) => isAgreed.value = v ?? false;

  Future<void> submit() async {
    try {
      UiHelper.unfocus();
      if (formKey.currentState?.validate() == true) {
        if (!isAgreed.value) {
          UiHelper.showToast(
              'Please agree our terms and conditions to continue');
        } else {
          UiHelper.showLoadingDialog();
          final user = StorageHelper.getUserDetail();
          final input = UpdateProfileRequestModel(
              userId: user.id,
              name: nameController.text,
              email: emailController.text,
              dob: dob!,
              address: address.value!);
          await ApiServices.updateUserProfile(input);
          await StorageHelper.write('logged', true);
          UiHelper.closeLoadingDialog();
          Get.to(() => const DashboardScreen());
        }
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
