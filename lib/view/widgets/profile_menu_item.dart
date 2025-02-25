import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileMenuItem extends StatelessWidget {
  const ProfileMenuItem({
    super.key,
    required this.onTap,
    required this.image,
    required this.text,
  });

  final String image;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.sp),
      leading: Image.asset(
        image,
        height: 22.sp,
      ),
      title: Text(
        text,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
      onTap: onTap,
    );
  }
}
