import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cancel/reason_list_request_model.dart';
import 'package:kanna_curry_house/model/cancel/reason_model.dart';

class ReasonListController extends GetxController {
  ReasonListController({required this.cancelOrder});

  final bool cancelOrder;

  @override
  void onInit() {
    fetchCancelReasons(initialize: true);
    scrollController.addListener(loadMore);
    super.onInit();
  }

  RxBool isLoading = false.obs;

  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  var reasons = <ReasonModel>[].obs;

  Future<void> fetchCancelReasons({required bool initialize}) async {
    try {
      if (initialize) {
        isLoading.value = true;
      } else {
        paginationLoading.value = true;
      }
      error.value = null;
      pageNo = reasons.length;
      final user = StorageHelper.getUserDetail();
      final input = ReasonListRequestModel(
          userId: user.id, type: cancelOrder ? '1' : '2', pageNo: 0);
      final result = await ApiServices.getCancelReasonList(input);
      reasons.addAll(result);
    } catch (e) {
      if (reasons.isEmpty) {
        error.value = UiHelper.getMsgFromException(e);
      }
    } finally {
      isLoading.value = false;
      paginationLoading.value = false;
    }
  }

  Future<void> loadMore() async {}
}
