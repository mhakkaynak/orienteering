import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orienteering/core/extensions/context_extension.dart';
import 'package:orienteering/widgets/text_form_field/user_name_text_form_field.dart';
// TODO: devam et
class UserEditPage extends StatelessWidget {
  UserEditPage({super.key});
  final GlobalKey _textFormFieldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Düzenle'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.check_outlined),
            )
          ],
        ),
        body: Padding(
          padding: context.paddingLowSymmetric,
          child: ListView(
            children: [
              CircleAvatar(
                minRadius: 75,
                maxRadius: 75,
                backgroundColor: Colors.black54,
              ),
              UserNameTextFormField(key: _textFormFieldKey),
              SizedBox(height: 32),
              GestureDetector(
                onTap: () {},
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    hintText: 'Kredi: 100',
                    fillColor: context.colors.surfaceVariant,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.monetization_on_outlined),
                  suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                  hintText: 'Cinsiyet: Erkek',
                  fillColor: context.colors.surfaceVariant,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                      context: context,
                      builder: (_) => SizedBox(
                            width: context.width,
                            height: context.customHeightValue(0.4),
                            child: CupertinoPicker(
                                looping: true,
                                backgroundColor: context.colors.surfaceVariant,
                                itemExtent: 30,
                                scrollController:
                                    FixedExtentScrollController(initialItem: 1),
                                onSelectedItemChanged: (int value) {},
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text('Sivas'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text('bursa'),
                                  ),
                                ]),
                          ));
                },
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.monetization_on_outlined),
                    suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
                    hintText: 'Şehir: Sivas',
                    fillColor: context.colors.surfaceVariant,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
