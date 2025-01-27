import 'package:bnbscout24/constants/constants.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String? hint;

  const TextInput({super.key, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      decoration: InputDecoration(
        
        fillColor: lightGrey,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        hintText: hint,
      ),
    );
  }
}