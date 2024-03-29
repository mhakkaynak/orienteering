import 'package:flutter/material.dart';

import '../init/theme/custom_theme_data.dart';

extension PaddingExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  double get height => mediaQuery.size.height;
  double get width => mediaQuery.size.width;

  double get lowHeightValue => height * 0.06;

  double get lowWidthValue => width * 0.03;

  double get normalHeightValue => height * 0.15;

  double get highWidthValue => width * 0.8;

  double customHeightValue(double size) => height * size;

  double customWidthValue(double size) => width * size;

  EdgeInsets get paddingLowSymmetric =>
      EdgeInsets.symmetric(horizontal: lowWidthValue, vertical: height * 0.01);

  EdgeInsets get paddingNormalSymmetric => EdgeInsets.symmetric(
      horizontal: lowWidthValue * 2.4, vertical: height * 0.024);
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => CustomThemeData.instance.theme;

  ColorScheme get colors => CustomThemeData.instance.theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;
}
