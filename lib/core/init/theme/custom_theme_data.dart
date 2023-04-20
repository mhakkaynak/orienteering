import 'package:flutter/material.dart';

class CustomThemeData {
  CustomThemeData._init();

  static CustomThemeData? _instance;

  final ColorScheme _colorScheme = const ColorScheme.light(
    primary: Color(0xFF326b23),
    onPrimary: Color(0xFFffffff),
    primaryContainer: Color(0XFFb3f39b),
    onPrimaryContainer: Color(0XFF022100),
    secondary: Color(0xFF54624d),
    onSecondary: Color(0xFFffffff),
    secondaryContainer: Color(0xFFd7e8cc),
    onSecondaryContainer: Color(0XFF121f0e),
    tertiary: Color(0xFF386668),
    onTertiary: Color(0xFFffffff),
    tertiaryContainer: Color(0xFFbcebed),
    onTertiaryContainer: Color(0xFF002021),
    error: Color(0xFFba1a1a),
    onError: Color(0xFFffffff),
    errorContainer: Color(0xFFffdad6),
    onErrorContainer: Color(0xFF410002),
    background: Color(0xFFfdfdf6),
    onBackground: Color(0xFF1a1c18),
    surface: Color(0xFFfdfdf6),
    onSurface: Color(0xFF1a1c18),
    outline: Color(0xFF73796e),
    surfaceVariant: Color(0xFFdfe4d7),
    onSurfaceVariant: Color(0xFF43483f),
  );

  static CustomThemeData get instance {
    _instance ??= CustomThemeData._init();
    return _instance!;
  }

  ThemeData get theme => ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: const Color(0xFF326b23),
        colorScheme: _colorScheme,
        textTheme: ThemeData.light().textTheme.copyWith(
              displaySmall: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: _colorScheme.tertiary,
              ),
              titleLarge: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              titleSmall: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: _colorScheme.onSecondaryContainer),
            ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
          ),
        ),
      );
}
