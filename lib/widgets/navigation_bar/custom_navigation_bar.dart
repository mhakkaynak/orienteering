import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../core/extensions/context_extension.dart';

class CustomBottomNavigationBar extends Padding {
  CustomBottomNavigationBar({
    Key? key,
    required BuildContext context,
    required Function(int) onTabChange,
  }) : super(
            key: key,
            padding: EdgeInsets.symmetric(
                horizontal: context.lowWidthValue / 2,
                vertical: context.lowHeightValue / 2),
            child: GNav(
              tabBackgroundColor: context.theme.colorScheme.surfaceVariant,
              padding: context.paddingLowSymmetric,
              onTabChange: onTabChange,
              tabs: const [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'Ana Sayfa',
                ),
                GButton(
                  icon: Icons.add_box_outlined,
                  text: 'Yeni Oyun',
                ),
                GButton(
                  icon: Icons.account_box_outlined,
                  text: 'Profil',
                ),
              ],
            ));
}
