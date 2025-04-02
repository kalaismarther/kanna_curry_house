import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/booking/table_booking_request_model.dart';
import 'package:kanna_curry_house/view/screens/booking/booking_confirmed_screen.dart';

class TableBookingController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  var selectedDate = Rxn<DateTime>();
  final dateController = TextEditingController();

  var selectedTime = Rxn<TimeOfDay>();
  final timeController = TextEditingController();
  var noOfAdult = 5.obs;
  var noOfKids = 0.obs;

  void chooseDate(BuildContext context) async {
    final date = await showDatePicker(
      initialDate: selectedDate.value,
      context: context,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 7)),
      builder: (context, child) => Theme(
        data: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppTheme.red,
          colorScheme: const ColorScheme.light(
            primary: AppTheme.red,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogTheme: DialogThemeData(backgroundColor: Colors.white),
        ),
        child: child ?? const SizedBox(),
      ),
    );
    if (date != null) {
      selectedDate.value = date;
      dateController.text = DateFormat("dd MMM, yyyy").format(date);
    }
  }

  void chooseTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime.value ?? TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppTheme.red,
          colorScheme: const ColorScheme.light(
            primary: AppTheme.red,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child ?? const SizedBox(),
      ),
    );

    if (pickedTime != null) {
      if (context.mounted) {
        selectedTime.value = pickedTime;
        timeController.text = pickedTime.format(context);
        ;
      }
    }
  }

  String _convertTo24HourFormat(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0'); // Ensures two digits
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute'; // Returns time in HH:mm format
  }

  void increaseAdultCount() => noOfAdult.value++;

  void decreaseAdultsCount() {
    if (noOfAdult.value > 5) {
      noOfAdult.value--;
    } else {
      UiHelper.showToast('Minimum adult count is 5');
    }
  }

  void increaseKidsCount() => noOfKids.value++;

  void decreaseKidsCount() {
    if (noOfKids.value > 0) {
      noOfKids.value--;
    }
  }

  var isAgreed = false.obs;

  Future<void> submit() async {
    try {
      if (formKey.currentState?.validate() == true) {
        if (!isAgreed.value) {
          UiHelper.showToast('Please agree disclaimer');
        } else {
          UiHelper.showLoadingDialog();
          final user = StorageHelper.getUserDetail();
          final input = TableBookingRequestModel(
              userId: user.id,
              mobile: mobileController.text.trim(),
              name: nameController.text.trim(),
              date: selectedDate.value!,
              time:
                  _convertTo24HourFormat(selectedTime.value ?? TimeOfDay.now()),
              adultsCount: noOfAdult.value,
              kidsCount: noOfKids.value);

          final result = await ApiServices.requestForTableBooking(input);
          UiHelper.closeLoadingDialog();
          UiHelper.showToast(result);
          Get.to(() => const BookingConfirmedScreen(),
              transition: Transition.downToUp);
        }
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }
}
