import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cart/cart_info_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';

class CartInfo extends StatelessWidget {
  const CartInfo({super.key, required this.onCheckOut});

  final Function() onCheckOut;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartInfoController>(
      builder: (controller) => Obx(
        () {
          final cart = controller.myCart.value;
          if (cart == null) {
            return const SizedBox();
          }
          return Container(
            width: DeviceHelper.screenWidth(context),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            color: const Color(0xFF121223),
            child: controller.isLoading.value
                ? LoadingShimmer(
                    height: 36.sp,
                    width: DeviceHelper.screenWidth(context),
                    radius: 10.sp,
                    baseColor: const Color(0xFF121223).withOpacity(0.5),
                    highlightColor: Colors.white.withOpacity(0.5),
                  )
                : Row(
                    children: [
                      if (controller.error.value != null) ...[
                        Text(
                          controller.error.value ?? '',
                          maxLines: 2,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                          ),
                        )
                      ] else ...[
                        Expanded(
                          child: Text(
                            '${cart.itemCount} Item Added  |  MYR ${cart.subTotal}',
                            style:
                                TextStyle(fontSize: 16.sp, color: Colors.white),
                          ),
                        ),
                        GestureDetector(
                          onTap: onCheckOut,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Text(
                              'Check Out',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
          );
        },
      ),
    );
  }
}
