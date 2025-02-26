import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/order/my_order_list_request_model.dart';
import 'package:kanna_curry_house/model/order/my_order_model.dart';

class MyOrderListController extends GetxController {
  @override
  void onInit() {
    fetchMyOrders(initialize: true);
    scrollController.addListener(loadMore);
    super.onInit();
  }

  RxBool isLoading = false.obs;
  var orders = <MyOrderModel>[].obs;
  var error = Rxn<String>();
  final scrollController = ScrollController();
  int? pageNo;
  var paginationLoading = false.obs;

  Future<void> fetchMyOrders({required bool initialize}) async {
    try {
      if (initialize) {
        pageNo = 0;
        orders.clear();
        isLoading.value = true;
      } else {
        paginationLoading.value = true;
      }
      error.value = null;
      pageNo = orders.length;

      final user = StorageHelper.getUserDetail();

      final input =
          MyOrderListRequestModel(userId: user.id, pageNo: pageNo ?? 0);

      final result = await ApiServices.getMyOrders(input);
      orders.addAll(result);
    } catch (e) {
      if (orders.isEmpty) {
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
        fetchMyOrders(initialize: false);
      }
    }
  }

  void notifyOrderStatus(MyOrderModel order) {
    final item = orders.firstWhereOrNull((e) => e.id == order.id);

    if (item != null) {
      final itemIndex = orders.indexOf(item);
      orders[itemIndex].status = order.status;
      orders.refresh();
    }
  }
}
