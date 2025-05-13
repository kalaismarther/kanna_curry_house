import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/launcher_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/order/my_order_model.dart';
import 'package:kanna_curry_house/model/order/order_detail_request_model.dart';
import 'package:kanna_curry_house/model/order/order_rating_request_model.dart';
import 'package:kanna_curry_house/model/order/ordered_item_model.dart';
import 'package:kanna_curry_house/view/widgets/rating_dialog.dart';

class OrderDetailController extends GetxController {
  final String orderId;
  OrderDetailController({required this.orderId});

  @override
  void onInit() {
    myOrder.value = null;
    fetchOrderDetail();
    super.onInit();
  }

  var isLoading = false.obs;
  var myOrder = Rxn<MyOrderModel>();
  var invoiceUrl = ''.obs;
  var orderedItems = <OrderedItemModel>[].obs;
  var error = Rxn<String>();

  var foodRatingStar = 0.obs;
  var packageRatingStar = 0.obs;
  final feedbackController = TextEditingController();

  Future<void> fetchOrderDetail() async {
    try {
      isLoading.value = true;
      final user = StorageHelper.getUserDetail();
      final input = OrderDetailRequestModel(userId: user.id, orderId: orderId);

      final result = await ApiServices.getOrderDetail(input);
      invoiceUrl.value = result['invoice']?.toString() ?? '';
      orderedItems.value = [
        for (final item in result['data'] ?? []) OrderedItemModel.fromJson(item)
      ];
      if (result['order'] != null) {
        myOrder.value = MyOrderModel.fromJson(result['order']);
      }
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rateOrder() async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = OrderRatingRequestModel(
          userId: user.id,
          orderId: orderId,
          foodRating: foodRatingStar.value,
          packageRating: packageRatingStar.value,
          feedback: feedbackController.text);
      final result = await ApiServices.giveRatingToOrder(input);
      myOrder.value?.isRatingSubmitted = true;
      myOrder.refresh();
      UiHelper.showToast(result);
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void showRatingDialog() => Get.dialog(
        RatingDialog(
          onSubmit: () {
            if (foodRatingStar.value < 1) {
              UiHelper.showToast('Please give rating for food');
            } else if (packageRatingStar.value < 1) {
              UiHelper.showToast('Please give rating for packaging');
            } else if (feedbackController.text.trim().isEmpty) {
              UiHelper.showToast('Please enter feedback');
            } else {
              UiHelper.unfocus();
              Get.back();
              rateOrder();
            }
          },
        ),
      );

  void showCancelOrderAlert() => Get.dialog(
        AlertDialog(
          title: Text(
            'Are you sure to cancel this order?',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                // cancelOrder();
              },
              child: const Text('Yes'),
            )
          ],
        ),
      );

  Future<void> downloadInvoice() async {
    try {
      LauncherHelper.openLink(invoiceUrl.value);
    } catch (e) {
      //
    }
  }
}
