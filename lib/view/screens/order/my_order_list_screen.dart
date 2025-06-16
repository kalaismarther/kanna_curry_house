import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/order/my_order_list_controller.dart';
import 'package:kanna_curry_house/view/screens/order/order_detail_screen.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/my_order_item.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class MyOrderListScreen extends StatelessWidget {
  const MyOrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyOrderListController>(
      init: MyOrderListController(),
      builder: (controller) => Obx(
        () {
          if (controller.isLoading.value) {
            return ListView.separated(
              padding: EdgeInsets.all(16.sp),
              itemCount: 3,
              separatorBuilder: (context, index) =>
                  VerticalSpace(height: 24.sp),
              itemBuilder: (context, index) => LoadingShimmer(
                  height: 130.sp, width: double.infinity, radius: 16.sp),
            );
          }

          if (controller.error.value != null) {
            return Center(
              child: Text(controller.error.value ?? ''),
            );
          }

          if (controller.orders.isEmpty) {
            return const Center(
              child: Text('No Orders Found'),
            );
          }
          return RefreshIndicator(
            color: AppTheme.red,
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1), () {
                controller.fetchMyOrders(initialize: true);
              });
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.sp),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.orders.length +
                  (controller.paginationLoading.value ? 1 : 0),
              controller: controller.scrollController,
              itemBuilder: (context, index) => index == controller.orders.length
                  ? const Center(
                      child: CupertinoActivityIndicator(),
                    )
                  : MyOrderItem(
                      myOrder: controller.orders[index],
                      onTap: () async {
                        await Get.to(() => OrderDetailScreen(
                            orderId: controller.orders[index].id));
                        controller.fetchMyOrders(initialize: true);
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}
