import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/model/booking/my_booking_model.dart';

class MyBookingItem extends StatelessWidget {
  const MyBookingItem({
    super.key,
    required this.myBooking,
    this.onTap,
  });

  final MyBookingModel myBooking;
  final Function()? onTap;

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
              color: Colors.grey.withOpacity(0.2),
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
                  AppImages.myBooking,
                  height: 76.sp,
                  width: 76.sp,
                ),
                SizedBox(width: 20.sp),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking ID #${myBooking.uniqueNo}',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Text(
                        'Booked Date : ${myBooking.date}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Text(
                        'Booked Time : ${myBooking.time}',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8.sp),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4.sp),
            const Divider(),
            SizedBox(height: 4.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (myBooking.status.toLowerCase().trim() == 'cancelled')
                  Image.asset(AppImages.wrongIcon, height: 14.sp)
                else
                  Image.asset(AppImages.tickIcon, height: 14.sp),
                SizedBox(width: 6.sp),
                Text(
                  myBooking.status,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color:
                          myBooking.status.toLowerCase().trim() == 'cancelled'
                              ? Colors.red
                              : Colors.green.shade300),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
