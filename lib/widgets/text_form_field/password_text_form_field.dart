import 'package:flutter/material.dart';

import '../../core/extensions/string_extension.dart';

class PasswordTextFormField extends TextFormField {
  PasswordTextFormField({
    Key? key,
    TextEditingController? controller,
  }) : super(
            key: key,
            controller: controller,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.password_outlined),
              hintText: 'Parola',
              labelText: 'Parola',
            ),
            validator: (value) {
              if (value!.isNotEmpty) {
                if (value.length < 8) {
                  return 'Geçerli bir parola giriniz. (Parola 8 karekterden az olamaz.)';
                } else if (!value.isValidPassword) {
                  return 'Geçerli bir parola giriniz. (Büyük harf,\nküçük harf, rakam ve özel karakter içermelidir.)';
                }
              }
              return null;
            });
}
