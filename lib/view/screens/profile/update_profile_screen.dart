import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/profile/update_profile_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/core/utils/validation_helper.dart';
import 'package:kanna_curry_house/view/widgets/back_icon.dart';
import 'package:kanna_curry_house/view/widgets/custom_text_field.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: UpdateProfileController(),
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
                    'Update Profile',
                    style:
                        TextStyle(fontSize: 30.sp, fontWeight: FontWeight.w700),
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
                        CustomTextField(
                          label: 'Name',
                          hintText: 'Enter your name',
                          controller: controller.nameController,
                          validator: ValidationHelper.validateName,
                        ),
                        CustomTextField(
                          label: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your email address',
                          controller: controller.emailController,
                          validator: ValidationHelper.validateEmail,
                        ),
                        CustomTextField(
                          readyOnly: true,
                          maxLength: 10,
                          label: 'Mobile Number',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          hintText: 'Enter your mobile number',
                          controller: controller.mobileController,
                          validator: ValidationHelper.validateMobileNumber,
                        ),
                        CustomTextField(
                          readyOnly: true,
                          onTap: () => controller.selectDOB(context),
                          label: 'Date of Birth',
                          hintText: 'Choose DOB',
                          controller: controller.dobController,
                          suffixIcon: Image.asset(AppImages.calendarIcon),
                          validator: (value) {
                            if (value == null ||
                                controller.dob == null ||
                                value.isEmpty) {
                              return 'Please enter date of birth';
                            } else {
                              return null;
                            }
                          },
                        ),
                        CustomTextField(
                          readyOnly: true,
                          onTap: controller.chooseLocation,
                          label: 'Location',
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Enter your location',
                          controller: controller.locationController,
                          marginBottom: 8.sp,
                          validator: (value) {
                            if (value == null ||
                                controller.address.value == null ||
                                value.isEmpty) {
                              return 'Please enter location';
                            } else {
                              return null;
                            }
                          },
                        ),
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                  value: controller.isAgreed.value,
                                  checkColor: Colors.black,
                                  onChanged: (v) => controller.toggleAgree(v)),
                            ),
                            Text(
                              'I Agree',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            const HorizontalSpace(width: 10),
                            InkWell(
                              child: Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                    fontSize: 14.sp, color: Colors.blue),
                              ),
                            )
                          ],
                        ),
                        const VerticalSpace(height: 16),
                        ElevatedButton(
                          onPressed: controller.submit,
                          child: const Text('Update Profile'),
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
