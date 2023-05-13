import 'package:flutter/material.dart';

class SearchTextFormField extends TextFormField {
  SearchTextFormField(
      {Key? key,
      required TextEditingController controller,
      required VoidCallback cancelPressed})
      : super(
          key: key,
          controller: controller,
          decoration: InputDecoration(
            filled: false,
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
