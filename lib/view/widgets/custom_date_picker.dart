import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateSelected,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = selectedDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      elevation: 16,
      child: Container(
        width: 400.w,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 28.sp,
                ),
                SizedBox(width: 12.w),
                Text(
                  selectedDate != null
                      ? DateFormat("dd MMM, yyyy").format(selectedDate!)
                      : 'Select Date of Birth',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // Calendar with custom theme
            // Theme(
            //   data: ThemeData(
            //     colorScheme: ColorScheme.fromSeed(
            //       seedColor: Colors.red,
            //       primary: Colors.blue, // selected date circle color
            //       onPrimary: Colors.white, // selected date text color
            //       surface: Colors.grey.shade50, // calendar bg
            //     ),
            //   ),
            //   child: Container(
            //     decoration: BoxDecoration(
            //       color: Colors.grey.shade50,
            //       borderRadius: BorderRadius.circular(16.r),
            //       border: Border.all(color: Colors.grey.shade200),
            //     ),
            //     child: CalendarDatePicker(
            //       initialDate: widget.initialDate ?? DateTime.now(),
            //       firstDate: widget.firstDate,
            //       lastDate: widget.lastDate,
            //       onDateChanged: (date) {
            //         selectedDate = date;
            //       },
            //     ),
            //   ),
            // ),
            Theme(
              data: ThemeData(
                fontFamily: 'Poppins',
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppTheme.red,
                  primary: AppTheme.red, // selected date circle color
                  onPrimary: Colors.white, // selected date text color
                  surface: Colors.grey.shade50, // calendar bg
                ),
              ),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SfDateRangePicker(
                  showTodayButton: false,
                  selectionColor: AppTheme.red,
                  initialDisplayDate: widget.initialDate,
                  initialSelectedDate: widget.initialDate,
                  minDate: widget.firstDate,
                  maxDate: widget.lastDate,
                  backgroundColor: Colors.transparent,
                  headerHeight: 52.sp,
                  headerStyle: DateRangePickerHeaderStyle(
                      backgroundColor: AppTheme.yellow,
                      textStyle: TextStyle(fontWeight: FontWeight.w500)),
                  onSelectionChanged: (dateRangePickerSelectionChangedArgs) {
                    selectedDate = dateRangePickerSelectionChangedArgs.value;
                    setState(() {});
                  },
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Cancel button
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 16.w),

                // OK button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedDate != null) {
                        widget.onDateSelected(selectedDate!);
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'OK',
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
      ),
    );
  }
}
