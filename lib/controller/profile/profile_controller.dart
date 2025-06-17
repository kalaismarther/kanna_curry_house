import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var userName = ''.obs;
  var userDp = ''.obs;
  var email = ''.obs;
  var showDeleteBtn = false.obs;
  var isGuestUser = false.obs;

  @override
  void onInit() {
    final user = StorageHelper.getUserDetail();
    userName.value = user.name;
    userDp.value = user.profileImageUrl;
    email.value = user.email;
    isGuestUser.value = AuthHelper.isGuestUser();
    checkDeleteButtonStatus();
    super.onInit();
  }

  Future<void> deleteAccount() async {
    try {
      UiHelper.showLoadingDialog();
      final result = await ApiServices.deleteUserAccount();
      UiHelper.closeLoadingDialog();
      AuthHelper.logoutUser(message: result);
    } catch (e) {
      UiHelper.showErrorMessage(e.toString());
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> checkDeleteButtonStatus() async {
    try {
      isLoading.value = true;
      if (!AuthHelper.isGuestUser()) {
        showDeleteBtn.value = await ApiServices.getDeleteBtnStatus();
      } else {
        showDeleteBtn.value = false;
      }
    } catch (e) {
      //
    } finally {
      isLoading.value = false;
    }
  }
}
