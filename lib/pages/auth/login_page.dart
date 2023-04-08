import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/core/extensions/string_extension.dart';
import 'package:orienteering/widgets/app_bar/welcome_app_bar.dart';

import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../service/user/user_service.dart';
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

  Align _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        child: Text(
          _forgotPasswordText,
          style: context.textTheme?.bodyMedium
              ?.copyWith(color: context.colors.primary),
        ),
        onTap: () {},
      ),
    );
  }

  Form _buildForm(BuildContext context) {
    return Form(
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
  }

  void _showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      context: context,
      text: text,
    ));
  }

  SizedBox _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: context.highWidthValue,
      height: context.lowHeightValue,
      child: FilledButton(
        onPressed: () {
          _loginOnPressed(context);
        },
        child: Text(_loginText),
      ),
    );
  }

  Future<void> _loginOnPressed(BuildContext context) async {
    if (_emailController.text.isValidEmail &&
        _passwordController.text.isValidPassword) {
      String? text = await UserService.instance
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WelcomeAppBar(),
      body: Padding(
        padding: context.paddingLowSymmetric,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Placeholder(
                fallbackHeight: 250,
                fallbackWidth: 150,
              ),
              SizedBox(
                height: context.normalHeightValue * 0.6,
              ),
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
  }
}
