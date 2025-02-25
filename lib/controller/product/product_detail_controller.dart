import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/controller/category/category_products_controller.dart';
import 'package:kanna_curry_house/controller/home/home_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cart/add_to_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/delete_from_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/update_cart_request_model.dart';
import 'package:kanna_curry_house/model/product/product_detail_request_model.dart';
import 'package:kanna_curry_house/model/product/product_model.dart';

class ProductDetailController extends GetxController {
  final String productId;
  final bool fromHomeScreen;

  ProductDetailController(
      {required this.productId, required this.fromHomeScreen});
  @override
  void onInit() {
    fetchProductDetail();
    super.onInit();
  }

  var isLoading = false.obs;
  var product = Rxn<ProductModel>();
  var error = Rxn<String>();

  Future<void> fetchProductDetail() async {
    try {
      isLoading.value = true;
      final user = StorageHelper.getUserDetail();

      final input =
          ProductDetailRequestModel(userId: user.id, productId: productId);

      final result = await ApiServices.getProductDetail(input);

      product.value = result;
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart() async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = AddToCartRequestModel(
          userId: user.id, productId: product.value?.id ?? '0', quantity: 1);

      final result = await ApiServices.addProductToCart(input);

      if (result != null) {
        product.value = result;
        notifyOnOtherScreens();
      }
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> updateCart({required bool toIncrease}) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = UpdateCartRequestModel(
          userId: user.id,
          cartItemId: product.value?.cartItemId ?? '0',
          quantity: (product.value?.cartQuantity ?? 0) + (toIncrease ? 1 : -1));

      final result = await ApiServices.updateProductInCart(input);

      if (result != null) {
        product.value = result;
        notifyOnOtherScreens();
      }
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> deleteCart() async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = DeleteFromCartRequestModel(
          userId: user.id, cartItemId: product.value?.cartItemId ?? '0');

      await ApiServices.deleteProductFromCart(input);
      UiHelper.closeLoadingDialog();
      await fetchProductDetail();
      notifyOnOtherScreens(isDeleted: true);
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void notifyOnOtherScreens({bool isDeleted = false}) {
    if (product.value != null) {
      if (isDeleted) {
        if (fromHomeScreen) {
          Get.find<HomeController>().hideQuantityAdjusters(product.value!);
        } else {
          Get.find<CategoryProductsController>()
              .hideQuantityAdjusters(product.value!);
        }
      } else {
        if (fromHomeScreen) {
          Get.find<HomeController>().showQuantityAdjusters(product.value!);
        } else {
          Get.find<CategoryProductsController>()
              .showQuantityAdjusters(product.value!);
        }
      }
    }
  }
}
