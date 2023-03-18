import 'package:flutter/material.dart';

import '../init/theme/custom_theme_data.dart';

extension PaddingExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double get lowHeightValue => height * 0.02;
  double get lowWidthValue => width * 0.03;

  double get normalHeightValue => height * 0.06;

  double get highWidthValue => width * 0.7;

  EdgeInsets get paddingLowSymmetric =>
      EdgeInsets.symmetric(horizontal: lowWidthValue, vertical: lowHeightValue);
}

extension ThemeExtension on BuildContext {
  ThemeData? get theme => CustomThemeData.instance?.theme;

  TextTheme? get textTheme => theme?.textTheme;
}
