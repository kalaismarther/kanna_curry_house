import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  static const Color yellow = Color(0xFFFCEE1C);

  static const Color red = Color(0xFFEC1D24);
  static const Color pink = Color(0xFFCC2B52);
  static const Color lightGrey = Color(0xFFF8F5F2);
  static const Color grey = Color(0xFFDBDBDB);
  static const Color darkgrey = Color(0xFF5B5B5B);
  static const Color inputBg = Color(0xFFF9F9FA);
  static ThemeData theme() => ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(
            seedColor: yellow, primary: yellow, secondary: red),
        useMaterial3: true,
        scaffoldBackgroundColor: lightGrey,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          surfaceTintColor: yellow,
          titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontWeight: FontWeight.w600),
        ),
        textTheme: TextTheme(
          headlineMedium: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          labelMedium: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black),
          bodyLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black),
          bodyMedium: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputBg,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: darkgrey.withOpacity(0.6),
          ),
          prefixStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          errorStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: red,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.sp, horizontal: 18.sp),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: grey),
            borderRadius: BorderRadius.circular(14.sp),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: grey),
            borderRadius: BorderRadius.circular(14.sp),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: grey),
            borderRadius: BorderRadius.circular(14.sp),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: red),
            borderRadius: BorderRadius.circular(14.sp),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: red),
            borderRadius: BorderRadius.circular(14.sp),
          ),
        ),
        tabBarTheme: const TabBarTheme(
            labelStyle:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500),
            unselectedLabelStyle:
                TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500)),
        dividerTheme: DividerThemeData(color: Colors.grey.shade300),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
            backgroundColor: red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(56),
            ),
            textStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(10),
            // ),
            side: const BorderSide(color: red),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            textStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ),
      );
}
