import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';
import 'package:kanna_curry_house/view/screens/booking/my_booking_list_screen.dart';
import 'package:kanna_curry_house/view/screens/home/home_screen.dart';
import 'package:kanna_curry_house/view/screens/order/my_order_list_screen.dart';
import 'package:kanna_curry_house/view/screens/profile/profile_screen.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:kanna_curry_house/view/widgets/side_menubar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return GetBuilder<DashboardController>(
      builder: (controller) => Obx(
        () => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (controller.currentTab.value == 0) {
              controller.exitAlert();
            } else {
              controller.changeTab(0);
            }
          },
          child: SafeArea(
            top: false,
            bottom: true,
            child: Scaffold(
              key: scaffoldKey,
              appBar: controller.currentTab.value == 0
                  ? null
                  : PrimaryAppbar(
                      title: controller.currentTab.value == 1
                          ? 'My Order'
                          : controller.currentTab.value == 2
                              ? 'My Bookings'
                              : controller.currentTab.value == 3
                                  ? 'Profile'
                                  : '',
                      dashboardScreen: true),
              drawer: SideMenubar(),
              body: controller.currentTab.value == 0
                  ? HomeScreen(
                      onMenuIconPressed: () =>
                          scaffoldKey.currentState?.openDrawer(),
                    )
                  : controller.currentTab.value == 1
                      ? const MyOrderListScreen()
                      : controller.currentTab.value == 2
                          ? const MyBookingListScreen()
                          : controller.currentTab.value == 3
                              ? const ProfileScreen()
                              : Container(),
              bottomNavigationBar: Obx(
                () => BottomNavigationBar(
                  currentIndex: controller.currentTab.value,
                  onTap: (value) => controller.changeTab(value),
                  selectedLabelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  selectedItemColor: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Colors.white,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        AppImages.footerHome,
                        height: 22.sp,
                      ),
                      activeIcon: Image.asset(
                        AppImages.footerHomeActive,
                        height: 22.sp,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        AppImages.footerMyOrder,
                        height: 22.sp,
                      ),
                      activeIcon: Image.asset(
                        AppImages.footerMyOrderActive,
                        height: 22.sp,
                      ),
                      label: 'My Order',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        AppImages.footerMyBooking,
                        height: 22.sp,
                      ),
                      activeIcon: Image.asset(
                        AppImages.footerMyBookingActive,
                        height: 22.sp,
                      ),
                      label: 'My Booking',
                    ),
                    BottomNavigationBarItem(
                      icon: Image.asset(
                        AppImages.footerProfile,
                        height: 22.sp,
                      ),
                      activeIcon: Image.asset(
                        AppImages.footeProfileActive,
                        height: 22.sp,
                      ),
                      label: 'My Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
