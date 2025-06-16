import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/controller/home/home_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/cart/add_to_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/delete_from_cart_request_model.dart';
import 'package:kanna_curry_house/model/cart/update_cart_request_model.dart';
import 'package:kanna_curry_house/model/category/category_model.dart';
import 'package:kanna_curry_house/model/category/category_products_request_model.dart';
import 'package:kanna_curry_house/model/category/view_categories_request_model.dart';
import 'package:kanna_curry_house/model/product/product_model.dart';

class CategoryProductsController extends GetxController {
  final CategoryModel initialSelectedCategory;
  CategoryProductsController({required this.initialSelectedCategory});

  @override
  void onInit() {
    selectedCategory.value = initialSelectedCategory;
    Future.wait([
      fetchCategories(initialize: true),
      fetchProductsbyCategory(initialize: true)
    ]);
    categoriesScrollController.addListener(loadMoreCategories);
    productsScrollController.addListener(loadMoreProductsByCategory);
    super.onInit();
  }

  //CATEGORIES
  var selectedCategory = Rxn<CategoryModel>();
  RxBool categoriesLoading = false.obs;
  var categories = <CategoryModel>[].obs;
  var categoriesError = Rxn<String>();
  final categoriesScrollController = ScrollController();
  var categoryiesPaginationLoading = false.obs;
  int? categoriesPageNo;

  //PRODUCTS
  RxBool productsLoading = false.obs;
  var products = <ProductModel>[].obs;
  var productsError = Rxn<String>();
  final productsScrollController = ScrollController();
  var productsPaginationLoading = false.obs;
  int? productsPageNo;

  Future<void> fetchCategories({required bool initialize}) async {
    try {
      if (initialize) {
        categoriesPageNo = 0;
        categories.clear();

        categoriesLoading.value = true;
      } else {
        categoryiesPaginationLoading.value = true;
      }
      categoriesError.value = null;
      categoriesPageNo = categories.length;
      final user = StorageHelper.getUserDetail();

      final input = ViewCategoriesRequestModel(
          userId: user.id, pageNo: categoriesPageNo ?? 0);

      final result = await ApiServices.getCategories(input);
      categories.addAll(result);
    } catch (e) {
      if (categories.isEmpty) {
        categoriesError.value = UiHelper.getMsgFromException(e);
      }
    } finally {
      categoriesLoading.value = false;
      categoryiesPaginationLoading.value = false;
    }
  }

  Future<void> loadMoreCategories() async {
    if (categoriesScrollController.position.maxScrollExtent ==
        categoriesScrollController.offset) {
      if (categoriesPageNo != null &&
          !categoriesLoading.value &&
          !categoryiesPaginationLoading.value) {
        fetchCategories(initialize: false);
      }
    }
  }

  Future<void> selectCategoryAndLoadProducts(CategoryModel category) async {
    selectedCategory.value = category;
    await fetchProductsbyCategory(initialize: true);
  }

  Future<void> fetchProductsbyCategory({required bool initialize}) async {
    try {
      if (initialize) {
        productsPageNo = 0;
        products.clear();
        productsLoading.value = true;
      } else {
        categoryiesPaginationLoading.value = true;
      }
      productsError.value = null;
      productsPageNo = products.length;
      final user = StorageHelper.getUserDetail();

      final input = CategoryProductsRequestModel(
        userId: user.id,
        categoryId: selectedCategory.value?.id ?? initialSelectedCategory.id,
        pageNo: productsPageNo ?? 0,
      );
      final result = await ApiServices.getCategoryProducts(input);
      products.addAll(result);
    } catch (e) {
      if (products.isEmpty) {
        productsError.value = UiHelper.getMsgFromException(e);
      }
    } finally {
      productsLoading.value = false;
      categoryiesPaginationLoading.value = false;
    }
  }

  Future<void> loadMoreProductsByCategory() async {
    if (productsScrollController.position.maxScrollExtent ==
        productsScrollController.offset) {
      if (productsPageNo != null &&
          !productsLoading.value &&
          !productsPaginationLoading.value) {
        fetchProductsbyCategory(initialize: false);
      }
    }
  }

  Future<void> addToCart(ProductModel product) async {
    try {
      if (!AuthHelper.isGuestUser()) {
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input = AddToCartRequestModel(
            userId: user.id, productId: product.id, quantity: 1);

        final result = await ApiServices.addProductToCart(input);

        if (result != null) {
          showQuantityAdjusters(result);
        }
        await Get.find<CartInfoController>().reloadCartData();
      } else {
        UiHelper.showToast('Please login to add product to your cart');
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> updateCart(ProductModel product,
      {required bool toIncrease}) async {
    try {
      if (!AuthHelper.isGuestUser()) {
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
      } else {
        UiHelper.showToast('Please login to add product to your cart');
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> deleteCart(ProductModel product) async {
    try {
      if (!AuthHelper.isGuestUser()) {
        UiHelper.showLoadingDialog();
        final user = StorageHelper.getUserDetail();
        final input = DeleteFromCartRequestModel(
            userId: user.id, cartItemId: product.cartItemId);

        await ApiServices.deleteProductFromCart(input);

        hideQuantityAdjusters(product);
        await Get.find<CartInfoController>().reloadCartData();
      } else {
        UiHelper.showToast('Please login to remove product from cart');
      }
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
    Get.find<HomeController>().showQuantityAdjusters(product);
  }

  void hideQuantityAdjusters(ProductModel product) async {
    final item = products.firstWhereOrNull((e) => e.id == product.id);

    if (item != null) {
      final itemIndex = products.indexOf(item);
      products[itemIndex].isInCart = false;
      products.refresh();
      Get.find<HomeController>().hideQuantityAdjusters(item);
    }
  }
}
