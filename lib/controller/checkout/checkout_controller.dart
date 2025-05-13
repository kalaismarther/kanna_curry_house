import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cart/cart_info_model.dart';
import 'package:kanna_curry_house/model/cart/review_cart_request_model.dart';
import 'package:kanna_curry_house/model/checkout/checkout_request_model.dart';
import 'package:kanna_curry_house/model/checkout/create_payment_request_model.dart';
import 'package:kanna_curry_house/model/coupon/coupon_model.dart';
import 'package:kanna_curry_house/view/screens/checkout/order_confirmed_screen.dart';
import 'package:kanna_curry_house/view/screens/coupon/coupon_screen.dart';
import 'package:kanna_curry_house/view/screens/checkout/payment_screen.dart';

class CheckoutController extends GetxController {
  final String cartId;
  CheckoutController({required this.cartId});

  @override
  void onInit() {
    Future.wait([reviewCart(), fetchCancellationPolicy()]);
    super.onInit();
  }

  var selectedCoupon = Rxn<CouponModel>();
  var isLoading = false.obs;
  var cartInfo = Rxn<CartInfoModel>();
  var error = Rxn<String>();

  var cancellationPolicyContent = ''.obs;
  var paymentMethod = ''.obs;

  Future<void> reviewCart() async {
    try {
      cartInfo.value = null;
      isLoading.value = true;
      error.value = null;
      final user = StorageHelper.getUserDetail();

      final input = ReviewCartRequestModel(
          userId: user.id,
          cartId: cartId.toString(),
          appliedCouponId: selectedCoupon.value?.id);

      final result = await ApiServices.reviewCart(input);
      cartInfo.value = result;
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> chooseCoupon() async {
    final coupon = await Get.to(() => const CouponScreen());
    selectedCoupon.value = coupon;
    if (selectedCoupon.value != null) {
      reviewCart();
    }
  }

  Future<void> fetchCancellationPolicy() async {
    try {
      final result = await ApiServices.getCancellationPolicy();
      cancellationPolicyContent.value = result;
    } catch (e) {
      //
    }
  }

  Future<void> submit() async {
    try {
      if (cartInfo.value == null) {
        return;
      }
      if (paymentMethod.value.isEmpty) {
        UiHelper.showToast('Please select payment method');
        return;
      }
      UiHelper.showLoadingDialog();

      final user = StorageHelper.getUserDetail();

      final input = CheckoutRequestModel(
          userId: user.id,
          cartId: cartId,
          addressId: cartInfo.value?.defaultAddress.id ?? '0',
          shippingMethod: '2',
          paymentMethod: paymentMethod.value,
          couponId: selectedCoupon.value?.id);

      final result = await ApiServices.checkoutCart(input);

      if (result['status']?.toString() == '1') {
        await StorageHelper.remove('current_cart_id');
        Get.find<CartInfoController>().myCart.value = null;
        UiHelper.showToast(
            result['message']?.toString() ?? 'Order placed successfully');
        UiHelper.closeLoadingDialog();
        Get.to(() => const OrderConfirmedScreen(),
            transition: Transition.downToUp);
      } else if (result['status']?.toString() == '6') {
        UiHelper.closeLoadingDialog();
        proceedOnlinePayment(
          orderId: result['data']?['id']?.toString() ?? '',
          amount: result['data']?['grand_total']?.toString() ?? '',
        );
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> proceedOnlinePayment(
      {required String orderId, required String amount}) async {
    try {
      if (orderId.isEmpty || amount.isEmpty) {
        return;
      }
      showProcessingDialog();
      final user = StorageHelper.getUserDetail();
      final input = CreatePaymentRequestModel(
          userId: user.id, orderId: orderId, amount: amount);

      final result = await ApiServices.createBillPlzPayment(input);

      final billId = result['bill_id']?.toString() ?? '';
      final paymentUrl = result['payment_url']?.toString() ?? '';

      if (billId.isNotEmpty && paymentUrl.isNotEmpty) {
        UiHelper.closeLoadingDialog();
        Get.to(() => PaymentScreen(billId: billId, webLink: paymentUrl));
        // launchUrlString(paymentUrl);
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void showProcessingDialog() {
    Get.dialog(
        barrierDismissible: false,
        PopScope(
          canPop: false,
          child: AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(
                  color: Colors.teal.shade700,
                ),
                SizedBox(width: 16),
                Expanded(child: Text("Redirecting to payment")),
              ],
            ),
          ),
        ));
  }
}
