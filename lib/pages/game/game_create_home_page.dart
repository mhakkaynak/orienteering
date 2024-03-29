import 'package:flutter/material.dart';
import '../../core/constants/navigation/navigation_constant.dart';
import '../../core/extensions/context_extension.dart';
import '../../core/init/navigation/navigation_manager.dart';

class GameCreateHomePage extends StatelessWidget {
  const GameCreateHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: context.paddingLowSymmetric,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Oluşturacağınız Oyun Tipini Seçiniz', style: context.textTheme.titleSmall),
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildContainer(context, 'Indoor', NavigationConstant.indoorCreateGame),
                const SizedBox(
                  width: 10,
                ),
                _buildContainer(context, 'Outdoor', NavigationConstant.outdoorMapPage),
              ],
            )
          ],
        ),
      ),
    );
  }

  GestureDetector _buildContainer(BuildContext context, String text, String route) {
    return GestureDetector(
      onTap: () {
        NavigationManager.instance.navigationToPage(route);
      },
      child: SizedBox(
        height: context.customWidthValue(0.42),
        width: context.customWidthValue(0.42),
        child: Container(
          decoration: BoxDecoration(
            color: context.colors.primaryContainer,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
