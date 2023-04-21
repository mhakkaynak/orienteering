import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';

class SecondaryColorContainer extends Container {
  SecondaryColorContainer(
      {Key? key, required BuildContext context, Widget? child})
      : super(
          key: key,
          width: context.width,
          decoration: BoxDecoration(
            color: context.colors.secondaryContainer,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Padding(
            padding: context.paddingNormalSymmetric,
            child: child,
          ),
        );
}
