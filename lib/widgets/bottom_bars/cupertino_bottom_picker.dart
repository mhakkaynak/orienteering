import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';

import '../../core/init/navigation/navigation_manager.dart';

class CupertinoBottomPicker extends CupertinoActionSheet {
  CupertinoBottomPicker({
    Key? key,
    required BuildContext context,
    required List<Widget> children,
    double itemExtent = 36,
    int initialItem = 0,
    double height = 0.16,
    bool looping = false,
    Function? cancelOnPressed,
    required Function(int) onSelectedItemChanged,
  }) : super(
          key: key,
          cancelButton: CupertinoActionSheetAction(
            child: const Text('İptal'),
            onPressed: () {
              if (cancelOnPressed != null) cancelOnPressed();
              NavigationManager.instance.navigationToPop();
            },
          ),
          actions: [
            SizedBox(
              width: context.width,
              height: context.customHeightValue(height),
              child: CupertinoPicker(
                looping: looping,
                backgroundColor: Colors.white,
                itemExtent: itemExtent,
                scrollController:
                    FixedExtentScrollController(initialItem: initialItem),
                onSelectedItemChanged: onSelectedItemChanged,
                children: children,
              ),
            )
          ],
        );
}
