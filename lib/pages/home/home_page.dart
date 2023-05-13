import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/pages/home/subpages/home_subpage.dart';
import 'package:orienteering/pages/user/user_page.dart';

import '../../widgets/navigation_bar/custom_navigation_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
          context: context, onTabChange: _onTabChange),
    );
  }

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
        return Center(
          child: Text('test2'),
        );
      case 2:
        return const UserPage();
      default:
        return const UserPage();
    }
  }
}
