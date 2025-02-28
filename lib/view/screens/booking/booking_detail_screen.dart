import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/booking/booking_detail_controller.dart';
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
    return Scaffold(
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
                                child:
                                    buildInfoRow('Name', myBooking.contactNo)),
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
                  const Spacer(),
                  if (myBooking.status.toLowerCase() != 'cancelled')
                    PrimaryButton(
                        onPressed: controller.showCancelBookingAlert,
                        text: 'Cancel'),
                  const VerticalSpace(height: 12),
                ],
              ),
            );
          },
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
