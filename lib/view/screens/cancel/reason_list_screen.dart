import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/utils.dart';
import 'package:kanna_curry_house/controller/cancel/reason_list_controller.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';

class ReasonListScreen extends StatelessWidget {
  const ReasonListScreen({super.key, required this.fromOrderScreen});

  final bool fromOrderScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppbar(title: 'Select Reason'),
      body: GetBuilder<ReasonListController>(
        init: ReasonListController(cancelOrder: fromOrderScreen),
        builder: (controller) => Obx(
          () {
            if (controller.isLoading.value) {
              return PrimaryLoader();
            }
            if (controller.error.value != null) {
              return Center(
                child: Text(controller.error.value ?? ''),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16.sp),
              itemCount: controller.reasons.length,
              itemBuilder: (context, index) => Container(
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: ListTile(
                  onTap: () => Get.back(result: controller.reasons[index]),
                  title: Text(
                    controller.reasons[index].name,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 16.sp,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
