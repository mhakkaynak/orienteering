import 'package:flutter/material.dart';

import '../../core/extensions/string_extension.dart';

class UserNameTextFormField extends TextFormField {
  UserNameTextFormField({
    Key? key,
    TextEditingController? controller,
  }) : super(
          key: key,
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.supervised_user_circle_outlined),
            hintText: 'Kullanıcı Adı',
            labelText: 'Kullanıcı Adı',
          ),
          validator: (value) => value!.isNotEmpty && !value.isValidUserName
              ? 'Kullanıcı adı 3 harften küçük olamaz.'
              : null,
        );
}
