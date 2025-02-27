import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final ValueChanged<dynamic>? onChanged;
  final List<DropdownMenuItem<dynamic>>? items;
  final String? hint;
  final dynamic value;

  const CustomDropdown(
      {super.key, this.onChanged, this.items, this.hint, this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(Sizes.borderRadius),
        child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(Sizes.borderRadius)),
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                underline: SizedBox(),
                borderRadius: BorderRadius.circular(Sizes.borderRadius),
                items: items,
                onChanged: onChanged,
                value: value,
                isExpanded: true,
              ),
            )));
  }
}
