import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kanna_curry_house/config/app_images.dart';
import 'package:kanna_curry_house/core/utils/location_helper.dart';
import 'package:kanna_curry_house/core/utils/ui_helper.dart';
import 'package:kanna_curry_house/model/address/address_model.dart';
import 'package:kanna_curry_house/model/address/address_type_model.dart';

class AddAddressController extends GetxController {
  @override
  void onInit() {
    getDeviceLocation();
    super.onInit();
  }

  var currentLocation = Rxn<LatLng>();

  RxBool isLoading = false.obs;
  GoogleMapController? googleMapController;
  final formKey = GlobalKey<FormState>();
  final locationController = TextEditingController();
  final doorNoController = TextEditingController();
  final pincodeController = TextEditingController();
  final landmarkController = TextEditingController();
  var addressTypes = <AddressTypeModel>[
    AddressTypeModel(
        name: 'Home', icon: AppImages.homeAddress, isSelected: false),
    AddressTypeModel(
        name: 'Work', icon: AppImages.workAddress, isSelected: false),
    AddressTypeModel(
        name: 'Others', icon: AppImages.otherAddress, isSelected: false),
  ].obs;
  var selectedAddressType = AddressTypeModel(
      name: 'Home', icon: AppImages.homeAddress, isSelected: true);

  Future<void> getDeviceLocation() async {
    try {
      isLoading.value = true;
      final deviceLocation = await LocationHelper.getCurrentLocation();
      updateLocation(deviceLocation.latitude, deviceLocation.longitude);
    } catch (e) {
      Get.back();
      UiHelper.showErrorMessage(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    currentLocation.value = LatLng(latitude, longitude);

    locationController.text =
        await LocationHelper.getFullAddress(latitude, longitude);

    pincodeController.text =
        await LocationHelper.getPincode(latitude, longitude);
  }

  void chooseAddressType(AddressTypeModel type) {
    for (final addressType in addressTypes) {
      addressType.isSelected = false;
    }
    addressTypes.refresh();
    final address = addressTypes.firstWhere((e) => e == type);
    address.isSelected = true;
    selectedAddressType = type;
    addressTypes.refresh();
  }

  Future<void> submit() async {
    try {
      if (formKey.currentState?.validate() == true) {
        var address = AddressModel(
            location: locationController.text.trim(),
            doorNo: doorNoController.text.trim(),
            pincode: pincodeController.text.trim(),
            landmark: landmarkController.text.trim(),
            latitude: currentLocation.value?.latitude,
            longitude: currentLocation.value?.longitude,
            type: selectedAddressType.name);

        Get.back(result: address);
      }
    } catch (e) {
      //
    }
  }
}
