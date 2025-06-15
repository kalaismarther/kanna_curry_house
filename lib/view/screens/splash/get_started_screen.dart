import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/view/screens/auth/login_screen.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              AppImages.getStartedOne,
              height: 320.sp,
              width: 300.sp,
            ),
            const VerticalSpace(height: 20),
            Text(
              'Skip the wait',
              style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800),
            ),
            const VerticalSpace(height: 20),
            Text(
              'Book your order or table and enjoy pick-up or dine-in anytime',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
            const VerticalSpace(height: 52),
            SizedBox(
              height: 56.sp,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const LoginScreen()),
                child: const Text('Get Started'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
