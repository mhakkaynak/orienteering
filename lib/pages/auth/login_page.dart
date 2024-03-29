import 'package:flutter/material.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/extensions/string_extension.dart';
import '../../widgets/app_bars/welcome_app_bar.dart';
import '../../widgets/containers/auth_background_container.dart';

import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../service/user/user_auth_service.dart';
import '../../widgets/snack_bars/error_snack_bar.dart';
import '../../widgets/text_form_field/email_text_form_field.dart';
import '../../widgets/text_form_field/password_text_form_field.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final String _forgotPasswordText = 'Parolanızı mı unuttunuz?';
  final String _formatErrorText = 'Bilgileri belirtilen formatta giriniz.';
  final String _loginText = 'Giriş Yap';
  final TextEditingController _passwordController = TextEditingController();

  Align _buildForgotPasswordButton(BuildContext context) => Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          child: Text(
            _forgotPasswordText,
            style: context.textTheme.bodyMedium
                ?.copyWith(color: context.colors.primaryContainer),
          ),
          onTap: () {},
        ),
      );

  Form _buildForm(BuildContext context) => Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            EmailTextFormField(
              controller: _emailController,
            ),
            SizedBox(
              height: context.lowHeightValue,
            ),
            PasswordTextFormField(
              controller: _passwordController,
            ),
          ],
        ),
      );

  void _showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      context: context,
      text: text,
    ));
  }

  SizedBox _buildLoginButton(BuildContext context) => SizedBox(
        width: context.highWidthValue,
        height: context.lowHeightValue,
        child: FilledButton(
          onPressed: () {
            _loginOnPressed(context);
          },
          child: Text(_loginText),
        ),
      );

  Future<void> _loginOnPressed(BuildContext context) async {
    if (_emailController.text.isValidEmail &&
        _passwordController.text.isValidPassword) {
      String? text = await UserAuthService.instance
          .signInWithEmail(_emailController.text, _passwordController.text);
      if (text != null && context.mounted) {
        _showError(context, text);
      } else {
        NavigationManager.instance
            .navigationToPageClear(NavigationConstant.home);
      }
    } else {
      _showError(context, _formatErrorText);
    }
  }

  Center _buildBody(BuildContext context) => Center(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: context.paddingLowSymmetric,
            child: Column(
              children: [
                _buildForm(context),
                const SizedBox(height: 16),
                _buildForgotPasswordButton(context),
                SizedBox(height: context.normalHeightValue * 0.5),
                _buildLoginButton(context),
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: WelcomeAppBar(
          context: context,
        ),
        body: Stack(
          children: [
            AuthBackgroundContainer(),
            _buildBody(context),
          ],
        ),
      );
}
