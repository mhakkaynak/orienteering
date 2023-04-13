import 'package:flutter/material.dart';

import '../../core/extensions/string_extension.dart';

class EmailTextFormField extends TextFormField {
  EmailTextFormField({Key? key, TextEditingController? controller})
      : super(
          key: key,
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'Email',
            labelText: 'Email',
          ),
          validator: (value) => value!.isNotEmpty && !value.isValidEmail
              ? 'Geçerli bir e-posta adresi giriniz.'
              : null,
        );
}