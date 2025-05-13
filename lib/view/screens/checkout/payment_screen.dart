import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/checkout/payment_controller.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key, required this.billId, required this.webLink});

  final String billId;
  final String webLink;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentController>(
      init: PaymentController(billId: billId, paymentWebPageUrl: webLink),
      builder: (controller) => Scaffold(
        appBar: PrimaryAppbar(title: 'Payment'),
        body: Obx(
          () => Stack(
            children: [
              if (controller.loadingPercentage.value < 100)
                LinearProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  value: controller.loadingPercentage.value / 100.0,
                )
              else
                WebViewWidget(controller: controller.webViewController),
            ],
          ),
        ),
      ), //16F3EFBF788FFEBF4C2F
    );
  }
}
