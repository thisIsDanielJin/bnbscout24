import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final List<Widget> children;
  
  const FormInput({super.key, required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, Sizes.paddingRegular),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(color: ColorPalette.black,
          fontSize: 18,
          fontWeight: FontWeight.w600
          ),
        ),
        Row(
          spacing: 8,
          children: children.map((i) => Expanded(child: i)).toList(),
        )
      ],
    ));
  }
}