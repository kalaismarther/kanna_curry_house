import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.readyOnly = false,
    this.onTap,
    this.controller,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.maxLines,
    this.inputFormatters,
    this.bgColor,
    this.marginBottom,
  });

  final String label;
  final String hintText;
  final bool readyOnly;
  final Function()? onTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String? value)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final Color? bgColor;
  final double? marginBottom;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const VerticalSpace(height: 8),
        TextFormField(
          readOnly: readyOnly,
          onTap: onTap,
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            counterText: '',
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 12.sp),
              child: suffixIcon,
            ),
            suffixIconConstraints: BoxConstraints(maxHeight: 20.sp),
          ),
          validator: validator,
        ),
        VerticalSpace(height: marginBottom ?? 24),
      ],
    );
  }
}
