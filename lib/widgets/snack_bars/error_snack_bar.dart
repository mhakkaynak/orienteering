import 'package:flutter/material.dart';

import '../../core/extensions/context_extension.dart';

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({
    Key? key,
    required BuildContext context,
    String? text,
  }) : super(
            key: key,
            content: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
                color: context.theme?.colorScheme.error,
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    text ?? 'Hata',
                    style: TextStyle(
                      fontSize: 12,
                      color: context.theme?.colorScheme.onError,
                    ),
                  ),
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0);
}
