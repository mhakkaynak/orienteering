import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/extensions/context_extension.dart';

class ImageButton extends GestureDetector {
  ImageButton({
    Key? key,
    double? size,
    String? imagePath,
    Widget? child,
    Color? color,
    required BuildContext context,
    required VoidCallback onTap,
  }) : super(
          key: key,
          onTap: onTap,
          child: Container(
            height: size,
            width: size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color ??
                  (imagePath == null ? context.colors.primaryContainer : null),
              borderRadius: BorderRadius.circular(16),
            ),
            child: imagePath == null
                ? child ??
                    Text('Resim Ekle', style: context.textTheme.headlineSmall)
                : Image.file(
                    File(imagePath),
                    fit: BoxFit.cover,
                  ),
          ),
        );
}
