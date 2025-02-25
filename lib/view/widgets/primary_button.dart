import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.onScreenBottom = false});

  final Function() onPressed;
  final String text;
  final bool onScreenBottom;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: onScreenBottom ? 16.sp : 0,
          left: onScreenBottom ? 16.sp : 0,
          right: onScreenBottom ? 16.sp : 0,
          bottom: onScreenBottom ? DeviceHelper.bottombarHeight(context) : 0),
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
