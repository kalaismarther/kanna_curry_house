import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/order/order_detail_controller.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class RatingDialog extends StatelessWidget {
  const RatingDialog({super.key, required this.onSubmit});

  final Function() onSubmit;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderDetailController>();
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.sp),
        ),
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Food',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              VerticalSpace(height: 12.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildStars(
                  controller.foodRatingStar.value,
                  (v) {
                    controller.foodRatingStar.value = v;
                  },
                ),
              ),
              VerticalSpace(height: 12.sp),
              const Divider(),
              VerticalSpace(height: 12.sp),
              Text(
                'Packaging',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              VerticalSpace(height: 12.sp),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildStars(
                  controller.packageRatingStar.value,
                  (v) {
                    controller.packageRatingStar.value = v;
                  },
                ),
              ),
              VerticalSpace(height: 12.sp),
              const Divider(),
              VerticalSpace(height: 12.sp),
              TextField(
                controller: controller.feedbackController,
                decoration: const InputDecoration(
                    fillColor: Colors.white, hintText: 'Feedback'),
                maxLines: 3,
              ),
              VerticalSpace(height: 24.sp),
              PrimaryButton(onPressed: onSubmit, text: 'Submit')
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStars(int rating, Function(int) onRatingChanged) {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      stars.add(
        GestureDetector(
          onTap: () => onRatingChanged(i),
          child: Icon(
            i <= rating ? Icons.star : Icons.star_border,
            color: i <= rating ? Colors.amber : Colors.grey,
            size: 36,
          ),
        ),
      );
    }

    return stars;
  }
}
