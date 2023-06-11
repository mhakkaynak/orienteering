import 'package:flutter/material.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/extensions/string_extension.dart';
import '../../widgets/app_bars/welcome_app_bar.dart';
import '../../widgets/containers/auth_background_container.dart';

import '../../model/user/user_model.dart';
import '../../service/user/user_auth_service.dart';
import '../../widgets/snack_bars/error_snack_bar.dart';
import '../../widgets/text_form_field/email_text_form_field.dart';
import '../../widgets/text_form_field/password_text_form_field.dart';
import '../../widgets/text_form_field/user_name_text_form_field.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _registerText = 'Kaydol';
  final TextEditingController _userNameController = TextEditingController();
  final String _formatErrorText = 'Bilgileri belirtilen formatta giriniz.';

  Form _buildForm(BuildContext context) => Form(
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            UserNameTextFormField(
              controller: _userNameController,
            ),
            SizedBox(
              height: context.lowHeightValue * 0.5,
            ),
            EmailTextFormField(
              controller: _emailController,
            ),
            SizedBox(
              height: context.lowHeightValue * 0.5,
            ),
            PasswordTextFormField(
              controller: _passwordController,
            ),
          ],
        ),
      );

  _buildRegisterButton(BuildContext context) => SizedBox(
        width: context.highWidthValue,
        height: context.lowHeightValue,
        child: FilledButton(
          onPressed: () {
            _register(context);
          },
          child: Text(_registerText),
        ),
      );

  Future<void> _register(BuildContext context) async {
    if (_emailController.text.isValidEmail &&
        _passwordController.text.isValidPassword &&
        _userNameController.text.isValidUserName) {
      UserModel user = UserModel.register(
          userName: _userNameController.text,
          email: _emailController.text,
          password: _passwordController.text);
      String? text = await UserAuthService.instance.registerWithEmail(user);
      if (text != null && context.mounted) {
        _showError(context, text);
      }
    } else {
      _showError(context, _formatErrorText);
    }
  }

  void _showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(ErrorSnackBar(
      context: context,
      text: text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: WelcomeAppBar(
        context: context,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          AuthBackgroundContainer(),
          SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: context.paddingLowSymmetric,
                child: Column(
                  children: [
                    SizedBox(
                      height: context.normalHeightValue,
                    ),
                    SizedBox(
                      height: context.normalHeightValue * 0.6,
                    ),
                    _buildForm(context),
                    SizedBox(
                      height: context.lowHeightValue,
                    ),
                    _buildRegisterButton(context),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
