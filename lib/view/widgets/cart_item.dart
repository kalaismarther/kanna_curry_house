import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/model/cart/cart_item_model.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {super.key,
      required this.item,
      required this.onDecrement,
      required this.onIncrement});

  final CartItemModel item;
  final Function() onDecrement;
  final Function() onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OnlineImage(
          link: item.productImageLink,
          height: 60.sp,
          width: 70.sp,
          radius: 12.sp,
        ),
        const HorizontalSpace(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MYR ${item.sellingPrice}',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
              ),
              const VerticalSpace(height: 8),
              Text(
                item.productName,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
        const HorizontalSpace(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(6),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
              const SizedBox(width: 2),
              Text(
                item.cartQuantity.toString(),
                style: const TextStyle(
                    fontWeight: FontWeight.w500, color: Colors.white),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onIncrement,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
