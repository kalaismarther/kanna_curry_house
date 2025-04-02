import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kanna_curry_house/model/user_model.dart';

class StorageHelper {
  static final storage = GetStorage();

  static Future<void> write(String keyName, dynamic value) async {
    await storage.write(keyName, value);
  }

  static read(String keyName) {
    return storage.read(keyName);
  }

  static Future<void> remove(String keyName) async {
    await storage.remove(keyName);
  }

  static Future<void> deleteAll() async {
    await storage.erase();
  }

  static UserModel getUserDetail() {
    final userDetail = read('user');
    debugPrint(userDetail.toString());
    return UserModel.fromJson(userDetail ?? {});
  }
}
