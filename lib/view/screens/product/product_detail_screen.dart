import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/product/product_detail_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/view/screens/cart/cart_screen.dart';
import 'package:kanna_curry_house/view/widgets/back_icon.dart';
import 'package:kanna_curry_house/view/widgets/cart_info.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen(
      {super.key, required this.productId, required this.fromScreen});

  final String productId;
  final String fromScreen;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductDetailController>(
      init: ProductDetailController(
          productId: productId, fromHomeScreen: fromScreen == 'home'),
      builder: (controller) => Scaffold(
        body: Obx(
          () {
            if (controller.isLoading.value ||
                controller.product.value == null) {
              return const PrimaryLoader();
            }
            final thisProduct = controller.product.value;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(20.r)),
                        child: OnlineImage(
                          link: thisProduct?.imageLink ?? '',
                          height: 350.sp,
                          width: double.infinity,
                          radius: 0,
                        ),
                      ),
                      Positioned(
                        top: DeviceHelper.statusbarHeight(context),
                        left: 24.sp,
                        child: const BackIcon(),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.sp, vertical: 20.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                thisProduct?.name ?? '',
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            HorizontalSpace(width: 12.sp),
                            if (thisProduct?.inStock == false)
                              Container(
                                padding: EdgeInsets.all(12.sp),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: AppTheme.grey),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Out of Stock',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            else if (thisProduct?.isInCart == true)
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if ((thisProduct?.cartQuantity ?? 0) >
                                            1) {
                                          controller.updateCart(
                                              toIncrease: false);
                                        } else {
                                          controller.deleteCart();
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.sp),
                                        margin: EdgeInsets.all(8.sp),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                      ),
                                    ),
                                    HorizontalSpace(width: 8.sp),
                                    Text(
                                      thisProduct?.cartQuantity.toString() ??
                                          '',
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    HorizontalSpace(width: 8.sp),
                                    GestureDetector(
                                      onTap: () {
                                        controller.updateCart(toIncrease: true);
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(4.sp),
                                        margin: EdgeInsets.all(8.sp),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              GestureDetector(
                                onTap: controller.addToCart,
                                child: Container(
                                  padding: EdgeInsets.all(4.sp),
                                  margin: EdgeInsets.all(8.sp),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              )
                          ],
                        ),
                        const VerticalSpace(height: 16),
                        Text(
                          'RM ${thisProduct?.sellingPrice ?? ''}',
                          style: TextStyle(
                              fontSize: 24.sp, fontWeight: FontWeight.w600),
                        ),
                        const VerticalSpace(height: 28),
                        Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                        const VerticalSpace(height: 16),
                        Text(
                          thisProduct?.description ?? '',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                              height: 1.8,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: CartInfo(
          onCheckOut: () =>
              Get.to(() => const CartScreen(fromScreen: 'product_detail')),
        ),
      ),
    );
  }
}
