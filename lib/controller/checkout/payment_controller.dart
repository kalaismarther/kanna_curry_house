import 'package:get/get.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/view/screens/checkout/order_confirmed_screen.dart';
import 'package:kanna_curry_house/view/screens/checkout/payment_failed_screen.dart';
// import 'package:kanna_curry_house/core/services/api_services.dart';
// import 'package:kanna_curry_house/model/checkout/update_payment_request_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentController extends GetxController {
  final String billId;
  final String paymentWebPageUrl;
  PaymentController({required this.billId, required this.paymentWebPageUrl});

  var loadingPercentage = 0.obs;
  late final WebViewController webViewController;

  @override
  void onInit() {
    loadWebUrl();
    super.onInit();
  }

  Future<void> loadWebUrl() async {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            loadingPercentage.value = progress;
          },
          onPageStarted: (String url) async {
            final uri = Uri.parse(url);

            final paid = uri.queryParameters['billplz[paid]'];
            final transactionStatus =
                uri.queryParameters['billplz[transaction_status]'];

            if (paid?.toString().toLowerCase() == 'true' &&
                transactionStatus?.toString().toLowerCase() == 'completed') {
              await StorageHelper.remove('current_cart_id');
              Get.to(() => OrderConfirmedScreen());
            } else if (paid?.toString().toLowerCase() == 'false' &&
                transactionStatus?.toString().toLowerCase() == 'failed') {
              Get.off(() => PaymentFailedScreen());
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentWebPageUrl));
  }
}
