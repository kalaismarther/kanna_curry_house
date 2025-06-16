import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/config/app_theme.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';
import 'package:kanna_curry_house/controller/profile/profile_controller.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/view/screens/help/help_and_support_screen.dart';
import 'package:kanna_curry_house/view/screens/notification/notification_screen.dart';
import 'package:kanna_curry_house/view/screens/profile/delete_account_screen.dart';
import 'package:kanna_curry_house/view/screens/profile/edit_profile_screen.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/primary_loader.dart';
import 'package:kanna_curry_house/view/widgets/profile_menu_item.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    controller.onInit();

    final dashboardController = Get.find<DashboardController>();

    return Obx(
      () => controller.isLoading.value
          ? const PrimaryLoader()
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.sp),
              child: Column(
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
                    child: Row(
                      children: [
                        OnlineImage(
                          link: controller.userDp.value,
                          height: 72.sp,
                          width: 72.sp,
                          radius: 10.sp,
                        ),
                        const HorizontalSpace(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.userName.value,
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              const VerticalSpace(height: 4),
                              Text(
                                controller.email.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                        ),
                        HorizontalSpace(width: 8),
                        InkWell(
                          onTap: () async {
                            if (!AuthHelper.isGuestUser()) {
                              await Get.to(() => const EditProfileScreen());
                              controller.onInit();
                            } else {
                              UiHelper.showToast(
                                  'Please login to edit your profile');
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 6.sp, horizontal: 20.sp),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.red, width: 1),
                              borderRadius: BorderRadius.circular(8.sp),
                            ),
                            child: Text(
                              'Edit',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppTheme.red,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const VerticalSpace(height: 30),
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1.2),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Column(
                      children: [
                        ProfileMenuItem(
                          onTap: () => dashboardController.changeTab(1),
                          image: AppImages.menuMyOrders,
                          text: 'My Orders',
                        ),
                        ProfileMenuItem(
                          onTap: () => dashboardController.changeTab(2),
                          image: AppImages.menuMyBookings,
                          text: 'My Bookings',
                        ),
                        ProfileMenuItem(
                          onTap: () {
                            if (!AuthHelper.isGuestUser()) {
                              Get.off(() => NotificationScreen());
                            } else {
                              UiHelper.showToast(
                                  'Please login to view your notifications');
                            }
                          },
                          image: AppImages.menuNotification,
                          text: 'Notification',
                        ),
                        ProfileMenuItem(
                          onTap: () =>
                              Get.to(() => const HelpAndSupportScreen()),
                          image: AppImages.menuHelp,
                          text: 'Help & Support',
                        ),
                        ProfileMenuItem(
                          onTap: dashboardController.showLogoutAlert,
                          image: AppImages.logout,
                          text: 'Logout',
                        ),
                        if (controller.showDeleteBtn.value)
                          ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16.sp),
                            leading: Icon(
                              Icons.delete_outline,
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withValues(alpha: 0.76),
                            ),
                            title: Text(
                              'Delete Account',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios,
                                size: 16.sp, color: Colors.grey),
                            onTap: () => Get.to(() => DeleteAccountScreen()),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
