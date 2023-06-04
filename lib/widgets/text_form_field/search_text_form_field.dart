import 'package:flutter/material.dart';

class SearchTextFormField extends TextFormField {
  SearchTextFormField(
      {Key? key,
      required Function(String) onChanged,
      required TextEditingController controller,
      required VoidCallback cancelPressed})
      : super(
          key: key,
          controller: controller,
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: false,
            hintText: 'Ara',
            enabledBorder: _inputBorder,
            focusedBorder: _inputBorder,
            suffixIcon: IconButton(
              onPressed: cancelPressed,
              icon: const Icon(Icons.close_outlined),
            ),
          ),
        );

  static const InputBorder _inputBorder =
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent));
}
