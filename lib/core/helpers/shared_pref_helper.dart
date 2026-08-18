// ignore_for_file: type_literal_in_constant_pattern

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movix/core/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  SharedPrefHelper._();

  static late SharedPreferences _prefs;
  static late FlutterSecureStorage _secureStorage;

  static init() async {
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
  }

  static Future<void> setData({
    required String key,
    required dynamic value,
  }) async {
    switch (value.runtimeType) {
      case String:
        await _prefs.setString(key, value);
        break;
      case int:
        await _prefs.setInt(key, value);
        break;
      case bool:
        await _prefs.setBool(key, value);
        break;
      case double:
        await _prefs.setDouble(key, value);
        break;
      case const (List<String>):
        await _prefs.setStringList(key, value);
        break;
      default:
        return;
    }
  }

  static int? getInt({required String key}) {
    return _prefs.getInt(key) ?? 0;
  }

  static double? getDouble({required String key}) {
    return _prefs.getDouble(key) ?? 0.0;
  }

  static String? getString({required String key}) {
    return _prefs.getString(key) ?? '';
  }

  static bool? getBool({required String key}) {
    return _prefs.getBool(key) ?? false;
  }

  static List<String>? getStringList({required String key}) {
    return _prefs.getStringList(key) ?? [];
  }

  static removeData({required String key}) async {
    await _prefs.remove(key);
  }

  static clearAllData() async {
    await _prefs.clear();
  }

  static setSecuredString({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  static getSecuredString({required String key}) async {
    return await _secureStorage.read(key: key) ?? '';
  }

  static deleteSecureString({required String key}) async {
    return await _secureStorage.delete(key: key);
  }

  static clearAllSecuredData() async {
    await _secureStorage.deleteAll();
  }
}
