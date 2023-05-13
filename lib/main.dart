import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'core/extensions/context_extension.dart';

import 'core/init/navigation/navigation_manager.dart';
import 'core/init/navigation/navigation_route_manager.dart';

Future<void> main() async {
  await _init();
  runApp(const MyApp());
}

Future<void> _init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: context.theme,
      navigatorKey: NavigationManager.instance.navigationKey,
      onGenerateRoute: (args) => NavigationRouteManager.instance?.generateRoute(args),
      initialRoute: '/',
    );
  }
}
