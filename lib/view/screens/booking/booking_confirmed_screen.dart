import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class BookingConfirmedScreen extends StatelessWidget {
  const BookingConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        } else {
          Get.find<DashboardController>().changeTab(2);
          Get.offAll(() => const DashboardScreen());
        }
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.bookingConfirmedColor,
                height: 300.sp,
              ),
              const VerticalSpace(height: 24),
              Text(
                'Thanks for your request',
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800),
              ),
              const VerticalSpace(height: 20),
              Text(
                'Our admin team will review and confirm your request soon',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade800),
              ),
              const VerticalSpace(height: 52),
              Center(
                child: SizedBox(
                  width: 200.sp,
                  child: PrimaryButton(
                      onPressed: () {
                        Get.find<DashboardController>().changeTab(2);
                        Get.offAll(() => const DashboardScreen());
                      },
                      text: 'View My Request'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
