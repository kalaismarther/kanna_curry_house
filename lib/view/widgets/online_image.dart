import 'package:cached_network_image/cached_network_image.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:flutter/material.dart';

class OnlineImage extends StatelessWidget {
  const OnlineImage(
      {super.key,
      required this.link,
      this.placeHolder,
      this.errorWidget,
      this.shape,
      required this.height,
      required this.width,
      required this.radius});

  final String link;
  final Widget? placeHolder;
  final Widget? errorWidget;
  final BoxShape? shape;
  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: link,
      placeholder: (context, url) =>
          placeHolder ??
          Container(
            height: height,
            width: width,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: shape ?? BoxShape.rectangle,
            ),
            child: LoadingShimmer(
                height: double.infinity,
                width: double.infinity,
                radius: radius),
          ),
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: shape ?? BoxShape.rectangle,
          borderRadius: shape == null ? BorderRadius.circular(radius) : null,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          alignment: Alignment.center,
          child: errorWidget ?? const Icon(Icons.error)),
    );
  }
}
