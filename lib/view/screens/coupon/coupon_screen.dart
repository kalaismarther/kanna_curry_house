import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/coupon/coupon_controller.dart';
import 'package:kanna_curry_house/view/widgets/coupon_item.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class CouponScreen extends StatelessWidget {
  const CouponScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppbar(title: 'Coupons'),
      body: GetBuilder<CouponController>(
        init: CouponController(),
        builder: (controller) => Obx(
          () {
            if (controller.isLoading.value) {
              return ListView.separated(
                padding: EdgeInsets.all(16.sp),
                itemCount: 3,
                separatorBuilder: (context, index) =>
                    VerticalSpace(height: 24.sp),
                itemBuilder: (context, index) => LoadingShimmer(
                    height: 90.sp, width: double.infinity, radius: 16.sp),
              );
            }
            if (controller.error.value != null) {
              return Center(
                child: Text(controller.error.value ?? ''),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.sp),
              itemCount: controller.coupons.length +
                  (controller.paginationLoading.value ? 1 : 0),
              controller: controller.scrollController,
              itemBuilder: (context, index) =>
                  index == controller.coupons.length
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : CouponItem(
                          coupon: controller.coupons[index],
                          onSelect: () =>
                              Get.back(result: controller.coupons[index]),
                        ),
            );
          },
        ),
      ),
    );
  }
}
