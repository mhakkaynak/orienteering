import 'package:flutter/material.dart';

class CustomThemeData {
  CustomThemeData._init();

  static CustomThemeData? _instance;

  static CustomThemeData? get instance {
    _instance ??= CustomThemeData._init();
    return _instance;
  }

  ThemeData get theme => ThemeData.light(useMaterial3: true).copyWith();
}
