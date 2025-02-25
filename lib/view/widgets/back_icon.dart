import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({super.key, this.onBack});

  final Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBack ?? () => Get.back(),
      child: Image.asset(
        AppImages.backIcon,
        height: 38.sp,
        width: 38.sp,
      ),
    );
  }
}
