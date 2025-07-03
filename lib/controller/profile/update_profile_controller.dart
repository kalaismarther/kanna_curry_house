import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kanna_curry_house/controller/auth/login_controller.dart';
import 'package:kanna_curry_house/controller/dashboard/dashboard_controller.dart';
import 'package:kanna_curry_house/core/services/api_services.dart';
// import 'package:kanna_curry_house/core/utils/device_helper.dart';
import 'package:kanna_curry_house/core/utils/location_helper.dart';
import 'package:kanna_curry_house/core/utils/storage_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/address/address_model.dart';
import 'package:kanna_curry_house/model/profile/update_profile_request_model.dart';
// import 'package:kanna_curry_house/view/screens/address/add_address_screen.dart';
import 'package:kanna_curry_house/view/screens/dashboard/dashboard_screen.dart';
import 'package:kanna_curry_house/view/widgets/custom_date_picker.dart';

class UpdateProfileController extends GetxController {
  @override
  void onInit() {
    mobileController.text =
        Get.find<LoginController>().mobileController.text.trim();
    checkLocationPermissions();
    super.onInit();
  }

  final LoginController loginController = Get.find<LoginController>();
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  DateTime? dob;
  final dobController = TextEditingController();
  var address = Rxn<AddressModel>();
  var currentLocation = Rxn<LatLng>();
  final locationController = TextEditingController();
  RxBool isAgreed = false.obs;
  RxBool isLocationPermitted = false.obs;
  RxBool isLocationTurnedOn = false.obs;
  var fetchingLocation = false.obs;

  // void selectDOB(BuildContext context) async {
  //   final date = await showDatePicker(
  //     initialDate: dob,
  //     context: context,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //     builder: (context, child) => Theme(
  //       data: ThemeData(
  //         fontFamily: 'Poppins',
  //         primaryColor: AppTheme.red,
  //         colorScheme: const ColorScheme.light(
  //           primary: AppTheme.red,
  //           onPrimary: Colors.white,
  //           onSurface: Colors.black,
  //         ),
  //         dialogTheme: DialogThemeData(
  //             backgroundColor: Colors.white), // Background color
  //       ),
  //       child: child ?? const SizedBox(),
  //     ),
  //   );
  //   if (date != null) {
  //     dob = date;
  //     dobController.text = DateFormat("dd MMM, yyyy").format(date);
  //   }
  // }

  void selectDOB(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        return CustomDatePicker(
          initialDate: dob,
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          onDateSelected: (date) {
            dob = date;
            dobController.text = DateFormat("dd MMM, yyyy").format(date);
          },
        );
      },
    );
  }

  Future<void> checkLocationPermissions() async {
    try {
      bool hasLocationPermission = await LocationHelper.hasLocationPermission();

      isLocationPermitted.value = hasLocationPermission;

      if (!hasLocationPermission) {
        return;
      }
      await turnOnLocation();
    } catch (e) {
      // SystemNavigator.pop();
    }
  }

  Future<void> turnOnLocation() async {
    try {
      bool isLocationEnabled = await LocationHelper.isLocationEnabled();

      print(isLocationEnabled);

      isLocationTurnedOn.value = isLocationEnabled;

      if (isLocationEnabled) {
        await getDeviceLocation();
      }
    } catch (e) {
      //
    }
  }

  // Future<void> chooseLocation() async {
  //   final chosenAddress =
  //       await Get.to(() => const AddAddressScreen(fromUpdateProfile: true));

  //   if (chosenAddress != null && chosenAddress.runtimeType == AddressModel) {
  //     address.value = chosenAddress;
  //     locationController.text = address.value?.location ?? '';
  //   }
  // }

  void toggleAgree(bool? v) => isAgreed.value = v ?? false;

  Future<void> submit() async {
    try {
      UiHelper.unfocus();
      if (formKey.currentState?.validate() == true) {
        if (!isAgreed.value) {
          UiHelper.showToast(
              'Please agree our terms and conditions to continue');
        } else if (dob == null) {
          UiHelper.showToast('Please select date of birth');
        } else {
          UiHelper.showLoadingDialog();
          final user = StorageHelper.getUserDetail();
          final input = UpdateProfileRequestModel(
              userId: user.id,
              name: nameController.text,
              email: emailController.text,
              countryId: loginController.selectedCountry.value?.id ?? '',
              dob: dob!,
              address: address.value!);
          await ApiServices.updateUserProfile(input);
          await StorageHelper.write('logged', true);
          UiHelper.closeLoadingDialog();
          Get.find<DashboardController>().changeTab(0);
          Get.to(() => const DashboardScreen());
        }
      }
    } catch (e) {
      UiHelper.showErrorMessage(e);
    } finally {
      UiHelper.closeLoadingDialog();
    }
  }

  Future<void> getDeviceLocation() async {
    try {
      fetchingLocation.value = true;
      final deviceLocation = await LocationHelper.getCurrentLocation();
      await updateLocation(deviceLocation.latitude, deviceLocation.longitude);
      fetchingLocation.value = false;
    } catch (e) {
      Get.back();
      UiHelper.showErrorMessage(e);
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    currentLocation.value = LatLng(latitude, longitude);
//

    locationController.text =
        await LocationHelper.getFullAddress(latitude, longitude);
    update();
    address.value = AddressModel(
        location: locationController.text.trim(),
        doorNo: '10',
        pincode: await LocationHelper.getPincode(latitude, longitude),
        landmark: 'near',
        latitude: currentLocation.value?.latitude,
        longitude: currentLocation.value?.longitude,
        type: 'Home');
  }
}
