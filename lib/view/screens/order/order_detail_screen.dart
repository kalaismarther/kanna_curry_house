import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/order/order_detail_controller.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/my_order_item.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PrimaryAppbar(title: 'Order Details'),
      body: GetBuilder<OrderDetailController>(
        init: OrderDetailController(orderId: orderId),
        builder: (controller) => Obx(
          () {
            final myOrder = controller.myOrder.value;
            if (controller.isLoading.value && myOrder == null) {
              return const PrimaryLoader();
            }
            if (controller.error.value != null || myOrder == null) {
              return Center(
                child: Text(controller.error.value ?? ''),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  MyOrderItem(
                    myOrder: myOrder,
                    showRateNowBtn: true,
                  ),
                  const VerticalSpace(height: 4),
                  if (myOrder.preparationTime.isNotEmpty) ...[
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
                      child: Row(
                        children: [
                          Text(
                            'Order Preparation Time : ',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          Text(
                            '${myOrder.preparationTime} Mins',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.red),
                          )
                        ],
                      ),
                    ),
                    const VerticalSpace(height: 20),
                  ],
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
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.orderedItems.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 24.sp,
                      ),
                      itemBuilder: (context, index) {
                        final orderedItem = controller.orderedItems[index];
                        return Row(
                          children: [
                            OnlineImage(
                              link: orderedItem.imageLink,
                              height: 66.sp,
                              width: 74.sp,
                              radius: 12.sp,
                            ),
                            const HorizontalSpace(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'RM ${orderedItem.price}',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const VerticalSpace(height: 10),
                                  Text(
                                    '${orderedItem.name}  X  ${orderedItem.quantity}',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pricing Summary',
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w700),
                        ),
                        const VerticalSpace(height: 16),
                        _buildSummaryItem(
                            'Sub Total', myOrder.subTotal, Colors.black),
                        _buildSummaryItem(
                            'SST (tax is 6%)', myOrder.taxAmount, Colors.black),
                        if ((double.tryParse(myOrder.couponAmount) ?? 0.0) > 0)
                          _buildSummaryItem(
                              'Coupon Value', myOrder.couponAmount, Colors.red),
                        const Divider(height: 20),
                        _buildSummaryItem('Total', myOrder.total, Colors.black,
                            isLabelBold: true),
                      ],
                    ),
                  ),
                  const VerticalSpace(height: 24),
                  if (myOrder.status.toLowerCase().trim() != 'order cancelled')
                    PrimaryButton(
                      onPressed: controller.showCancelOrderAlert,
                      text: 'Cancel Order',
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, Color valueColor,
          {bool isLabelBold = false}) =>
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
                        : Colors.black.withOpacity(0.6),
                    fontWeight: isLabelBold ? FontWeight.w700 : null),
              ),
            ),
            Expanded(
              child: Text(
                valueColor == Colors.red ? '- RM  $value' : 'RM  $value',
                textAlign: TextAlign.end,
                style: TextStyle(fontSize: 16.sp, color: valueColor),
              ),
            )
          ],
        ),
      );
}
