import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';

class WelcomeAppBar extends AppBar {
  WelcomeAppBar({Key? key, required BuildContext context})
      : super(
            key: key,
            title: Text('Hoşgeldin', style: context.textTheme.displaySmall),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: context.colors.tertiary,
            ));
}
