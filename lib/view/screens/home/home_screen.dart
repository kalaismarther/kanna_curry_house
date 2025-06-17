import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/controller/home/home_controller.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
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
  const HomeScreen({super.key, required this.onMenuIconPressed});

  final Function() onMenuIconPressed;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: HomeController(),
      builder:
          (controller) => Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: DeviceHelper.statusbarHeight(context) + 20.sp,
                  left: 16.sp,
                  right: 16.sp,
                  bottom: 16.sp,
                ),
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
                          onTap: onMenuIconPressed,
                          child: Container(
                            height: 40.sp,
                            width: 40.sp,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.sp),
                            ),
                            child: Image.asset(AppImages.menuIcon),
                          ),
                        ),
                        const HorizontalSpace(width: 10),
                        Expanded(
                          child: Obx(
                            () => Text(
                              'Hi, ${controller.userName.value} !',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (!AuthHelper.isGuestUser()) {
                              Get.off(() => NotificationScreen());
                            } else {
                              UiHelper.showToast(
                                'Please login to view your notifications',
                              );
                            }
                          },
                          child: Container(
                            height: 40.sp,
                            width: 40.sp,
                            padding: EdgeInsets.all(10.sp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.sp),
                            ),
                            child: Obx(() {
                              if (controller.notificationCount.value > 0 &&
                                  !controller.isGuestUser.value) {
                                return Badge.count(
                                  count: controller.notificationCount.value,
                                  child: Image.asset(
                                    AppImages.notificationIcon,
                                  ),
                                );
                              }

                              return Image.asset(AppImages.notificationIcon);
                            }),
                          ),
                        ),
                        const HorizontalSpace(width: 16),
                        InkWell(
                          onTap: () {
                            if (!AuthHelper.isGuestUser()) {
                              Get.to(
                                () => const CartScreen(fromScreen: 'home'),
                              );
                            } else {
                              UiHelper.showToast(
                                'Please login to view your cart',
                              );
                            }
                          },
                          child: Container(
                            height: 40.sp,
                            width: 40.sp,
                            padding: EdgeInsets.all(8.sp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.sp),
                            ),
                            child: Obx(() {
                              final cartInfo =
                                  Get.find<CartInfoController>().myCart.value;
                              if (cartInfo != null &&
                                  cartInfo.itemCount > 0 &&
                                  !controller.isGuestUser.value) {
                                return Badge.count(
                                  count: cartInfo.itemCount,
                                  child: Image.asset(AppImages.cartIcon),
                                );
                              } else {
                                return Image.asset(AppImages.cartIcon);
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                    const VerticalSpace(height: 16),
                    if (!controller.isGuestUser.value)
                      Row(
                        children: [
                          Image.asset(
                            AppImages.homeLocationIcon,
                            height: 16.sp,
                            width: 16.sp,
                          ),
                          const HorizontalSpace(width: 8),
                          Expanded(
                            child: Obx(() {
                              final defaultAddress =
                                  controller.userCurrentAddress.value;
                              if (defaultAddress != null) {
                                return Text(
                                  defaultAddress.location,
                                  style: TextStyle(fontSize: 14.sp),
                                );
                              }

                              return const SizedBox();
                            }),
                          ),
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
                          fontWeight: FontWeight.w500,
                        ),
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
                child: Obx(() {
                  if (controller.error.value != null) {
                    return Center(child: Text(controller.error.value ?? ''));
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
                                radius: 16.sp,
                              )
                            else
                              SizedBox(
                                height: 200.sp,
                                width: DeviceHelper.screenWidth(context),
                                child: PageView.builder(
                                  controller: controller.pageController,
                                  itemCount: controller.bannerImages.length,
                                  onPageChanged:
                                      (index) =>
                                          controller.activeBannerIndex.value =
                                              index,
                                  itemBuilder:
                                      (context, index) => OnlineImage(
                                        link: controller.bannerImages[index],
                                        height: double.infinity,
                                        width: DeviceHelper.screenWidth(
                                          context,
                                        ),
                                        radius: 16.sp,
                                      ),
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
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: 8.sp,
                                    height: 8.sp,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.green.shade800,
                                      ),
                                      color:
                                          controller.activeBannerIndex.value ==
                                                  index
                                              ? Colors.green.shade800
                                              : Colors.blueGrey.withValues(
                                                alpha: 0.6,
                                              ),
                                    ),
                                  ),
                                ),
                              ),
                            VerticalSpace(height: 24.sp),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.only(
                                bottom: 12.sp,
                                left: 8.sp,
                                right: 8.sp,
                              ),
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
                                        onTap:
                                            () => Get.to(
                                              () =>
                                                  const ViewCategoriesScreen(),
                                            ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 24.sp,
                                            horizontal: 20.sp,
                                          ),
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
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
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
                                          if (controller
                                              .isTableReservationEnable) {
                                            Get.to(
                                              () => const TableBookingScreen(),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child:
                                                      const TableReservationUnavailable(),
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 24.sp,
                                            horizontal: 20.sp,
                                          ),
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
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
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
                                          UiHelper.showToast(
                                            'Coming soon',
                                            bgColor: Colors.red,
                                          );
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 24.sp,
                                            horizontal: 32.sp,
                                          ),
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
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
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
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextButton(
                                  onPressed:
                                      () => Get.to(
                                        () => const ViewCategoriesScreen(),
                                      ),
                                  child: const Text(
                                    'See All',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                            if (controller.isLoading.value)
                              const CategoriesLoadingWidget(isListView: true)
                            else if (controller.categories.isEmpty)
                              Container(
                                padding: EdgeInsets.all(20.sp),
                                alignment: Alignment.center,
                                child: Text('No Categories Found'),
                              )
                            else
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  vertical: 12.sp,
                                  horizontal: 4.sp,
                                ),
                                child: Row(
                                  children: [
                                    for (final category
                                        in controller.categories)
                                      CategoryItem(
                                        onTap:
                                            () => Get.to(
                                              () => CategoryProductsScreen(
                                                clickedCategory: category,
                                              ),
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
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const VerticalSpace(height: 28),
                            if (controller.isLoading.value)
                              const ProductsLoadingWidget()
                            else if (controller.products.isEmpty)
                              Container(
                                padding: EdgeInsets.all(20.sp),
                                alignment: Alignment.center,
                                child: Text('No Popular Items Found'),
                              )
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
                                      childAspectRatio: 0.96,
                                    ),
                                itemBuilder:
                                    (context, index) => ProductItem(
                                      onTap:
                                          () => Get.to(
                                            () => ProductDetailScreen(
                                              productId:
                                                  controller.products[index].id,
                                              fromScreen: 'home',
                                            ),
                                          ),
                                      onAdd: () {
                                        controller.addToCart(
                                          controller.products[index],
                                        );
                                      },
                                      onIncrement: () {
                                        controller.updateCart(
                                          controller.products[index],
                                          toIncrease: true,
                                        );
                                      },
                                      onDecrement: () {
                                        if (controller
                                                .products[index]
                                                .cartQuantity <
                                            2) {
                                          controller.deleteCart(
                                            controller.products[index],
                                          );
                                        } else {
                                          controller.updateCart(
                                            controller.products[index],
                                            toIncrease: false,
                                          );
                                        }
                                      },
                                      product: controller.products[index],
                                    ),
                              ),
                            const VerticalSpace(height: 80),
                          ],
                        ),
                      ),
                      if (!controller.isGuestUser.value)
                        Positioned(
                          bottom: 0,
                          child: CartInfo(
                            onCheckOut:
                                () => Get.to(
                                  () => const CartScreen(fromScreen: 'home'),
                                ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
            ],
          ),
    );
  }
}

class TableReservationUnavailable extends StatelessWidget {
  const TableReservationUnavailable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 25.0,
            spreadRadius: 0.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Modern gradient header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFFF6B6B).withValues(alpha: 0.9),
                  const Color(0xFFF06292).withValues(alpha: 0.85),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: Colors.white,
                      size: 22.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Dining Update',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(50.r),
                  child: Container(
                    padding: EdgeInsets.all(5.r),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 18.sp),
                  ),
                ),
              ],
            ),
          ),

          // Content with improved styling
          Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: const Color(0xFFFFB300),
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Table Reservation is temporarily unavailable',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF303030),
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'We apologize for the inconvenience, you will be notified when the table reservation is available',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xFF757575),
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // SizedBox(height: 24.h),
                // Container(
                //   padding:
                //       EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFF5F9FF),
                //     borderRadius: BorderRadius.circular(12.r),
                //     border: Border.all(color: const Color(0xFFE0EAFF)),
                //   ),
                //   child: Row(
                //     children: [
                //       Container(
                //         padding: EdgeInsets.all(8.r),
                //         decoration: BoxDecoration(
                //           color: const Color(0xFFE0EAFF),
                //           borderRadius: BorderRadius.circular(8.r),
                //         ),
                //         child: Icon(
                //           Icons.access_time_filled,
                //           color: const Color(0xFF4285F4),
                //           size: 18.sp,
                //         ),
                //       ),
                //       SizedBox(width: 12.w),
                //       Expanded(
                //         child: Text(
                //           'Expected to be back online by tomorrow at 10:00 AM',
                //           style: TextStyle(
                //             fontSize: 13.sp,
                //             color: const Color(0xFF546E7A),
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),

          // Modern footer with gradient button
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
          //   decoration: BoxDecoration(
          //     color: const Color(0xFFFAFAFA),
          //     borderRadius: BorderRadius.only(
          //       bottomLeft: Radius.circular(20.r),
          //       bottomRight: Radius.circular(20.r),
          //     ),
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: const LinearGradient(
          //         colors: [Color(0xFF4285F4), Color(0xFF34A853)],
          //         begin: Alignment.centerLeft,
          //         end: Alignment.centerRight,
          //       ),
          //       borderRadius: BorderRadius.circular(10.r),
          //       boxShadow: [
          //         BoxShadow(
          //           color: const Color(0xFF4285F4).withValues(alpha :0.3),
          //           blurRadius: 8,
          //           offset: const Offset(0, 4),
          //         ),
          //       ],
          //     ),
          //     child: ElevatedButton(
          //       onPressed: () => Navigator.of(context).pop(),
          //       style: ElevatedButton.styleFrom(
          //         foregroundColor: Colors.white,
          //         backgroundColor: Colors.transparent,
          //         shadowColor: Colors.transparent,
          //         padding:
          //             EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10.r),
          //         ),
          //       ),
          //       child: Row(
          //         children: [
          //           Text(
          //             'Contact Reception',
          //             style: TextStyle(
          //               fontSize: 14.sp,
          //               fontWeight: FontWeight.w500,
          //             ),
          //           ),
          //           SizedBox(width: 8.w),
          //           Icon(
          //             Icons.arrow_forward,
          //             size: 16.sp,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
