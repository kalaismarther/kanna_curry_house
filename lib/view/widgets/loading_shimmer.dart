import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
    required this.height,
    required this.width,
    required this.radius,
    this.shape,
    this.baseColor,
    this.highlightColor,
  });

  final double height;
  final double width;
  final double radius;
  final BoxShape? shape;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: height,
      width: width,
      decoration: BoxDecoration(
          borderRadius: shape == null ? BorderRadius.circular(radius) : null,
          shape: shape ?? BoxShape.rectangle),
      child: Shimmer.fromColors(
        baseColor: baseColor ?? Colors.grey.shade300,
        highlightColor: highlightColor ?? Colors.white,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }
}
