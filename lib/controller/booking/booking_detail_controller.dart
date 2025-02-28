import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/booking/booking_detail_request_model.dart';
import 'package:kanna_curry_house/model/booking/my_booking_model.dart';

class BookingDetailController extends GetxController {
  final String bookingId;
  BookingDetailController({required this.bookingId});

  @override
  void onInit() {
    fetchBookingDetail();
    super.onInit();
  }

  var isLoading = false.obs;
  var myBooking = Rxn<MyBookingModel>();
  var error = Rxn<String>();

  Future<void> fetchBookingDetail() async {
    try {
      isLoading.value = true;
      myBooking.value = null;
      final user = StorageHelper.getUserDetail();
      final input =
          BookingDetailRequestModel(userId: user.id, bookingId: bookingId);

      final result = await ApiServices.getBookingDetail(input);

      myBooking.value = result;
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rateOrder() async {}

  void showCancelBookingAlert() => Get.dialog(
        AlertDialog(
          title: Text(
            'Are you sure to cancel this booking?',
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
                cancelBooking();
              },
              child: const Text('Yes'),
            )
          ],
        ),
      );

  Future<void> cancelBooking() async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input =
          BookingDetailRequestModel(userId: user.id, bookingId: bookingId);

      final result = await ApiServices.cancelMyBooking(input);

      UiHelper.showToast(result);
      fetchBookingDetail();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
