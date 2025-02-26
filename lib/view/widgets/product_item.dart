import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/model/product/product_model.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {super.key,
      required this.onTap,
      required this.onAdd,
      required this.onIncrement,
      required this.onDecrement,
      required this.product});

  final Function() onTap;
  final Function() onAdd;
  final Function() onIncrement;
  final Function() onDecrement;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Opacity(
            opacity: product.inStock ? 1 : .6,
            child: Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: CustomPaint(
                    size: const Size(double.infinity, 106),
                    painter: TrapezoidPainter(),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.sp),
                    child: OnlineImage(
                        link: product.imageLink,
                        height: 104.sp,
                        width: double.infinity,
                        radius: 12.r),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const VerticalSpace(height: 2),
                        Text(
                          product.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'RM ${product.sellingPrice}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (product.isInCart)
                              Row(
                                children: [
                                  InkWell(
                                    onTap: onDecrement,
                                    child: Container(
                                      padding: EdgeInsets.all(4.sp),
                                      margin: EdgeInsets.all(8.sp),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.yellow,
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: Colors.black,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    product.cartQuantity.toString(),
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  InkWell(
                                    onTap: onIncrement,
                                    child: Container(
                                      padding: EdgeInsets.all(4.sp),
                                      margin: EdgeInsets.all(8.sp),
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppTheme.yellow,
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 16.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              InkWell(
                                onTap: onAdd,
                                child: Container(
                                  padding: EdgeInsets.all(4.sp),
                                  margin: EdgeInsets.all(6.sp),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppTheme.red,
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              )
                          ],
                        ),
                        const VerticalSpace(height: 4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!product.inStock)
            Container(
              decoration: const BoxDecoration(
                color: Colors.white24,
              ),
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  'Out of Stock',
                  style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w700),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class TrapezoidPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    double bottomWidth = size.width; // Full width at the bottom
    double topWidth = size.width * 0.94; // 70% of bottom width
    double height = size.height;
    double cornerRadius = 24.sp; // Border radius

    double dx = (bottomWidth - topWidth) / 2; // Offset for centering top width

    Path path = Path()
      // Move to top-left corner
      ..moveTo(dx + cornerRadius, 0)
      // Top-left curve
      ..quadraticBezierTo(dx, 0, dx, cornerRadius + 10)
      // Left side
      ..lineTo(2, height - cornerRadius)
      // Bottom-left curve
      ..quadraticBezierTo(0, height, cornerRadius, height)
      // Bottom edge
      ..lineTo(bottomWidth - cornerRadius, height)
      // Bottom-right curve
      ..quadraticBezierTo(
          bottomWidth, height, bottomWidth, height - cornerRadius)
      // Right side
      ..lineTo(bottomWidth - dx, cornerRadius)
      // Top-right curve
      ..quadraticBezierTo(
          bottomWidth - dx, 0, bottomWidth - dx - cornerRadius, 0)
      ..close();

    // Draw shadow
    canvas.drawShadow(path, Colors.black.withOpacity(0.3), 6, true);

    // Draw the shape
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
