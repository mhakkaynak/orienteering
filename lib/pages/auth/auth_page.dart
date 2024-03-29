import 'package:flutter/material.dart';
import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/init/navigation/navigation_manager.dart';
import '../../service/user/user_auth_service.dart';
import '../../widgets/buttons/google_sign_in_button.dart';
import '../../widgets/containers/auth_background_container.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  SizedBox _buildfilledButton(BuildContext context, String text, String path) =>
      SizedBox(
          width: context.highWidthValue,
          height: context.lowHeightValue,
          child: FilledButton(
              onPressed: () {
                NavigationManager.instance.navigationToPage(path);
              },
              child: Text(text)));

  void _googleSignIn() {
    UserAuthService.instance.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AuthBackgroundContainer(
          child: Padding(
            padding: context.paddingLowSymmetric,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildfilledButton(
                    context, 'Kayıt Ol', NavigationConstant.register),
                SizedBox(height: context.lowHeightValue),
                _buildfilledButton(
                    context, 'Giriş Yap', NavigationConstant.login),
                SizedBox(height: context.lowHeightValue),
                GoogleSignInButton(context: context, onPressed: _googleSignIn),
              ],
            ),
          ),
        ),
      );
}
