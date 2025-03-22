import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/category/view_categories_controller.dart';
import 'package:kanna_curry_house/view/screens/cart/cart_screen.dart';
import 'package:kanna_curry_house/view/screens/category/category_products_screen.dart';
import 'package:kanna_curry_house/view/widgets/cart_info.dart';
import 'package:kanna_curry_house/view/widgets/categories_loading_widget.dart';
import 'package:kanna_curry_house/view/widgets/category_item.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class ViewCategoriesScreen extends StatelessWidget {
  const ViewCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: const PrimaryAppbar(title: 'View Categories'),
        body: GetBuilder<ViewCategoriesController>(
          init: ViewCategoriesController(),
          builder: (controller) => SingleChildScrollView(
            controller: controller.scrollController,
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Categories',
                  style:
                      TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                ),
                const VerticalSpace(height: 20),
                Obx(
                  () {
                    if (controller.error.value != null) {
                      return Center(
                        child: Text(controller.error.value ?? ''),
                      );
                    }
                    if (controller.isLoading.value) {
                      return const CategoriesLoadingWidget(isListView: false);
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 20.sp,
                          crossAxisSpacing: 16.sp,
                          childAspectRatio: 2.2),
                      itemBuilder: (context, index) => CategoryItem(
                          onTap: () => Get.to(
                                () => CategoryProductsScreen(
                                    clickedCategory:
                                        controller.categories[index]),
                              ),
                          category: controller.categories[index]),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CartInfo(
          onCheckOut: () => Get.to(() => const CartScreen()),
        ),
      ),
    );
  }
}
