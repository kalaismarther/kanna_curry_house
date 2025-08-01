import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/category/category_model.dart';
import 'package:kanna_curry_house/model/category/view_categories_request_model.dart';

class ViewCategoriesController extends GetxController {
  @override
  void onInit() {
    fetchCategories(initialize: true);
    scrollController.addListener(loadMore);
    super.onInit();
  }

  RxBool isLoading = false.obs;
  var categories = <CategoryModel>[].obs;

  var error = Rxn<String>();

  var paginationLoading = false.obs;
  int? pageNo;

  final scrollController = ScrollController();

  Future<void> fetchCategories({required bool initialize}) async {
    try {
      if (initialize) {
        pageNo = 0;
        isLoading.value = true;
      } else {
        paginationLoading.value = true;
      }
      error.value = null;
      pageNo = categories.length;
      final user = StorageHelper.getUserDetail();

      final input =
          ViewCategoriesRequestModel(userId: user.id, pageNo: pageNo ?? 0);

      final result = await ApiServices.getCategories(input);
      categories.addAll(result);
    } catch (e) {
      if (categories.isEmpty) {
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
        fetchCategories(initialize: false);
      }
    }
  }
}
