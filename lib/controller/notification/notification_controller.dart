import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/notification/notification_model.dart';
import 'package:kanna_curry_house/model/notification/notification_request_model.dart';

class NotificationController extends GetxController {
  @override
  void onInit() {
    isLoading.value = true;
    scrollController.addListener(loadMore);
    getMyNotifications();
    super.onInit();
  }

  var isLoading = false.obs;
  var notificationList = <NotificationModel>[].obs;
  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> getMyNotifications() async {
    try {
      error.value = null;
      pageNo = notificationList.length;

      final user = StorageHelper.getUserDetail();

      final input = NotificationRequestModel(
        userId: user.id,
        pageNo: pageNo ?? 0,
      );

      final result = await ApiServices.getNotificationList(input);
      notificationList.addAll(result);
    } catch (e) {
      if (notificationList.isEmpty) {
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
        paginationLoading.value = true;
        getMyNotifications();
      }
    }
  }
}
