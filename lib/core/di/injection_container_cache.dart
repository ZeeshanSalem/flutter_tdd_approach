import 'package:games/core/utils/preferences_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'injection_container_common.dart';

Future<void> initCacheDI() async {

  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator
      .registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  serviceLocator.registerLazySingleton<PreferencesUtil>(() => PreferencesUtil(
      preferences: sharedPreferences, logger: serviceLocator()));
}