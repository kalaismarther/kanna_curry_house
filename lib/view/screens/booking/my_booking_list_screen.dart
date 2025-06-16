import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/booking/my_booking_list_controller.dart';
import 'package:kanna_curry_house/view/screens/booking/booking_detail_screen.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/my_booking_item.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class MyBookingListScreen extends StatelessWidget {
  const MyBookingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyBookingListController>(
      init: MyBookingListController(),
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

          if (controller.bookings.isEmpty) {
            return const Center(
              child: Text('No bookings Found'),
            );
          }

          return RefreshIndicator(
            color: AppTheme.red,
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1), () {
                controller.fetchMyBookings(initialize: true);
              });
            },
            child: ListView.builder(
              padding: EdgeInsets.all(16.sp),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.bookings.length +
                  (controller.paginationLoading.value ? 1 : 0),
              controller: controller.scrollController,
              itemBuilder: (context, index) =>
                  index == controller.bookings.length
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : MyBookingItem(
                          myBooking: controller.bookings[index],
                          onTap: () async {
                            await Get.to(() => BookingDetailScreen(
                                bookingId: controller.bookings[index].id));
                            controller.fetchMyBookings(initialize: true);
                          },
                        ),
            ),
          );
        },
      ),
    );
  }
}
