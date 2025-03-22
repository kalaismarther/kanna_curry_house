import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/profile/edit_profile_controller.dart';
import 'package:kanna_curry_house/core/utils/validation_helper.dart';
import 'package:kanna_curry_house/view/widgets/custom_text_field.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppbar(title: 'Edit Profile'),
      body: GetBuilder<EditProfileController>(
        init: EditProfileController(),
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200.sp,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Stack(
                    children: [
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.all(24.sp),
                          child: controller.selectedImagePath.value.isEmpty
                              ? OnlineImage(
                                  link: controller.userDp.value,
                                  height: 120.sp,
                                  width: 120.sp,
                                  radius: 10.sp,
                                )
                              : Container(
                                  height: 120.sp,
                                  width: 120.sp,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.sp),
                                    image: DecorationImage(
                                        image: FileImage(
                                          File(controller
                                              .selectedImagePath.value),
                                        ),
                                        onError: (exception, stackTrace) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                        ),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: IconButton(
                          onPressed: controller.showImagePickerDialog,
                          icon: Image.asset(
                            AppImages.cameraIcon,
                            height: 28.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 24.sp, horizontal: 16.sp),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: controller.name,
                        label: 'Name',
                        hintText: 'Enter your name',
                        validator: ValidationHelper.validateName,
                      ),
                      CustomTextField(
                        controller: controller.email,
                        label: 'Email',
                        hintText: 'Enter your email',
                        validator: ValidationHelper.validateEmail,
                      ),
                      CustomTextField(
                        readyOnly: true,
                        maxLength: 10,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: controller.mobileNumber,
                        label: 'Mobile',
                        hintText: 'Enter your mobile',
                        validator: ValidationHelper.validateMobileNumber,
                      ),
                      const VerticalSpace(height: 10),
                      PrimaryButton(
                          onPressed: controller.submit, text: 'Update')
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
