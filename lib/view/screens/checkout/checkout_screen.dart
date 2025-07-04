import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/cart/cart_controller.dart';
import 'package:kanna_curry_house/controller/checkout/checkout_controller.dart';
import 'package:kanna_curry_house/view/widgets/cart_item.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.cartId});

  final String cartId;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: const PrimaryAppbar(title: 'Checkout'),
        body: SingleChildScrollView(
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
                child: Obx(() {
                  if (cartController.isLoading.value) {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      separatorBuilder: (context, index) =>
                          Divider(height: 24.sp),
                      itemBuilder: (context, index) => LoadingShimmer(
                        height: 80.sp,
                        width: double.infinity,
                        radius: 16.sp,
                      ),
                    );
                  }
                  if (cartController.error.value != null) {
                    return SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(cartController.error.value ?? ''),
                      ),
                    );
                  }
                  if (cartController.cartItems.isEmpty) {
                    return const Center(child: Text('Cart is Empty'));
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartController.cartItems.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 24.sp),
                    itemBuilder: (context, index) {
                      final cartItem = cartController.cartItems[index];
                      return CartItem(
                        product: cartItem,
                        onDecrement: () async {
                          if (cartItem.cartQuantity < 2) {
                            await cartController.deleteItem(cartItem);

                            Get.find<CheckoutController>().reviewCart();
                          } else {
                            await cartController.updateItem(
                              cartItem,
                              toIncrease: false,
                            );
                            Get.find<CheckoutController>().reviewCart();
                          }
                        },
                        onIncrement: () async {
                          await cartController.updateItem(
                            cartItem,
                            toIncrease: true,
                          );
                          Get.find<CheckoutController>().reviewCart();
                        },
                      );
                    },
                  );
                }),
              ),
              GetBuilder<CheckoutController>(
                init: CheckoutController(cartId: cartId),
                builder: (controller) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpace(height: 20),
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (controller.isLoading.value)
                              Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: CupertinoActivityIndicator(),
                                ),
                              )
                            else ...[
                              if (controller
                                      .cartInfo.value?.onlinePaymentAvailable ==
                                  true)
                                RadioListTile(
                                  value: 'CC',
                                  groupValue: controller.paymentMethod.value,
                                  activeColor:
                                      Theme.of(context).colorScheme.secondary,
                                  onChanged: (value) => controller
                                      .paymentMethod.value = value ?? 'CC',
                                  title: Text(
                                    'Pay Online',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              if (controller.cartInfo.value?.codAvailable ==
                                  true)
                                RadioListTile(
                                  value: 'COD',
                                  groupValue: controller.paymentMethod.value,
                                  activeColor:
                                      Theme.of(context).colorScheme.secondary,
                                  onChanged: (value) => controller
                                      .paymentMethod.value = value ?? 'COD',
                                  title: Text(
                                    'Cash on Delivery',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                            ]
                          ],
                        )),
                    Obx(() {
                      if (controller
                              .cartInfo.value?.preparationTime.isNotEmpty ==
                          true) {
                        return Container(
                          padding: EdgeInsets.all(16.sp),
                          margin: EdgeInsets.only(bottom: 20.sp),
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
                          child: Row(
                            children: [
                              Text(
                                'Order Preparation Time : ',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${controller.cartInfo.value?.preparationTime} Mins',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppTheme.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    }),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.chooseCoupon,
                        child: Obx(
                          () => Container(
                            padding: EdgeInsets.all(16.sp),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (controller.selectedCoupon.value == null)
                                  Text(
                                    'Choose a coupon',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey,
                                    ),
                                  )
                                else
                                  Text(
                                    controller.selectedCoupon.value?.code ?? '',
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                if (controller.selectedCoupon.value != null)
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        controller.selectedCoupon.value = null;
                                        controller.reviewCart();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 4.sp,
                                          horizontal: 8.sp,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.red,
                                          borderRadius:
                                              BorderRadius.circular(4.sp),
                                        ),
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const VerticalSpace(height: 20),
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
                      child: Obx(() {
                        if (controller.error.value != null) {
                          return SizedBox(
                            height: 200.sp,
                            child: Center(
                              child: Text(controller.error.value ?? ''),
                            ),
                          );
                        }
                        final summary = controller.cartInfo.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pricing Summary',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            if (controller.isLoading.value || summary == null)
                              SizedBox(
                                height: 180.sp,
                                child: const PrimaryLoader(),
                              )
                            else if (controller.error.value != null)
                              SizedBox(
                                height: 180.sp,
                                child: Center(
                                  child: Text(controller.error.value ?? ''),
                                ),
                              )
                            else ...[
                              const VerticalSpace(height: 16),
                              _buildSummaryItem(
                                'Sub Total',
                                summary.subTotal,
                                Colors.black,
                              ),
                              _buildSummaryItem(
                                'Delivery Charges',
                                summary.deliveryCharge,
                                Colors.black,
                              ),
                              _buildSummaryItem(
                                'SST (tax is ${summary.taxPercentage}%)',
                                summary.taxAmount,
                                Colors.black,
                              ),
                              if (controller.selectedCoupon.value != null)
                                _buildSummaryItem(
                                  'Coupon Value',
                                  summary.couponAmount,
                                  Colors.red,
                                ),
                              const Divider(height: 20),
                              _buildSummaryItem(
                                'Total',
                                summary.total,
                                Colors.black,
                                isLabelBold: true,
                              ),
                              if ((double.tryParse(summary.deliveryCharge) ??
                                      0) >
                                  0)
                                Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(top: 12.sp),
                                  padding: EdgeInsets.all(12.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade100
                                        .withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.red.shade200),
                                  ),
                                  child: Text(
                                    summary.deliveryChargeMsg,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ],
                        );
                      }),
                    ),
                    Obx(() {
                      if (controller.cancellationPolicyContent.isEmpty) {
                        return const SizedBox();
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const VerticalSpace(height: 24),
                            const Text(
                              'Cancellation Policy',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const VerticalSpace(height: 12),
                            Text(
                              controller.cancellationPolicyContent.value,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const VerticalSpace(height: 24),
                          ],
                        );
                      }
                    }),
                    const VerticalSpace(height: 20),
                    Obx(
                      () => PrimaryButton(
                        onPressed: controller.isLoading.value ||
                                controller.cartInfo.value == null ||
                                controller.error.value != null
                            ? null
                            : controller.submit,
                        text: 'Place Order',
                      ),
                    ),
                    const VerticalSpace(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String value,
    Color valueColor, {
    bool isLabelBold = false,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(vertical: 8.sp),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: isLabelBold
                      ? Colors.black
                      : Colors.black.withValues(alpha: 0.6),
                  fontWeight: isLabelBold ? FontWeight.w700 : null,
                ),
              ),
            ),
            Expanded(
              child: Text(
                valueColor == Colors.red ? '- RM  $value' : 'RM  $value',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16.sp, color: valueColor),
              ),
            ),
          ],
        ),
      );
}
