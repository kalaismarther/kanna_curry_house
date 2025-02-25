import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cart/cart_info_model.dart';
import 'package:kanna_curry_house/model/cart/review_cart_request_model.dart';

class CartInfoController extends GetxController {
  var isLoading = true.obs;
  var myCart = Rxn<CartInfoModel>();

  var error = Rxn<String>();

  Future<void> fetchCartData() async {
    try {
      myCart.value = null;
      error.value = null;
      isLoading.value = true;

      final result = await ApiServices.getCartData();
      String? currentCartId = result['carttotal']?['id']?.toString();
      if (currentCartId != null) {
        await StorageHelper.write('current_cart_id', currentCartId);
        await updateCartInfo(currentCartId);
      } else {
        await StorageHelper.remove('current_cart_id');
      }
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateCartInfo(String cartId) async {
    try {
      final user = StorageHelper.getUserDetail();

      final input =
          ReviewCartRequestModel(userId: user.id, cartId: cartId.toString());

      final result = await ApiServices.reviewCart(input);

      myCart.value = result;
    } catch (e) {
      //
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reloadCartData() async {
    try {
      final currentCartId = StorageHelper.read('current_cart_id');

      if (currentCartId != null) {
        isLoading.value = true;
        error.value = null;
        updateCartInfo(currentCartId);
      } else {
        fetchCartData();
      }
    } catch (e) {
      //
    }
  }
}
