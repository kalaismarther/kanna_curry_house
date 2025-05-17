import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/booking/booking_detail_controller.dart';
import 'package:kanna_curry_house/view/screens/cancel/cancel_booking_screen.dart';
import 'package:kanna_curry_house/view/widgets/my_booking_item.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: const PrimaryAppbar(title: 'Booking Details'),
        body: GetBuilder<BookingDetailController>(
          init: BookingDetailController(bookingId: bookingId),
          builder: (controller) => Obx(
            () {
              final myBooking = controller.myBooking.value;
              if (controller.isLoading.value && myBooking == null) {
                return const PrimaryLoader();
              }
              if (controller.error.value != null || myBooking == null) {
                return Center(
                  child: Text(controller.error.value ?? ''),
                );
              }
              return Padding(
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  children: [
                    MyBookingItem(myBooking: myBooking),
                    const VerticalSpace(height: 4),
                    Container(
                      padding: EdgeInsets.all(16.sp),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            spreadRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: buildInfoRow(
                                      'Name', myBooking.contactNo)),
                              Expanded(
                                child: buildInfoRow(
                                    'Mobile Number', myBooking.contactNumber),
                              ),
                            ],
                          ),
                          const VerticalSpace(height: 28),
                          Row(
                            children: [
                              Expanded(
                                  child: buildInfoRow('Date', myBooking.date)),
                              Expanded(
                                child: buildInfoRow('Time', myBooking.time),
                              ),
                            ],
                          ),
                          const VerticalSpace(height: 28),
                          Row(
                            children: [
                              Expanded(
                                  child: buildInfoRow(
                                      'No of Adult', myBooking.adultsCount)),
                              Expanded(
                                child: buildInfoRow(
                                    'No of Kid', myBooking.kidsCount),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    if (myBooking.status.toLowerCase().trim() == 'rejected' &&
                        myBooking.rejectedReason.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 16),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.red.shade200),
                          ),
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.error_outline_rounded,
                                      color: Colors.red.shade700,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Rejected Reason',
                                      style: TextStyle(
                                        color: Colors.red.shade800,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    myBooking.rejectedReason,
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 14,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (myBooking.status.toLowerCase().trim() == 'requested')
                      PrimaryButton(
                          onPressed: () async {
                            await Get.to(() => CancelBookingScreen());
                            controller.onInit();
                          },
                          text: 'Cancel'),
                    const VerticalSpace(height: 12),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        const VerticalSpace(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
