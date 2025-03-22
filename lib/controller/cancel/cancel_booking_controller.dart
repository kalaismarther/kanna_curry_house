import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/booking/booking_detail_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cancel/cancel_booking_request_model.dart';
import 'package:kanna_curry_house/model/cancel/reason_model.dart';
import 'package:kanna_curry_house/view/screens/cancel/reason_list_screen.dart';

class CancelBookingController extends GetxController {
  var selectedReason = Rxn<ReasonModel>();

  final manualReasonController = TextEditingController();

  void chooseReason() async {
    final reason = await Get.to(() => ReasonListScreen(fromOrderScreen: false));

    if (reason != null && reason.runtimeType == ReasonModel) {
      selectedReason.value = reason;
    }
  }

  Future<void> cancelBooking() async {
    try {
      UiHelper.unfocus();
      if (selectedReason.value == null) {
        UiHelper.showToast('Please select reason');
        return;
      }
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = CancelBookingRequestModel(
          userId: user.id,
          bookingId: Get.find<BookingDetailController>().bookingId,
          reasonId: selectedReason.value?.id ?? '',
          remarks: manualReasonController.text.trim());

      await ApiServices.cancelMyBooking(input);
      UiHelper.closeLoadingDialog();
      Get.back();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
