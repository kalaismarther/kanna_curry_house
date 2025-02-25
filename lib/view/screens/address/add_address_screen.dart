import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/address/add_address_controller.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/view/widgets/custom_text_field.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class AddAddressScreen extends StatelessWidget {
  const AddAddressScreen({super.key, this.fromUpdateProfile = false});

  final bool fromUpdateProfile;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddAddressController>(
      init: AddAddressController(),
      builder: (controller) => Scaffold(
        appBar: const PrimaryAppbar(title: 'Add Your Address'),
        body: Column(
          children: [
            Obx(
              () {
                if (controller.isLoading.value ||
                    controller.currentLocation.value == null) {
                  return SizedBox(
                    height: DeviceHelper.screenHeight(context) * 0.4,
                    child: const PrimaryLoader(),
                  );
                }

                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: DeviceHelper.screenHeight(context) * 0.4,
                  ),
                  child: GoogleMap(
                    onMapCreated: (mapController) {
                      controller.googleMapController = mapController;
                    },
                    initialCameraPosition: CameraPosition(
                        target: controller.currentLocation.value!, zoom: 15),
                    onTap: (argument) {
                      controller.updateLocation(
                          argument.latitude, argument.longitude);
                    },
                    markers: {
                      Marker(
                        markerId: const MarkerId('currentlocation'),
                        position: controller.currentLocation.value!,
                      )
                    },
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(vertical: 20.sp, horizontal: 16.sp),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        readyOnly: true,
                        controller: controller.locationController,
                        label: 'Full Address',
                        hintText: 'Enter Address',
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: 'Door No',
                              hintText: 'Door No',
                              controller: controller.doorNoController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Door No';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          const HorizontalSpace(width: 10),
                          Expanded(
                            child: CustomTextField(
                              controller: controller.pincodeController,
                              label: 'Pincode',
                              hintText: 'Pincode',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter pincode';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      CustomTextField(
                        label: 'Landmark',
                        hintText: 'Enter Landmark',
                        controller: controller.landmarkController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter landmark';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Text(
                        'Address Type',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const VerticalSpace(height: 16),
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        child: Obx(
                          () => Row(
                            children: [
                              for (final addressType in controller.addressTypes)
                                GestureDetector(
                                  onTap: () =>
                                      controller.chooseAddressType(addressType),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 8),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: addressType.isSelected
                                          ? AppTheme.yellow
                                          : AppTheme.inputBg,
                                      borderRadius:
                                          BorderRadius.circular(30.sp),
                                      border: Border.all(
                                          color: addressType.isSelected
                                              ? AppTheme.yellow
                                              : AppTheme.grey),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(addressType.icon,
                                            height: 18.sp, color: Colors.black),
                                        SizedBox(width: 8.sp),
                                        Text(
                                          addressType.name,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              fontWeight: addressType.isSelected
                                                  ? FontWeight.w500
                                                  : null,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: PrimaryButton(
          onPressed: controller.submit,
          text: 'Add Address',
          onScreenBottom: true,
        ),
      ),
    );
  }
}
