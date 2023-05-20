import 'package:flutter/material.dart';

import '../../core/extensions/context_extension.dart';

class GameContainer extends GestureDetector {
  GameContainer({
    Key? key,
    VoidCallback? onTap,
    required BuildContext context,
    required String dateText,
    required String titleText,
    required String locationText,
  }) : super(
          key: key,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              width: context.customWidthValue(0.64),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: context.colors.tertiaryContainer,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.customWidthValue(0.05),
                    vertical: context.customHeightValue(0.02)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 100, child: Placeholder()),
                    const SizedBox(height: 15),
                    Text(
                      dateText,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: context.colors.onTertiaryContainer),
                    ),
                    Text(
                      titleText,
                      style: context.textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      text: TextSpan(
                        children: [
                          const WidgetSpan(
                            child: Icon(
                              Icons.location_on_outlined,
                              size: 16,
                            ),
                          ),
                          TextSpan(
                            text: locationText,
                            style: context.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}
