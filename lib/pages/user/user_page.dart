import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: context.lowHeightValue,
          left: context.lowWidthValue,
          right: context.lowWidthValue,
        ),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                minRadius: 75,
                maxRadius: 75,
                backgroundColor: Colors.black54,
              ),
            ),
            Text(
              'M. Halil Akkaynak',
              style:
                  context.textTheme.displaySmall?.copyWith(color: Colors.black),
            ),
            Container(
              height: context.customHeightValue(0.24),
              width: context.width,
              decoration: BoxDecoration(
                color: context.colors.secondaryContainer,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Padding(
                padding: context.paddingNormalSymmetric,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bilgi',
                      style: context.textTheme.titleLarge,
                    ),
                    Row(
                      children: [
                        // TODO: bu kısım duzenlenecek
                        Icon(Icons.android),
                        Text('Level:'),
                        Text('20'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
