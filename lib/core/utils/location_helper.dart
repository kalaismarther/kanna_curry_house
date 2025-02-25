import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationHelper {
  // static String mapAPIKEY = 'AIzaSyAswNapJDd67ZOm8m7Q3-3YAURTG90TNJY';
  // static String mapAPIKEY = 'AIzaSyC02mbBnNntW4ThfaTfWZLuvEpYVr3Rh8Y';
  static String mapAPIKEY = 'AIzaSyDC5-dTVFnP_VU1wriQowVYhH8Daom_7E8';

  //
  static Location location = Location();

  static Future<bool> isLocationEnabled() async {
    bool serviceEnabled = false;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  static Future<bool> hasLocationPermission() async {
    PermissionStatus permissionGranted;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    return permissionGranted == PermissionStatus.granted;
  }

  static Future<geocoding.Placemark?> getAddressFromLatLan(
      double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      return null;
    } else {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        geocoding.Placemark currentPlacemark = placemarks.first;
        return currentPlacemark;
      }
    }
    return null;
  }

  static Future<LatLng> getCurrentLocation() async {
    final currentLocation = await location.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      return LatLng(
          currentLocation.latitude ?? 0.0, currentLocation.longitude ?? 0.0);
    } else {
      throw Exception('Unable to get current location');
    }
  }

  static Future<String> getFullAddress(
      double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      return '';
    } else {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        geocoding.Placemark? userLocation =
            await getAddressFromLatLan(latitude, longitude);

        if (userLocation == null) {
          return '';
        } else {
          String address =
              '${userLocation.street ?? ''}, ${userLocation.subLocality ?? ''}, ${userLocation.locality}, ${userLocation.administrativeArea ?? ''} - ${userLocation.postalCode}';
          return address;
        }
      } else {
        return '';
      }
    }
  }

  static Future<String> getPincode(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) {
      return '';
    } else {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        geocoding.Placemark? userLocation =
            await getAddressFromLatLan(latitude, longitude);

        if (userLocation == null) {
          return '';
        } else {
          String address = userLocation.postalCode ?? '';
          return address;
        }
      } else {
        return '';
      }
    }
  }
}
