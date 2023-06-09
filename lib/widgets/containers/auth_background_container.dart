import 'package:flutter/material.dart';

import '../../core/constants/app/app_constant.dart';

class AuthBackgroundContainer extends Container {
  AuthBackgroundContainer({Key? key, String? image, Widget? child})
      : super(
          key: key,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(image ?? AppConstant.authBacground),
              fit: BoxFit.fill,
            ),
          ),
          child: child,
        );
}
