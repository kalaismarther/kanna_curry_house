import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/checkout/checkout_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/coupon/check_coupon_request_model.dart';
import 'package:kanna_curry_house/model/coupon/coupon_model.dart';

class CouponController extends GetxController {
  @override
  void onInit() {
    fetchCoupons(initialize: true);
    scrollController.addListener(loadMore);
    super.onInit();
  }

  RxBool isLoading = false.obs;
  var coupons = <CouponModel>[].obs;
  var error = Rxn<String>();
  final scrollController = ScrollController();
  int? pageNo;
  var paginationLoading = false.obs;

  Future<void> fetchCoupons({required bool initialize}) async {
    try {
      if (initialize) {
        pageNo = 0;
        coupons.clear();
        isLoading.value = true;
      } else {
        paginationLoading.value = true;
      }
      error.value = null;
      pageNo = coupons.length;

      final result = await ApiServices.getCoupons();
      coupons.addAll(result);
    } catch (e) {
      if (coupons.isEmpty) {
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
        fetchCoupons(initialize: false);
      }
    }
  }

  Future<void> validateCoupon(CouponModel coupon) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = CheckCouponRequestModel(
          userId: user.id,
          couponCode: coupon.code,
          orderAmount:
              Get.find<CheckoutController>().cartInfo.value?.subTotal ?? '');

      await ApiServices.checkCoupon(input);
      UiHelper.closeLoadingDialog();
      Get.back(result: coupon);
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
