import 'package:flutter/material.dart';

class UserProfileImage extends CircleAvatar {
  UserProfileImage({
    Key? key,
    String? imagePath,
  }) : super(
          key: key,
          minRadius: 100,
          maxRadius: 100,
          backgroundColor: const Color(0XFFb3f39b),
          backgroundImage: NetworkImage(
            imagePath ?? 'https://picsum.photos/200/300',
          ),
        );
}
