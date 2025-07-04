import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';
import 'package:kanna_curry_house/controller/home/home_controller.dart';
import 'package:kanna_curry_house/core/utils/auth_helper.dart';
import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/view/screens/help/help_and_support_screen.dart';
import 'package:kanna_curry_house/view/screens/notification/notification_screen.dart';
import 'package:kanna_curry_house/view/widgets/horizontal_space.dart';
import 'package:kanna_curry_house/view/widgets/online_image.dart';
import 'package:kanna_curry_house/view/widgets/vertical_space.dart';
import 'package:share_plus/share_plus.dart';

class SideMenubar extends StatelessWidget {
  const SideMenubar({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          SizedBox(
            height: DeviceHelper.statusbarHeight(context),
          ),
          Obx(
            () => Padding(
              padding: EdgeInsets.all(16.sp),
              child: Row(
                children: [
                  OnlineImage(
                    link: controller.userProfileImage.value,
                    height: 72.sp,
                    width: 72.sp,
                    radius: 10.sp,
                  ),
                  const HorizontalSpace(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userName.value,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.w600),
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
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildDrawerItem(AppImages.smHome, 'Home'),
                  _buildDrawerItem(AppImages.smOrder, 'My Order'),
                  _buildDrawerItem(AppImages.smBooking, 'My Bookings'),
                  _buildDrawerItem(AppImages.smProfile, 'Profile'),
                  _buildDrawerItem(AppImages.smNotification, 'Notifications'),
                  _buildDrawerItem(AppImages.smShare, 'Share this app'),
                  _buildDrawerItem(AppImages.smHelp, 'Help'),
                  if (controller.isGuestUser.value)
                    _buildDrawerItem(AppImages.smLogout, 'Login')
                  else
                    _buildDrawerItem(AppImages.smLogout, 'Logout'),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String image, String title) {
    return ListTile(
      leading: Image.asset(image, height: 20.sp),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.black87,
        size: 32.sp,
      ),
      onTap: () async {
        final dashboardController = Get.find<DashboardController>();
        final isGuestUser = AuthHelper.isGuestUser();

        if (title == 'Home') {
          Get.back();
        } else if (title == 'My Order') {
          Get.back();
          dashboardController.changeTab(1);
        } else if (title == 'My Bookings') {
          Get.back();
          dashboardController.changeTab(2);
        } else if (title == 'Profile') {
          Get.back();
          dashboardController.changeTab(3);
        } else if (title == 'Notifications') {
          if (!isGuestUser) {
            Get.back();
            Get.to(() => NotificationScreen());
          } else {
            UiHelper.showToast('Please login to view your notifications');
          }
        } else if (title == 'Share this app') {
          String playstoreLink =
              'https://play.google.com/store/apps/details?id=com.smart.aadhicurryhouse';
          String appstoreLink =
              'https://apps.apple.com/us/app/aadhi-curry-house/id6747305559';

          final String message = '''
Order your favorite dishes or book a table — right from your phone!
Download the app now and enjoy a smooth food & dining experience:

Play Store : $playstoreLink

App Store : $appstoreLink

Let me know what you think and feel free to share! 😋
''';

          Share.share(message);
        } else if (title == 'Help') {
          Get.back();
          Get.to(() => HelpAndSupportScreen());
        } else if (title == 'Logout') {
          Get.back();
          dashboardController.showLogoutAlert();
        } else if (title == 'Login') {
          Get.back();
          AuthHelper.redirectGuestUserToLogin();
        }
      },
    );
  }
}
