import 'package:bnbscout24/constants/constants.dart';
import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String? hint;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool? readOnly;
  final Widget? suffixIcon;
  const TextInput({super.key, this.hint, this.keyboardType, this.controller, this.readOnly, this.suffixIcon});

  @override
  Widget build(BuildContext context) {  
    return TextField(
      readOnly: readOnly ?? false,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        fillColor: ColorPalette.lightGrey,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        hintText: hint,
      ),
    );
  }
}