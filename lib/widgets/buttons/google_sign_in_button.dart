import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/extensions/context_extension.dart';

import '../../core/constants/app/app_constant.dart';

class GoogleSignInButton extends SizedBox {
  GoogleSignInButton({
    Key? key,
    required BuildContext context,
    required VoidCallback onPressed,
  }) : super(
            key: key,
            width: context.highWidthValue,
            height: context.lowHeightValue,
            child: FilledButton.icon(
              onPressed: onPressed,
              icon: SvgPicture.asset(
                AppConstant.googleIcon,
                height: 24,
                width: 24,
              ),
              label: const Text('Google ile giriş yap'),
            ));
}