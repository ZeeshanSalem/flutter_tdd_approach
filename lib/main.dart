import 'package:flutter/material.dart';
import 'package:games/core/utils/theme.dart';

import 'core/di/injection_container_common.dart';
import 'core/routing/routing.dart';
import 'core/shared_pref/prefrences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  PreferenceUtils.init();
  await initDI();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Game Deals',
      routerConfig: newRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
    );
  }
}
