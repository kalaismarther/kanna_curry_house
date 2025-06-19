import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/auth/login_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/core/utils/validation_helper.dart';
import 'package:kanna_curry_house/view/widgets/back_icon.dart';
import 'package:kanna_curry_house/view/widgets/custom_text_field.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController(), permanent: true);

    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Column(
          children: [
            Container(
              height: 300.sp,
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
                  Center(child: Image.asset(AppImages.logo, height: 80.sp)),
                  const Spacer(),
                  Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700),
                  ),
                  const VerticalSpace(height: 8),
                  Text(
                    'Please enter your mobile number',
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
                        // Obx(
                        //   () => CustomTextField(
                        //     readyOnly: true,
                        //     controller: controller.selectedCountry.value == null
                        //         ? null
                        //         : TextEditingController(
                        //             text:
                        //                 '${controller.selectedCountry.value?.name} (${controller.selectedCountry.value?.code})'),
                        //     onTap: controller.chooseCountry,
                        //     label: 'Country',
                        //     hintText: 'Select Country',
                        //     validator: (value) {
                        //       if (controller.selectedCountry.value == null ||
                        //           value == null ||
                        //           value.isEmpty) {
                        //         return 'Please select country';
                        //       }
                        //       return null;
                        //     },
                        //     marginBottom: 28,
                        //     suffixIcon: Icon(Icons.arrow_drop_down),
                        //   ),
                        // ),
                        Obx(
                          () => CustomTextField(
                            prefixIcon: controller.selectedCountry.value != null
                                ? InkWell(
                                    onTap: controller.chooseCountry,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(width: 2.sp),
                                            Text(controller.selectedCountry
                                                    .value?.code ??
                                                ''),
                                            SizedBox(width: 1.sp),
                                            Icon(Icons.arrow_drop_down)
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : null,
                            controller: controller.mobileController,
                            maxLength: 10,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            label: 'Mobile',
                            hintText: 'Enter mobile number',
                            validator: ValidationHelper.validateMobileNumber,
                            marginBottom: 52,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: controller.submit,
                          child: const Text('Login'),
                        ),
                        VerticalSpace(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: controller.continueAsGuest,
                            child: Text(
                              'Continue as Guest',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
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
