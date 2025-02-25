import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kanna_curry_house/model/category/category_model.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key,
      required this.category,
      required this.onTap,
      this.inListView = false,
      this.backgroundColor = Colors.white});

  final CategoryModel category;
  final Function() onTap;
  final bool inListView;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.only(right: inListView ? 12.sp : 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 16.sp),
            child: Row(
              children: [
                OnlineImage(
                  link: category.imageLink,
                  height: inListView ? 40.sp : 52.sp,
                  width: inListView ? 40.sp : 52.sp,
                  radius: 0,
                  shape: BoxShape.circle,
                ),
                const HorizontalSpace(width: 12),
                if (inListView)
                  Text(
                    category.name,
                    style: TextStyle(
                        color: backgroundColor == Colors.white
                            ? Colors.black
                            : Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  )
                else
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
