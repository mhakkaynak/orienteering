import 'package:flutter/material.dart';
import '../game/game_create_home_page.dart';

import 'subpages/home_subpage.dart';
import '../user/user_page.dart';

import '../../widgets/navigation_bar/custom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  _onTabChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const HomeSubpage();
      case 1:
        return const GameCreateHomePage();
      case 2:
        return const UserPage();
      default:
        return const HomeSubpage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
          context: context, onTabChange: _onTabChange),
    );
  }
}
