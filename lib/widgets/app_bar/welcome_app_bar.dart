import 'package:flutter/material.dart';

class WelcomeAppBar extends AppBar {
  WelcomeAppBar({Key? key})
      : super(
          key: key,
          title: const Text('Hoşgeldin'),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        );
}
