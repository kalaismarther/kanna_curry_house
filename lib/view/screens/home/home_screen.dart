import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';
import 'package:kanna_curry_house/controller/home/home_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/view/screens/booking/table_booking_screen.dart';
import 'package:kanna_curry_house/view/screens/cart/cart_screen.dart';
import 'package:kanna_curry_house/view/screens/category/category_products_screen.dart';
import 'package:kanna_curry_house/view/screens/category/view_categories_screen.dart';
import 'package:kanna_curry_house/view/screens/notification/notification_screen.dart';
import 'package:kanna_curry_house/view/screens/product/product_detail_screen.dart';
import 'package:kanna_curry_house/view/widgets/cart_info.dart';
import 'package:kanna_curry_house/view/widgets/categories_loading_widget.dart';
import 'package:kanna_curry_house/view/widgets/category_item.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/product_item.dart';
import 'package:kanna_curry_house/view/widgets/products_loading_widget.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';
import 'package:marquee/marquee.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder: (controller) => Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: DeviceHelper.statusbarHeight(context) + 20.sp,
                left: 16.sp,
                right: 16.sp,
                bottom: 16.sp),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        try {
                          final dashboardController =
                              Get.find<DashboardController>();
                          dashboardController.openDrawer();
                        } catch (e) {
                          //
                        }
                      },
                      child: Container(
                        height: 40.sp,
                        width: 40.sp,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.sp),
                        ),
                        child: Image.asset(
                          AppImages.menuIcon,
                        ),
                      ),
                    ),
                    const HorizontalSpace(width: 10),
                    Expanded(
                      child: Obx(
                        () => Text(
                          'Hi, ${controller.userName.value} !',
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => Get.to(() => NotificationScreen()),
                      child: Container(
                        height: 40.sp,
                        width: 40.sp,
                        padding: EdgeInsets.all(10.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.sp),
                        ),
                        child: Image.asset(
                          AppImages.notificationIcon,
                        ),
                      ),
                    ),
                    const HorizontalSpace(width: 16),
                    InkWell(
                      onTap: () =>
                          Get.to(() => const CartScreen(fromScreen: 'home')),
                      child: Container(
                        height: 40.sp,
                        width: 40.sp,
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.sp),
                        ),
                        child: Obx(
                          () {
                            final cartInfo =
                                Get.find<CartInfoController>().myCart.value;
                            if (cartInfo != null && cartInfo.itemCount > 0) {
                              return Badge.count(
                                count: cartInfo.itemCount,
                                child: Image.asset(
                                  AppImages.cartIcon,
                                ),
                              );
                            } else {
                              return Image.asset(
                                AppImages.cartIcon,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const VerticalSpace(height: 16),
                Row(
                  children: [
                    Image.asset(
                      AppImages.homeLocationIcon,
                      height: 16.sp,
                      width: 16.sp,
                    ),
                    const HorizontalSpace(width: 8),
                    Expanded(
                      child: Obx(
                        () {
                          final defaultAddress =
                              controller.userCurrentAddress.value;
                          if (defaultAddress != null) {
                            return Text(
                              defaultAddress.location,
                              style: TextStyle(fontSize: 14.sp),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    )
                  ],
                ),
                const VerticalSpace(height: 4),
              ],
            ),
          ),
          Obx(() {
            if (controller.showAlert.value &&
                controller.alertMsg.value.trim().isNotEmpty) {
              return SizedBox(
                child: Container(
                  width: DeviceHelper.screenWidth(context),
                  height: 34.sp,
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  color: Colors.red.shade900,
                  margin: EdgeInsets.only(bottom: 8.sp),
                  child: Marquee(
                    text: controller.alertMsg.value,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                    scrollAxis: Axis.horizontal,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    blankSpace: 20.sp,
                    velocity: 100.0,
                    pauseAfterRound: const Duration(seconds: 1),
                    startPadding: 10.0,
                    accelerationDuration: const Duration(seconds: 1),
                    accelerationCurve: Curves.linear,
                    decelerationDuration: const Duration(seconds: 1),
                    decelerationCurve: Curves.ease,
                  ),
                ),
              );
            }
            return SizedBox(height: 0);
          }),
          Expanded(
            child: Obx(
              () {
                if (controller.error.value != null) {
                  return Center(
                    child: Text(controller.error.value ?? ''),
                  );
                }
                return Stack(
                  children: [
                    SingleChildScrollView(
                      padding: EdgeInsets.all(16.sp),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (controller.isLoading.value)
                            LoadingShimmer(
                                height: 200.sp,
                                width: double.infinity,
                                radius: 16.sp)
                          else
                            SizedBox(
                              height: 200.sp,
                              width: DeviceHelper.screenWidth(context),
                              child: PageView.builder(
                                controller: controller.pageController,
                                itemCount: controller.bannerImages.length,
                                onPageChanged: (index) =>
                                    controller.activeBannerIndex.value = index,
                                itemBuilder: (context, index) => OnlineImage(
                                    link: controller.bannerImages[index],
                                    height: double.infinity,
                                    width: DeviceHelper.screenWidth(context),
                                    radius: 16.sp),
                              ),
                            ),
                          VerticalSpace(height: 12.sp),
                          if (controller.isLoading.value)
                            VerticalSpace(height: 8.sp)
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                controller.bannerImages.length,
                                (index) => Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8.sp,
                                  height: 8.sp,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.green.shade800),
                                    color: controller.activeBannerIndex.value ==
                                            index
                                        ? Colors.green.shade800
                                        : Colors.blueGrey.withOpacity(0.6),
                                  ),
                                ),
                              ),
                            ),
                          VerticalSpace(height: 24.sp),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.only(
                                bottom: 12.sp, left: 8.sp, right: 8.sp),
                            child: Row(
                              children: [
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 8,
                                        spreadRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => Get.to(
                                          () => const ViewCategoriesScreen()),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 24.sp, horizontal: 20.sp),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              AppImages.order,
                                              height: 48.sp,
                                              width: 48.sp,
                                            ),
                                            const VerticalSpace(height: 12),
                                            Text(
                                              'Order Pickup',
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const HorizontalSpace(width: 12),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 8,
                                        spreadRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () => Get.to(
                                          () => const TableBookingScreen()),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 24.sp, horizontal: 20.sp),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              AppImages.table,
                                              height: 48.sp,
                                              width: 48.sp,
                                            ),
                                            const VerticalSpace(height: 12),
                                            Text(
                                              'Table Reservation',
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const HorizontalSpace(width: 12),
                                Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 8,
                                        spreadRadius: 4,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        UiHelper.showToast('Coming soon',
                                            bgColor: Colors.red);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 24.sp, horizontal: 32.sp),
                                        child: Column(
                                          children: [
                                            Image.asset(
                                              AppImages.delivery,
                                              height: 48.sp,
                                              width: 48.sp,
                                            ),
                                            const VerticalSpace(height: 12),
                                            Text(
                                              'Delivery',
                                              style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          VerticalSpace(height: 4.sp),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Category',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Get.to(() => const ViewCategoriesScreen()),
                                child: const Text(
                                  'See All',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          ),
                          if (controller.isLoading.value)
                            const CategoriesLoadingWidget(isListView: true)
                          else
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.sp, horizontal: 4.sp),
                              child: Row(
                                children: [
                                  for (final category in controller.categories)
                                    CategoryItem(
                                      onTap: () => Get.to(
                                        () => CategoryProductsScreen(
                                            clickedCategory: category),
                                      ),
                                      category: category,
                                      inListView: true,
                                    ),
                                ],
                              ),
                            ),
                          const VerticalSpace(height: 20),
                          Text(
                            'Popular Items',
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.w600),
                          ),
                          const VerticalSpace(height: 28),
                          if (controller.isLoading.value)
                            const ProductsLoadingWidget()
                          else
                            GridView.builder(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 24.sp,
                                      crossAxisSpacing: 16.sp,
                                      childAspectRatio: 0.96),
                              itemBuilder: (context, index) => ProductItem(
                                onTap: () => Get.to(() => ProductDetailScreen(
                                    productId: controller.products[index].id,
                                    fromScreen: 'home')),
                                onAdd: () {
                                  controller
                                      .addToCart(controller.products[index]);
                                },
                                onIncrement: () {
                                  controller.updateCart(
                                      controller.products[index],
                                      toIncrease: true);
                                },
                                onDecrement: () {
                                  if (controller.products[index].cartQuantity <
                                      2) {
                                    controller
                                        .deleteCart(controller.products[index]);
                                  } else {
                                    controller.updateCart(
                                        controller.products[index],
                                        toIncrease: false);
                                  }
                                },
                                product: controller.products[index],
                              ),
                            ),
                          const VerticalSpace(height: 80)
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: CartInfo(
                        onCheckOut: () =>
                            Get.to(() => const CartScreen(fromScreen: 'home')),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
