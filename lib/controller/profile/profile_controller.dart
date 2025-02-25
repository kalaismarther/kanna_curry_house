import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/view/widgets/logout_dialog.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  var userDp = ''.obs;
  var email = ''.obs;

  @override
  void onInit() {
    final user = StorageHelper.getUserDetail();
    userName.value = user.name;
    userDp.value = user.profileImageUrl;
    email.value = user.email;
    super.onInit();
  }

  Future<void> logout() async {
    try {
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
