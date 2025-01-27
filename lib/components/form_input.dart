import 'package:bnbscout24/constants/constants.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  final String label;
  final List<Widget> children;
  
  const FormInput({super.key, required this.label, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
          style: TextStyle(color: black,
          fontSize: 18
          ),
        ),
        Row(
          spacing: 8,
          children: children.map((i) => Expanded(child: i)).toList(),
        )
      ],
    );
  }
}