import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/controller/category/category_products_controller.dart';
import 'package:kanna_curry_house/controller/home/home_controller.dart';
import 'package:kanna_curry_house/controller/product/product_detail_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cart/delete_from_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/update_cart_request_model.dart';
import 'package:kanna_curry_house/model/product/product_model.dart';

class CartController extends GetxController {
  final String? fromScreenName;

  CartController({required this.fromScreenName});

  @override
  void onInit() {
    fetchCartItems();
    super.onInit();
  }

  var isLoading = false.obs;
  var cartItems = <ProductModel>[].obs;
  var error = Rxn<String>();

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      final result = await ApiServices.getCartData();
      cartItems.value = [
        for (final item in result['cartitems'])
          if (item['product'] != null) ProductModel.fromJson(item['product'])
      ];
    } catch (e) {
      error.value = UiHelper.getMsgFromException(error);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateItem(ProductModel product,
      {required bool toIncrease}) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = UpdateCartRequestModel(
          userId: user.id,
          cartItemId: product.cartItemId,
          quantity: product.cartQuantity + (toIncrease ? 1 : -1));

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

  Future<void> deleteItem(ProductModel product) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = DeleteFromCartRequestModel(
          userId: user.id, cartItemId: product.cartItemId);

      await ApiServices.deleteProductFromCart(input);
      cartItems.remove(product);
      notifyOnOtherScreens(product, isDeleted: true);
      if (cartItems.isEmpty) {
        UiHelper.closeLoadingDialog();
        Get.back();
        UiHelper.showToast('Cart items cleared');
      }
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void refreshList(ProductModel updatedProduct) async {
    final item = cartItems.firstWhereOrNull((e) => e.id == updatedProduct.id);

    if (item != null) {
      final itemIndex = cartItems.indexOf(item);
      cartItems[itemIndex] = updatedProduct;
      cartItems.refresh();
    }
    notifyOnOtherScreens(updatedProduct);
  }

  void notifyOnOtherScreens(ProductModel product, {bool isDeleted = false}) {
    if (isDeleted) {
      if (fromScreenName == 'home') {
        Get.find<HomeController>().hideQuantityAdjusters(product);
      } else if (fromScreenName == 'products') {
        Get.find<CategoryProductsController>().hideQuantityAdjusters(product);
      } else if (fromScreenName == 'product_detail') {
        final productDetailController = Get.find<ProductDetailController>();
        if (productDetailController.product.value?.id == product.id) {
          productDetailController.product.value?.isInCart = false;
          productDetailController.product.refresh();
          productDetailController.notifyOnOtherScreens(isDeleted: true);
        }
      }
    } else {
      if (fromScreenName == 'home') {
        Get.find<HomeController>().showQuantityAdjusters(product);
      } else if (fromScreenName == 'products') {
        Get.find<CategoryProductsController>().showQuantityAdjusters(product);
      } else if (fromScreenName == 'product_detail') {
        final productDetailController = Get.find<ProductDetailController>();
        if (productDetailController.product.value?.id == product.id) {
          productDetailController.product.value = product;
          productDetailController.notifyOnOtherScreens();
        }
      }
    }
  }
}
