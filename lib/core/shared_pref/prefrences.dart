import 'dart:async' show Future;
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    if (_prefsInstance == null) {
      _prefsInstance = await SharedPreferences.getInstance();
    } else {
      return _prefsInstance;
    }
    return null;
  }

}
