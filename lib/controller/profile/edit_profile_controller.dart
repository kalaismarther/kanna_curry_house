import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kanna_curry_house/model/profile/edit_profile_request_model.dart';

class EditProfileController extends GetxController {
  var userDp = ''.obs;
  var userName = ''.obs;
  var selectedImagePath = ''.obs;
  final name = TextEditingController();
  final mobileNumber = TextEditingController();
  final email = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    final user = StorageHelper.getUserDetail();
    userDp.value = user.profileImageUrl;
    userName.value = user.name;
    name.text = user.name;
    mobileNumber.text = user.mobile;
    email.text = user.email;

    super.onInit();
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
