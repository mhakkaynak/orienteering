import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';

class EnabledTextFormFieldButton extends GestureDetector {
  EnabledTextFormFieldButton(
      {Key? key,
      required BuildContext context,
      required String text,
      required IconData icon,
      required VoidCallback onTap})
      : super(
          key: key,
          onTap: onTap,
          child: TextFormField(
            enabled: false,
            decoration: InputDecoration(
              prefixIcon: Icon(icon),
              hintText: text,
              hintStyle: const TextStyle(color: Colors.black),
              prefixIconColor: Colors.black,
              fillColor: context.colors.surfaceVariant,
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
            ),
          ),
        );
}
