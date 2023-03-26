import 'package:flutter/material.dart';
import 'package:orienteering/core/constants/app/app_constant.dart';
import 'package:orienteering/core/constants/navigation/navigation_constant.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/core/init/navigation/navigation_manager.dart';
import 'package:orienteering/service/user/user_service.dart';
import 'package:orienteering/widgets/buttons/google_sign_in_button.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  SizedBox _buildfilledButton(BuildContext context, String text, String path) {
    return SizedBox(
        width: context.highWidthValue,
        height: context.lowHeightValue,
        child: FilledButton(
            onPressed: () {
              NavigationManager.instance.navigationToPage(path);
            },
            child: Text(text)));
  }

  void _googleSignIn() {
    UserService.instance.signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppConstant.authBacground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: context.paddingLowSymmetric,
          child: Column(
            children: [
              SizedBox(height: context.normalHeightValue),
              const Placeholder(fallbackHeight: 200),
              SizedBox(
                height: context.normalHeightValue,
              ),
              _buildfilledButton(
                  context, 'Kayıt Ol', NavigationConstant.register),
              SizedBox(height: context.customHeightValue(0.02)),
              _buildfilledButton(
                  context, 'Giriş Yap', NavigationConstant.login),
              SizedBox(height: context.customHeightValue(0.02)),
              GoogleSignInButton(context: context, onPressed: _googleSignIn),
            ],
          ),
        ),
      ),
    );
  }
}
