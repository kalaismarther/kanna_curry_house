import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/date_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanna_curry_house/model/profile/edit_profile_request_model.dart';

class EditProfileController extends GetxController {
  var userDp = ''.obs;
  var userName = ''.obs;
  var selectedImagePath = ''.obs;
  var countryCode = ''.obs;
  final name = TextEditingController();
  final mobileNumber = TextEditingController();
  final email = TextEditingController();
  DateTime? dob;
  final dobController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    final user = StorageHelper.getUserDetail();
    userDp.value = user.profileImageUrl;
    userName.value = user.name;
    name.text = user.name;
    mobileNumber.text = user.mobile;
    countryCode.value = user.country.code;
    email.text = user.email;
    dob = DateHelper.parseDate(user.dob);
    dobController.text = DateHelper.formatDate(user.dob);
    super.onInit();
  }

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
          dialogTheme: DialogThemeData(
              backgroundColor: Colors.white), // Background color
        ),
        child: child ?? const SizedBox(),
      ),
    );
    if (date != null) {
      dob = date;
      dobController.text = DateFormat("dd MMM, yyyy").format(date);
    }
  }

  void showImagePickerDialog() {
    UiHelper.unfocus();
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt,
                color: AppTheme.red,
              ),
              title: const Text("Camera"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library,
                color: AppTheme.red,
              ),
              title: const Text("Gallery"),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image =
          await ImagePicker().pickImage(source: source, imageQuality: 50);
      if (image != null) {
        selectedImagePath.value = image.path;
      }
    } catch (e) {
      //
    }
  }

  Future<void> submit() async {
    try {
      UiHelper.unfocus();
      if (formKey.currentState?.validate() == true) {
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input = EditProfileRequestModel(
            userId: user.id,
            name: name.text.trim(),
            mobile: mobileNumber.text.trim(),
            dob: dob != null ? DateFormat('yyyy-MM-dd').format(dob!) : '',
            email: email.text.trim(),
            profileImagePath: selectedImagePath.value);

        final result = await ApiServices.editProfile(input);

        StorageHelper.write('user', result);

        UiHelper.closeLoadingDialog();
        Get.back();
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
