import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/Core/Utils/device_helper.dart';
import 'package:kanna_curry_house/model/coupon/coupon_model.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class CouponItem extends StatelessWidget {
  const CouponItem({super.key, required this.coupon, required this.onSelect});

  final CouponModel coupon;
  final Function() onSelect;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
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
        margin: EdgeInsets.only(bottom: 16.sp),
        child: IntrinsicHeight(
          child: Row(
            children: [
              OnlineImage(
                  link: coupon.imageLink,
                  height: double.infinity,
                  width: DeviceHelper.screenWidth(context) * 0.24,
                  radius: 8.r),
              const HorizontalSpace(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coupon.name,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    const VerticalSpace(height: 8),
                    Text(
                      coupon.description,
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                    const VerticalSpace(height: 8),
                    Text(
                      'Coupon code : ${coupon.code}',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
