import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/order/order_detail_controller.dart';
import 'package:kanna_curry_house/model/order/my_order_model.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';

class MyOrderItem extends StatelessWidget {
  const MyOrderItem(
      {super.key,
      required this.myOrder,
      this.onTap,
      this.showRateNowBtn = false});

  final MyOrderModel myOrder;
  final Function()? onTap;
  final bool showRateNowBtn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.sp),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  AppImages.myBag,
                  height: 76.sp,
                  width: 76.sp,
                ),
                SizedBox(width: 20.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ID #${myOrder.uniqueNo}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Text(
                        'Placed on ${myOrder.orderDate} | ${myOrder.orderTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Row(
                        children: [
                          Text(
                            'Items : ',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            myOrder.itemsQuantity,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.sp),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.sp),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (showRateNowBtn) ...[
                  if (myOrder.isRatingSubmitted)
                    Padding(
                      padding: EdgeInsets.all(4.sp),
                      child: Text(
                        'Rating submitted',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    )
                  // else if (myOrder.status.toLowerCase() != 'order cancelled' &&
                  //     myOrder.status.toLowerCase() != 'processing')
                  else if (myOrder.status.toLowerCase() == 'delivered' ||
                      myOrder.status.toLowerCase() == 'order delivered')
                    InkWell(
                      onTap: () {
                        Get.find<OrderDetailController>().showRatingDialog();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(4.sp),
                        child: Text(
                          'Rate Now',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    )
                  else
                    const HorizontalSpace(width: 4)
                ] else ...[
                  if (myOrder.preparationTime.isNotEmpty &&
                      myOrder.status.toLowerCase().trim() !=
                          'order cancelled' &&
                      myOrder.status.toLowerCase().trim() != 'delivered')
                    Text(
                      '${myOrder.preparationTime} Mins',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.red),
                    )
                  else
                    HorizontalSpace(width: 10)
                ],
                Row(
                  children: [
                    if (myOrder.status.toLowerCase().trim() ==
                        'order cancelled')
                      Image.asset(AppImages.wrongIcon, height: 14.sp)
                    else
                      Image.asset(AppImages.tickIcon, height: 14.sp),
                    SizedBox(width: 6.sp),
                    Text(
                      myOrder.status,
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: myOrder.status.toLowerCase().trim() ==
                                  'order cancelled'
                              ? Colors.red
                              : Colors.green.shade300),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
