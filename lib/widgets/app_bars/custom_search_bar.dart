import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';

class CustomSearchBar extends Align {
  CustomSearchBar({
    Key? key,
    required BuildContext context,
    required VoidCallback onPressed,
    required Widget rightWidget,
  }) : super(
          key: key,
          alignment: Alignment.topCenter,
          child: InkWell(
            onTap: onPressed,
            radius: 120,
            splashColor: context.theme.primaryColor.withOpacity(0.2),
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(32),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.lowWidthValue,
              ),
              child: Container(
                height: context.lowHeightValue,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: context.colors.primaryContainer.withOpacity(0.5),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: onPressed,
                      icon: const Icon(Icons.search_outlined),
                    ),
                    Text(
                      'Ara',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(left: context.customWidthValue(0.57)),
                      child: rightWidget,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
}
