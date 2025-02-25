import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';

class CategoriesLoadingWidget extends StatelessWidget {
  const CategoriesLoadingWidget({super.key, required this.isListView});

  final bool isListView;

  @override
  Widget build(BuildContext context) {
    if (isListView) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 4.sp),
        child: Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(right: 12.sp),
              child:
                  LoadingShimmer(height: 48.sp, width: 140.sp, radius: 12.sp),
            ),
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 8,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.sp,
          crossAxisSpacing: 16.sp,
          childAspectRatio: 2.2),
      itemBuilder: (context, index) => LoadingShimmer(
          height: double.infinity, width: double.infinity, radius: 12.sp),
    );
  }
}
