import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';

class ProductsLoadingWidget extends StatelessWidget {
  const ProductsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 24.sp,
          crossAxisSpacing: 16.sp,
          childAspectRatio: 0.96),
      itemBuilder: (context, index) => LoadingShimmer(
          height: double.infinity, width: double.infinity, radius: 12.sp),
    );
  }
}
