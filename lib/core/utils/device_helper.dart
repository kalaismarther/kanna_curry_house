import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DeviceHelper {
  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double statusbarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double bottombarHeight(BuildContext context) =>
      MediaQuery.of(context).padding.bottom + 10;

  static Future<Device> getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;

      return Device(
          id: iosInfo.identifierForVendor ?? '',
          type: 'IOS',
          name: iosInfo.name);
      // return Device(id: '1', type: 'IOS');
    } else {
      var androidInfo = await deviceInfoPlugin.androidInfo;

      return Device(
          id: androidInfo.id, type: 'ANDROID', name: androidInfo.brand);
      // return Device(id: '1', type: 'ANDROID');
    }
  }

  static Future<String> getFCM() async {
    final fcm = FirebaseMessaging.instance;
    String? token = await fcm.getToken();
    return token ?? '';
  }
}

class Device {
  final String id;
  final String type;
  final String name;

  Device({required this.id, required this.type, required this.name});
}
