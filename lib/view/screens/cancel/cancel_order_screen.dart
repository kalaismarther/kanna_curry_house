import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/controller/cancel/cancel_order_controller.dart';
import 'package:kanna_curry_house/view/widgets/custom_text_field.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_button.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class CancelOrderScreen extends StatelessWidget {
  const CancelOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppbar(title: 'Cancel Order'),
      body: GetBuilder<CancelOrderController>(
        init: CancelOrderController(),
        builder: (controller) => SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              Obx(
                () => CustomTextField(
                    controller: TextEditingController(
                        text: controller.selectedReason.value?.name ?? ''),
                    readyOnly: true,
                    onTap: controller.chooseReason,
                    suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                    label: 'Reason',
                    hintText: 'Choose reason for cancel'),
              ),
              CustomTextField(
                label: 'Remarks (optional)',
                hintText: 'Explain more about your cancellation',
                maxLines: 4,
                controller: controller.manualReasonController,
              ),
              VerticalSpace(height: 32.sp),
              PrimaryButton(
                onPressed: controller.cancelOrder,
                text: 'Confirm cancel',
              )
            ],
          ),
        ),
      ),
    );
  }
}
