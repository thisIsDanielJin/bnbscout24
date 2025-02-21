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
        color: ColorPalette.lightGrey,
        child:  ButtonTheme(
          
          alignedDropdown: true,
          child: DropdownButton(
            borderRadius: BorderRadius.circular(Sizes.borderRadius),
            items: items,
            onChanged: onChanged,
            value: value,
            isExpanded: true,
      ),
          
        )
     
    )
    
    );
    
  }
}
