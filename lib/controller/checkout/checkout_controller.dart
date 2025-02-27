import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cart/cart_info_model.dart';
import 'package:kanna_curry_house/model/cart/review_cart_request_model.dart';
import 'package:kanna_curry_house/model/checkout/checkout_request_model.dart';
import 'package:kanna_curry_house/model/coupon/coupon_model.dart';
import 'package:kanna_curry_house/view/screens/checkout/order_confirmed_screen.dart';
import 'package:kanna_curry_house/view/screens/coupon/coupon_screen.dart';

class CheckoutController extends GetxController {
  final String cartId;
  CheckoutController({required this.cartId});

  @override
  void onInit() {
    reviewCart();
    super.onInit();
  }

  var selectedCoupon = Rxn<CouponModel>();
  var isLoading = false.obs;
  var cartInfo = Rxn<CartInfoModel>();
  var error = Rxn<String>();

  Future<void> reviewCart() async {
    try {
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
    reviewCart();
  }

  Future<void> submit() async {
    try {
      if (cartInfo.value == null) {
        return;
      }
      UiHelper.showLoadingDialog();

      final user = StorageHelper.getUserDetail();

      final input = CheckoutRequestModel(
          userId: user.id,
          cartId: cartId,
          addressId: cartInfo.value?.defaultAddress.id ?? '0',
          shippingMethod: '2',
          paymentMethod: 'COD',
          couponId: selectedCoupon.value?.id);

      final result = await ApiServices.checkoutCart(input);
      await StorageHelper.remove('current_cart_id');
      Get.find<CartInfoController>().myCart.value = null;
      UiHelper.showToast(result);
      UiHelper.closeLoadingDialog();
      Get.to(() => const OrderConfirmedScreen(),
          transition: Transition.downToUp);
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
