import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cart/cart_item_model.dart';
import 'package:kanna_curry_house/model/cart/delete_from_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/update_cart_request_model.dart';

class CartController extends GetxController {
  @override
  void onInit() {
    fetchCartItems();
    super.onInit();
  }

  var isLoading = false.obs;
  var cartItems = <CartItemModel>[].obs;
  var error = Rxn<String>();

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      final result = await ApiServices.getCartData();
      cartItems.value = [
        for (final item in result['cartitems']) CartItemModel.fromJson(item)
      ];
    } catch (e) {
      error.value = UiHelper.getMsgFromException(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateItem(CartItemModel item,
      {required bool toIncrease}) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = UpdateCartRequestModel(
          userId: user.id,
          cartItemId: item.id,
          quantity: item.cartQuantity + (toIncrease ? 1 : -1));

      final result = await ApiServices.updateCartItem(input);

      if (result != null) {
        refreshList(result);
      }
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> deleteItem(CartItemModel item) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input =
          DeleteFromCartRequestModel(userId: user.id, cartItemId: item.id);

      await ApiServices.deleteProductFromCart(input);
      cartItems.remove(item);
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void refreshList(CartItemModel updatedItem) async {
    final item = cartItems.firstWhereOrNull((e) => e.id == updatedItem.id);

    if (item != null) {
      final itemIndex = cartItems.indexOf(item);
      cartItems[itemIndex] = updatedItem;
      cartItems.refresh();
    }
  }
}
