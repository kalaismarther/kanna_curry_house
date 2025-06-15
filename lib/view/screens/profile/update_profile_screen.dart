import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_constants.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/profile/update_profile_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/core/utils/validation_helper.dart';
import 'package:kanna_curry_house/view/screens/auth/policy_screen.dart';
import 'package:kanna_curry_house/view/widgets/back_icon.dart';
import 'package:kanna_curry_house/view/widgets/custom_text_field.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: UpdateProfileController(),
      builder: (controller) => SafeArea(
        top: false,
        bottom: true,
        child: Scaffold(
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
                      'Update Profile',
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.w700),
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
                  child: Obx(() {
                    if (!controller.isLocationPermitted.value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon Container
                            Container(
                              width: 80.sp,
                              height: 80.sp,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Icon(
                                Icons.location_on_outlined,
                                size: 60.sp,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Title
                            Text(
                              'Location Permission Required',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const VerticalSpace(height: 16),

                            // Description
                            Text(
                              'We use your location to show nearby available orders and enhance your booking experience.',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Action Buttons
                            Column(
                              children: [
                                // Primary Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed:
                                        controller.checkLocationPermissions,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Check Permission',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Secondary Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: OutlinedButton(
                                    onPressed: () async {
                                      await openAppSettings();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      side: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'Open Settings',
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }

                    if (!controller.isLocationTurnedOn.value) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon Container
                            Container(
                              width: 80.sp,
                              height: 80.sp,
                              decoration: BoxDecoration(
                                color: Colors.orange[50],
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: Icon(
                                Icons.location_off_outlined,
                                size: 60.sp,
                                color: Colors.orange[600],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Title
                            Text(
                              'Enable Location Services',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),

                            // Description
                            Text(
                              'We use your location to show nearby available orders and enhance your booking experience.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 40),

                            // Action Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: controller.turnOnLocation,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[600],
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Enable Location',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.fetchingLocation.value) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Custom Loading Animation
                          Container(
                            width: 80.sp,
                            height: 80.sp,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 50.sp,
                                  height: 50.sp,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                                Icon(
                                  Icons.my_location,
                                  size: 24,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          Text(
                            'Getting your location...',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 8),

                          Text(
                            'This may take a few seconds',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      );
                    }

                    return SingleChildScrollView(
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
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              label: 'Mobile Number',
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
                              // readyOnly: true,
                              // onTap: controller.chooseLocation,
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
                                Checkbox(
                                  value: controller.isAgreed.value,
                                  checkColor: Colors.black,
                                  onChanged: (v) => controller.toggleAgree(v),
                                ),
                                Text(
                                  'I Agree',
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                                const HorizontalSpace(width: 10),
                                InkWell(
                                  onTap: () => Get.to(() => PolicyScreen(
                                      title: 'Terms and Conditions',
                                      url: AppConstants.termsUrl)),
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
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
