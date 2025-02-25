import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/auth/verification_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/view/widgets/back_icon.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';
import 'package:pinput/pinput.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
      init: VerificationController(),
      builder: (controller) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          children: [
            Container(
              height: 224.sp,
              width: double.infinity,
              padding: EdgeInsets.all(20.sp),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppImages.leaf,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: DeviceHelper.statusbarHeight(context),
                  ),
                  const BackIcon(),
                  const Spacer(),
                  Text(
                    'Verification',
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700),
                  ),
                  const VerticalSpace(height: 8),
                  Text(
                    'You will get a OTP via SMS',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.sp),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.sp),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VerticalSpace(height: 8),
                        Text(
                          'Code',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        const VerticalSpace(height: 8),
                        Pinput(
                          length: 4,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          controller: controller.otpController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          defaultPinTheme: PinTheme(
                            width: 64.sp,
                            height: 62.sp,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color: AppTheme.inputBg,
                              border: Border.all(
                                width: 1.5,
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 64.sp,
                            height: 62.sp,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5, color: Colors.green.shade700),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          errorPinTheme: PinTheme(
                            width: 64.sp,
                            height: 62.sp,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5,
                                  color: Theme.of(context).colorScheme.error),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            textStyle: TextStyle(
                              fontSize: 20.sp,
                              color: Theme.of(context).colorScheme.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter 4 Digit OTP';
                            } else {
                              return null;
                            }
                          },
                        ),
                        const VerticalSpace(height: 24),
                        Center(
                          child: Obx(
                            () {
                              if (controller.remainingSeconds.value == 0) {
                                return TextButton(
                                  onPressed: () {
                                    controller.resetTimer();
                                  },
                                  child: Text(
                                    'Resend',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                  ),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.all(16.sp),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Re-send code in',
                                        style: TextStyle(
                                            color: Colors.grey.shade600),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${controller.remainingSeconds.value} secs',
                                        style: TextStyle(
                                            color: Colors.blue.shade800),
                                      )
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const VerticalSpace(height: 24),
                        ElevatedButton(
                          onPressed: controller.submit,
                          child: const Text('Verify OTP'),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
