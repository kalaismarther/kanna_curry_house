import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/utils/network_helper.dart';
import 'package:kanna_curry_house/view/widgets/no_internet_dialog.dart';

class InternetServices extends GetxService {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.onInit();
  }

  Future<void> checkStatus() async {
    final noInternet = await NetworkHelper.isNotConnected();
    if (noInternet) {
      showNoInternetAlert();
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> connection) {
    if (connection.contains(ConnectivityResult.none)) {
      showNoInternetAlert();
    } else {
      if (Get.isDialogOpen == true) {
        Get.back();
      }
    }
  }

  void showNoInternetAlert() =>
      Get.dialog(barrierDismissible: false, NoInternetDialog(onRetry: retry));

  void retry() {
    if (Get.isDialogOpen == true) {
      Get.back();
      checkStatus();
    }
  }
}
