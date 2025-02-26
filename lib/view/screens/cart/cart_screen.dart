import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_controller.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/view/screens/checkout/checkout_screen.dart';
import 'package:kanna_curry_house/view/widgets/cart_info.dart';
import 'package:kanna_curry_house/view/widgets/cart_item.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, this.fromScreen});

  final String? fromScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppbar(title: 'Cart'),
      body: GetBuilder<CartController>(
        init: CartController(fromScreenName: fromScreen),
        builder: (controller) => SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 3,
                        separatorBuilder: (context, index) => Divider(
                          height: 24.sp,
                        ),
                        itemBuilder: (context, index) => LoadingShimmer(
                            height: 80.sp,
                            width: double.infinity,
                            radius: 16.sp),
                      );
                    }
                    if (controller.cartItems.isEmpty) {
                      return const Center(
                        child: Text('Cart is Empty'),
                      );
                    }
                    if (controller.error.value != null) {
                      return SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(controller.error.value ?? ''),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.cartItems.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 24.sp,
                      ),
                      itemBuilder: (context, index) {
                        final cartItem = controller.cartItems[index];
                        return CartItem(
                          product: cartItem,
                          onDecrement: () {
                            if (cartItem.cartQuantity < 2) {
                              controller.deleteItem(cartItem);
                            } else {
                              controller.updateItem(cartItem,
                                  toIncrease: false);
                            }
                          },
                          onIncrement: () {
                            controller.updateItem(cartItem, toIncrease: true);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CartInfo(onCheckOut: () async {
        final cartId = Get.find<CartInfoController>().myCart.value?.id;
        if (cartId != null) {
          await Get.to(() => CheckoutScreen(cartId: cartId));
        }
      }),
    );
  }
}
