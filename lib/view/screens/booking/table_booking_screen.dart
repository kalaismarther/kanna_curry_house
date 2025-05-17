import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/booking/table_booking_controller.dart';
import 'package:kanna_curry_house/core/utils/validation_helper.dart';
import 'package:kanna_curry_house/view/widgets/custom_text_field.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class TableBookingScreen extends StatelessWidget {
  const TableBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: const PrimaryAppbar(title: 'Table Booking'),
        body: GetBuilder<TableBookingController>(
          init: TableBookingController(),
          builder: (controller) => Obx(
            () => SingleChildScrollView(
              padding: EdgeInsets.all(16.sp),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: controller.nameController,
                      label: 'Name',
                      hintText: 'Enter name',
                      bgColor: Colors.white,
                      validator: ValidationHelper.validateName,
                    ),
                    CustomTextField(
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: controller.mobileController,
                      label: 'Mobile Number',
                      hintText: 'Enter Mobile Number',
                      bgColor: Colors.white,
                      validator: ValidationHelper.validateMobileNumber,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CustomTextField(
                            readyOnly: true,
                            onTap: () => controller.chooseDate(context),
                            controller: controller.dateController,
                            label: 'Date',
                            hintText: 'Select Date',
                            bgColor: Colors.white,
                            suffixIcon:
                                Image.asset(AppImages.calendarIconColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select Date';
                              }
                              return null;
                            },
                          ),
                        ),
                        const HorizontalSpace(width: 12),
                        Expanded(
                          child: CustomTextField(
                            readyOnly: true,
                            onTap: () => controller.chooseTime(context),
                            controller: controller.timeController,
                            label: 'Time',
                            hintText: 'Select Time',
                            bgColor: Colors.white,
                            suffixIcon: Image.asset(AppImages.clockIconColor),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Select Date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'No of Adult',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const VerticalSpace(height: 8),
                    InputDecorator(
                      decoration: const InputDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.noOfAdult.value.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: controller.decreaseAdultsCount,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.all(6),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  controller.noOfAdult.value.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: controller.increaseAdultCount,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalSpace(height: 24),
                    Text(
                      'No of Kids',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const VerticalSpace(height: 8),
                    InputDecorator(
                      decoration: const InputDecoration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.noOfKids.value.toString(),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: controller.decreaseKidsCount,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.all(6),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  controller.noOfKids.value.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: controller.increaseKidsCount,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    margin: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.white.withValues(alpha: 0.3),
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const VerticalSpace(height: 24),
                    const Text(
                      'Disclaimer',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const VerticalSpace(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                            checkColor: Colors.black,
                            value: controller.isAgreed.value,
                            onChanged: (v) {
                              controller.isAgreed.value =
                                  !controller.isAgreed.value;
                            }),
                        Expanded(
                          child: Text(
                            'Table bookings are subject to availability and restaurant confirmation. Arrival delays may result in cancellation. The restaurant reserves the right to modify or cancel reservations.',
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    const VerticalSpace(height: 30),
                    PrimaryButton(onPressed: controller.submit, text: 'Request')
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
