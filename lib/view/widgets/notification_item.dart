import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/route_manager.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/model/notification/notification_model.dart';
import 'package:kanna_curry_house/view/screens/booking/booking_detail_screen.dart';
import 'package:kanna_curry_house/view/screens/order/order_detail_screen.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({super.key, required this.notification});

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (notification.title.toLowerCase().contains('table') ||
            notification.refId.toLowerCase().startsWith('kch')) {
          Get.to(() => BookingDetailScreen(bookingId: notification.redirectId));
        } else if (notification.title.toLowerCase().contains('order')) {
          Get.to(() => OrderDetailScreen(orderId: notification.redirectId));
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 4,
              spreadRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              AppImages.notification,
              height: 32.sp,
              width: 32.sp,
            ),
            const HorizontalSpace(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  ),
                  const VerticalSpace(height: 4),
                  Text(
                    notification.message,
                    style:
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400),
                  ),
                  const VerticalSpace(height: 4),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      notification.date,
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
