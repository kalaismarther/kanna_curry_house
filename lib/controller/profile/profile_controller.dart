import 'package:get/get.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';

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
}
