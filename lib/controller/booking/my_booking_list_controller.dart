import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/booking/my_booking_list_request_model.dart';
import 'package:kanna_curry_house/model/booking/my_booking_model.dart';

class MyBookingListController extends GetxController {
  @override
  void onInit() {
    fetchMyBookings(initialize: true);
    scrollController.addListener(loadMore);
    super.onInit();
  }

  RxBool isLoading = false.obs;
  var bookings = <MyBookingModel>[].obs;
  var error = Rxn<String>();
  final scrollController = ScrollController();
  int? pageNo;
  var paginationLoading = false.obs;

  Future<void> fetchMyBookings({required bool initialize}) async {
    try {
      if (initialize) {
        pageNo = 0;
        bookings.clear();
        isLoading.value = true;
      } else {
        paginationLoading.value = true;
      }
      error.value = null;
      pageNo = bookings.length;

      final user = StorageHelper.getUserDetail();

      final input =
          MyBookingListRequestModel(userId: user.id, pageNo: pageNo ?? 0);

      final result = await ApiServices.getMyBookings(input);
      bookings.addAll(result);
    } catch (e) {
      if (bookings.isEmpty) {
        error.value = UiHelper.getMsgFromException(e);
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    if (currentScroll >= (maxScroll * 0.8)) {
      if (pageNo != null && !isLoading.value && !paginationLoading.value) {
        fetchMyBookings(initialize: false);
      }
    }
  }

  void notifyBookingStatus(MyBookingModel order) {
    final item = bookings.firstWhereOrNull((e) => e.id == order.id);

    if (item != null) {
      final itemIndex = bookings.indexOf(item);
      bookings[itemIndex].status = order.status;
      bookings.refresh();
    }
  }
}
