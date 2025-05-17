import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:kanna_curry_house/controller/notification/notification_controller.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/notification_item.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void goBack() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
        ModalRoute.withName('/dashboard_screen'),
      );
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else {
          goBack();
        }
      },
      child: Scaffold(
        appBar: PrimaryAppbar(
          title: 'Notification',
          onBack: goBack,
        ),
        body: GetBuilder<NotificationController>(
          init: NotificationController(),
          builder: (controller) => Obx(
            () {
              if (controller.isLoading.value) {
                return ListView.separated(
                  controller: controller.scrollController,
                  padding: EdgeInsets.all(16.sp),
                  itemCount: 5,
                  separatorBuilder: (context, index) =>
                      const VerticalSpace(height: 16),
                  itemBuilder: (context, index) => LoadingShimmer(
                      height: 90.sp, width: double.infinity, radius: 12),
                );
              }

              if (controller.error.value != null) {
                return Center(
                  child: Text(controller.error.value ?? ''),
                );
              }

              return ListView.separated(
                physics: BouncingScrollPhysics(),
                controller: controller.scrollController,
                itemCount: controller.notificationList.length +
                    (controller.paginationLoading.value ? 1 : 0),
                separatorBuilder: (context, index) =>
                    const VerticalSpace(height: 20),
                padding: EdgeInsets.all(16.sp),
                itemBuilder: (context, index) =>
                    index < controller.notificationList.length
                        ? NotificationItem(
                            notification: controller.notificationList[index],
                          )
                        : const CupertinoActivityIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}
