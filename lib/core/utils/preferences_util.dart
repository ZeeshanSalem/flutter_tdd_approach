import 'package:shared_preferences/shared_preferences.dart';

import '../logger/app_logger.dart';

class PreferencesUtil {
  final SharedPreferences preferences;
  final AppLogger logger;

  PreferencesUtil({required this.preferences, required this.logger});

  getPreferencesData(String key) {
    return preferences.get(key) ?? "";
  }

   getPreferencesListData(String key) {
    return preferences.getStringList(key) ?? [];
  }

  getPreferencesDoubleData(String key) {
    return preferences.getDouble(key) ?? 0.0;
  }

  getPreferencesIntData(String key) {
    return preferences.getInt(key) ?? 0;
  }

  getBoolPreferencesData(String key) {
    return preferences.get(key) ?? false;
  }

  setPreferencesData(String key, String? value) {
    logger.i('$runtimeType   setPreferencesData KEY: $key');
    logger.i('$runtimeType   setPreferencesData VALUE: $value');
    preferences.setString(key, value ?? "");
  }

  setPreferencesListData(String key, List<String> value) {
    logger.i('$runtimeType   setPreferencesData KEY: $key');
    logger.i('$runtimeType   setPreferencesData VALUE: $value');
    preferences.setStringList(key, value);
  }

  setPreferencesDoubleData(String key, double? value) {
    logger.i('$runtimeType   setPreferencesDoubleData KEY: $key');
    logger.i('$runtimeType   setPreferencesDoubleData VALUE: $value');
    preferences.setDouble(key, value ?? 0.0);
  }

  setPreferencesIntData(String key, int? value) {
    logger.i('$runtimeType   setPreferencesDoubleData KEY: $key');
    logger.i('$runtimeType   setPreferencesDoubleData VALUE: $value');
    preferences.setInt(key, value ?? 0);
  }

  setBoolPreferencesData(String key, bool? value) {
    logger.i('$runtimeType   setBoolPreferencesData KEY: $key');
    logger.i('$runtimeType   setBoolPreferencesData VALUE: $value');
    preferences.setBool(key, value ?? false);
  }

  Future clearPreferencesData() async {
    await preferences.clear();
  }
}