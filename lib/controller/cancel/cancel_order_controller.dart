import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/order/order_detail_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cancel/reason_model.dart';
import 'package:kanna_curry_house/model/cancel/cancel_order_request_model.dart';
import 'package:kanna_curry_house/view/screens/cancel/reason_list_screen.dart';

class CancelOrderController extends GetxController {
  var selectedReason = Rxn<ReasonModel>();

  final manualReasonController = TextEditingController();

  void chooseReason() async {
    final reason = await Get.to(() => ReasonListScreen(fromOrderScreen: true));

    if (reason != null && reason.runtimeType == ReasonModel) {
      selectedReason.value = reason;
    }
  }

  Future<void> cancelOrder() async {
    try {
      UiHelper.unfocus();
      if (selectedReason.value == null) {
        UiHelper.showToast('Please select reason');
        return;
      }
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = CancelOrderRequestModel(
          userId: user.id,
          orderId: Get.find<OrderDetailController>().orderId,
          reasonId: selectedReason.value?.id ?? '',
          remarks: manualReasonController.text.trim());

      final result = await ApiServices.cancelMyOrder(input);
      UiHelper.closeLoadingDialog();
      Get.back();
      UiHelper.showToast(result['message'].toString());
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
