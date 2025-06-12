import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/auth/countries_controller.dart';
import 'package:kanna_curry_house/model/auth/country_model.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';

class CountriesDialog extends StatelessWidget {
  const CountriesDialog({super.key, required this.onSelectCountry});

  final Function(CountryModel country) onSelectCountry;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400.h,
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.fromLTRB(24.w, 24.h, 16.w, 16.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.public,
                    color: Colors.blue.shade600,
                    size: 24.sp,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Select Country',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey.shade600,
                      size: 20.sp,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      padding: EdgeInsets.all(8.w),
                      minimumSize: Size(32.w, 32.h),
                    ),
                  ),
                ],
              ),
            ),

            // Countries List
            Expanded(
              child: GetBuilder<CountriesController>(
                init: CountriesController(),
                builder: (controller) => Obx(
                  () {
                    if (controller.isLoading.value) {
                      return Container(
                        padding: EdgeInsets.all(40.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PrimaryLoader(),
                            SizedBox(height: 16.h),
                            Text(
                              'Loading countries...',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.error.value != null) {
                      return Container(
                        padding: EdgeInsets.all(40.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red.shade400,
                              size: 48.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'Oops! Something went wrong',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              controller.error.value ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (controller.countries.isEmpty) {
                      return Container(
                        padding: EdgeInsets.all(40.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.public_off,
                              color: Colors.grey.shade400,
                              size: 48.sp,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'No Countries Found',
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
                      itemCount: controller.countries.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Colors.grey.shade200,
                      ),
                      itemBuilder: (context, index) {
                        final country = controller.countries[index];
                        return InkWell(
                          onTap: () {
                            Get.back();
                            onSelectCountry(country);
                          },
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 16.h,
                            ),
                            child: Row(
                              children: [
                                // Country flag or icon placeholder
                                Container(
                                  width: 32.w,
                                  height: 24.h,
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(4.r),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      country.code,
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        country.name,
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        country.code,
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: Colors.grey.shade400,
                                  size: 20.sp,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
