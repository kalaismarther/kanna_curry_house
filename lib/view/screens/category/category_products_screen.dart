import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/category/category_products_controller.dart';
import 'package:kanna_curry_house/model/category/category_model.dart';
import 'package:kanna_curry_house/view/screens/cart/cart_screen.dart';
import 'package:kanna_curry_house/view/screens/product/product_detail_screen.dart';
import 'package:kanna_curry_house/view/widgets/cart_info.dart';
import 'package:kanna_curry_house/view/widgets/categories_loading_widget.dart';
import 'package:kanna_curry_house/view/widgets/category_item.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/product_item.dart';
import 'package:kanna_curry_house/view/widgets/products_loading_widget.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({super.key, required this.clickedCategory});

  final CategoryModel clickedCategory;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryProductsController>(
      init:
          CategoryProductsController(initialSelectedCategory: clickedCategory),
      builder: (controller) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
          appBar: const PrimaryAppbar(title: 'View Category'),
          body: Padding(
            padding: EdgeInsets.all(16.sp),
            child: Obx(
              () => Column(
                children: [
                  if (controller.categoriesLoading.value)
                    const CategoriesLoadingWidget(isListView: true)
                  else
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: controller.categoriesScrollController,
                      padding: EdgeInsets.symmetric(
                          vertical: 12.sp, horizontal: 4.sp),
                      child: Row(
                        children: [
                          for (final category in controller.categories)
                            CategoryItem(
                              onTap: () => controller
                                  .selectCategoryAndLoadProducts(category),
                              category: category,
                              inListView: true,
                              backgroundColor:
                                  controller.selectedCategory.value?.id ==
                                          category.id
                                      ? AppTheme.red
                                      : Colors.white,
                            ),
                          if (controller.categoryiesPaginationLoading.value)
                            LoadingShimmer(
                                height: 60.sp, width: 160.sp, radius: 12.sp),
                        ],
                      ),
                    ),
                  const VerticalSpace(height: 20),
                  if (controller.productsError.value != null)
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(controller.productsError.value ?? ''),
                      ),
                    )
                  else if (controller.productsLoading.value)
                    const ProductsLoadingWidget()
                  else
                    GridView.builder(
                      padding: const EdgeInsets.all(0),
                      shrinkWrap: true,
                      controller: controller.productsScrollController,
                      itemCount: controller.products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24.sp,
                          crossAxisSpacing: 16.sp,
                          childAspectRatio: 0.96),
                      itemBuilder: (context, index) => ProductItem(
                        onTap: () => Get.to(
                          () => ProductDetailScreen(
                              productId: controller.products[index].id,
                              fromScreen: 'category_products'),
                        ),
                        onAdd: () {
                          controller.addToCart(controller.products[index]);
                        },
                        onIncrement: () {
                          controller.updateCart(controller.products[index],
                              toIncrease: true);
                        },
                        onDecrement: () {
                          if (controller.products[index].cartQuantity < 2) {
                            controller.deleteCart(controller.products[index]);
                          } else {
                            controller.updateCart(controller.products[index],
                                toIncrease: false);
                          }
                        },
                        product: controller.products[index],
                      ),
                    ),
                  if (controller.productsPaginationLoading.value)
                    const Center(
                      child: CupertinoActivityIndicator(),
                    )
                ],
              ),
            ),
          ),
          bottomNavigationBar: CartInfo(
            onCheckOut: () =>
                Get.to(() => const CartScreen(fromScreen: 'products')),
          ),
        ),
      ),
    );
  }
}
