import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/order/my_order_model.dart';
import 'package:kanna_curry_house/model/order/order_detail_request_model.dart';
import 'package:kanna_curry_house/model/order/ordered_item_model.dart';

class OrderDetailController extends GetxController {
  final String orderId;
  OrderDetailController({required this.orderId});

  @override
  void onInit() {
    fetchOrderDetail();
    super.onInit();
  }

  var isLoading = false.obs;
  var myOrder = Rxn<MyOrderModel>();
  var orderedItems = <OrderedItemModel>[].obs;
  var error = Rxn<String>();

  Future<void> fetchOrderDetail() async {
    try {
      isLoading.value = true;
      final user = StorageHelper.getUserDetail();
      final input = OrderDetailRequestModel(userId: user.id, orderId: orderId);

      final result = await ApiServices.getOrderDetail(input);
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

  Future<void> rateOrder() async {}

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
                cancelOrder();
              },
              child: const Text('Yes'),
            )
          ],
        ),
      );

  Future<void> cancelOrder() async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = OrderDetailRequestModel(userId: user.id, orderId: orderId);

      final result = await ApiServices.cancelMyOrder(input);

      if (result['data'] != null) {
        myOrder.value = MyOrderModel.fromJson(result['data']);
        // if (myOrder.value != null) {
        //   Get.find<MyOrderListController>().notifyOrderStatus(myOrder.value!);
        // }
      }
      UiHelper.showToast(result['message'].toString());
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
