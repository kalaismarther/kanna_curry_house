import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/help/help_and_support_controller.dart';
import 'package:kanna_curry_house/core/utils/launcher_helper.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/loading_shimmer.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class HelpAndSupportScreen extends StatelessWidget {
  const HelpAndSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HelpAndSupportController>(
      init: HelpAndSupportController(),
      builder: (controller) => Scaffold(
        appBar: const PrimaryAppbar(title: 'Help & Support'),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(
                  () {
                    if (controller.contactDetailLoading.value) {
                      return ListView.separated(
                        itemCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => LoadingShimmer(
                            height: 44.sp, width: double.infinity, radius: 12),
                      );
                    }
                    if (controller.contactDetailError.value != null) {
                      return Center(
                        child: Text(controller.contactDetailError.value ?? ''),
                      );
                    }

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => LauncherHelper.openMailApp(
                              controller.emailAddress.value),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.sp, horizontal: 4.sp),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppImages.gmail,
                                  height: 24.sp,
                                ),
                                const HorizontalSpace(width: 16),
                                Expanded(
                                  child: Text(controller.emailAddress.value),
                                )
                              ],
                            ),
                          ),
                        ),
                        const Divider(),
                        GestureDetector(
                          onTap: () => LauncherHelper.openWhatsApp(
                              controller.whatsappNo.value),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.sp, horizontal: 4.sp),
                            child: Row(
                              children: [
                                Image.asset(
                                  AppImages.whatsapp,
                                  height: 28.sp,
                                ),
                                const HorizontalSpace(width: 16),
                                Expanded(
                                  child: Text(controller.whatsappNo.value),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const VerticalSpace(height: 40),
              Text(
                'FAQ',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const VerticalSpace(height: 10),
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 8,
                      spreadRadius: 4,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Obx(
                  () {
                    if (controller.faqLoading.value) {
                      return ListView.separated(
                        itemCount: 6,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) => LoadingShimmer(
                            height: 44.sp, width: double.infinity, radius: 12),
                      );
                    }
                    if (controller.faqError.value != null) {
                      return Center(
                        child: Text(controller.faqError.value ?? ''),
                      );
                    }

                    return ListView.separated(
                      itemCount: controller.faqList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) => Theme(
                        data: ThemeData(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.all(0),
                          title: Text(controller.faqList[index].question),
                          expandedAlignment: Alignment.centerLeft,
                          childrenPadding: const EdgeInsets.only(bottom: 16),
                          children: [Text(controller.faqList[index].answer)],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
