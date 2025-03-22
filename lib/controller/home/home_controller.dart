import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/address/address_model.dart';
import 'package:kanna_curry_house/model/cart/add_to_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/delete_from_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/update_cart_request_model.dart';
import 'package:kanna_curry_house/model/category/category_model.dart';
import 'package:kanna_curry_house/model/product/product_model.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    final cartInfoController = Get.put(CartInfoController(), permanent: true);
    Future.wait([
      fetchUserDetail(),
      fetchHomeContent(),
      cartInfoController.fetchCartData()
    ]);
    super.onInit();
  }

  RxBool isLoading = false.obs;

  RxString userName = ''.obs;
  RxString userProfileImage = ''.obs;
  RxInt notificationCount = 0.obs;
  var alertMsg = ''.obs;
  var showAlert = false.obs;
  var userCurrentAddress = Rxn<AddressModel>();
  var bannerImages = <String>[].obs;
  var categories = <CategoryModel>[].obs;
  var products = <ProductModel>[].obs;
  RxInt activeBannerIndex = 0.obs;
  final PageController pageController = PageController();
  var error = Rxn<String>();

  Future<void> fetchUserDetail() async {
    try {
      final user = StorageHelper.getUserDetail();

      userName.value = user.name;
      userProfileImage.value = user.profileImageUrl;

      final storedAddress = StorageHelper.read('current_address');

      userCurrentAddress.value = AddressModel.tryParse(storedAddress);
    } catch (e) {
      //
    }
  }

  Future<void> fetchHomeContent() async {
    try {
      isLoading.value = true;
      error.value = null;
      final result = await ApiServices.getHomeContent();
      await StorageHelper.write('current_address', result['curret_default']);
      userCurrentAddress.value =
          AddressModel.tryParse(result['curret_default']);

      bannerImages.value = [
        for (final banner in result['data']?[0]?['menubanners'] ?? [])
          banner['is_image']?.toString() ?? ''
      ];

      categories.value = [
        for (final category in result['data']?[0]?['categories'] ?? [])
          CategoryModel.fromJson(category)
      ];

      products.value = [
        for (final product in result['data']?[0]?['topproducts'] ?? [])
          ProductModel.fromJson(product)
      ];

      showAlert.value = result['popup_flag']?.toString() == '1';
      alertMsg.value = result['popup_message']?.toString() ?? '';
    } catch (e) {
      error.value = UiHelper.getMsgFromException(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(ProductModel product) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = AddToCartRequestModel(
          userId: user.id, productId: product.id, quantity: 1);

      final result = await ApiServices.addProductToCart(input);

      if (result != null) {
        showQuantityAdjusters(result);
      }
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> updateCart(ProductModel product,
      {required bool toIncrease}) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = UpdateCartRequestModel(
          userId: user.id,
          cartItemId: product.cartItemId,
          quantity: product.cartQuantity + (toIncrease ? 1 : -1));

      final result = await ApiServices.updateProductInCart(input);

      if (result != null) {
        showQuantityAdjusters(result);
      }
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> deleteCart(ProductModel product) async {
    try {
      UiHelper.showLoadingDialog();
      final user = StorageHelper.getUserDetail();
      final input = DeleteFromCartRequestModel(
          userId: user.id, cartItemId: product.cartItemId);

      await ApiServices.deleteProductFromCart(input);
      hideQuantityAdjusters(product);
      await Get.find<CartInfoController>().reloadCartData();
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  void showQuantityAdjusters(ProductModel product) async {
    final item = products.firstWhereOrNull((e) => e.id == product.id);

    if (item != null) {
      final itemIndex = products.indexOf(item);
      products[itemIndex] = product;
      products.refresh();
    }
  }

  void hideQuantityAdjusters(ProductModel product) async {
    final item = products.firstWhereOrNull((e) => e.id == product.id);
    if (item != null) {
      final itemIndex = products.indexOf(item);
      products[itemIndex].isInCart = false;
      products.refresh();
    }
  }
}
