import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/app/app_constant.dart';
import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/init/navigation/navigation_manager.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  static const String _buttonText = 'Ana sayfaya dön';
  static const TextStyle _buttonTextStyle = TextStyle(fontSize: 16);

  Center _buildErrorImage(BuildContext context) => Center(
        child: SvgPicture.asset(
          AppConstant.errorIcon,
          height: context.customHeightValue(0.8),
          width: double.infinity,
        ),
      );

  SizedBox _buildButton(BuildContext context) => SizedBox(
        width: context.highWidthValue,
        child: ElevatedButton(
          onPressed: _onPressed,
          child: const Text(_buttonText, style: _buttonTextStyle),
        ),
      );

  void _onPressed() {
    NavigationManager.instance.navigationToPageClear(NavigationConstant.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.paddingLowSymmetric,
        child: Column(
          children: [
            _buildErrorImage(context),
            _buildButton(context),
          ],
        ),
      ),
    );
  }
}
