import 'package:flutter/material.dart';

import '../../core/extensions/context_extension.dart';

class GameCard extends Padding {
  GameCard({
    Key? key,
    required BuildContext context,
    required String imagePath,
    required String title,
    required String description,
    required String location,
    required String date,
  }) : super(
          key: key,
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Container(
            height: context.normalHeightValue * 1.4,
            decoration: BoxDecoration(
              color: context.colors.tertiaryContainer,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.lowWidthValue * 1.4,
                  vertical: context.lowWidthValue * 1.4),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imagePath,
                          height: 110.0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: context.textTheme.titleSmall,
                            ),
                            Text(
                              description,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildRichText(
                          location, Icons.location_on_outlined, context),
                      _buildRichText(date, Icons.date_range_outlined, context),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );

  static RichText _buildRichText(
      String text, IconData icon, BuildContext context) {
    return RichText(
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Icon(
              icon,
              size: 16,
            ),
          ),
          TextSpan(
            text: text,
            style: context.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
