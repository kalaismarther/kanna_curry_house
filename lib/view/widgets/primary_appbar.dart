import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';

class PrimaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppbar(
      {super.key,
      required this.title,
      this.actions,
      this.leading,
      this.dashboardScreen = false});

  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool dashboardScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 841.sp,
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        title,
        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
      ),
      leading: leading ??
          IconButton(
            onPressed: () {
              if (dashboardScreen) {
                Get.find<DashboardController>().changeTab(0);
              } else {
                Get.back();
              }
            },
            icon: Image.asset(
              AppImages.backIcon,
              height: 36.sp,
              width: 36.sp,
            ),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 16.sp);
}
