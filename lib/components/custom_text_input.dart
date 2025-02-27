import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final String? hint;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool readOnly;
  final int maxLines;
  final bool obscureText;
  final Widget? suffixIcon;

  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextInput(
      {super.key,
      this.hint,
      this.keyboardType,
      this.controller,
      this.readOnly = false,
      this.suffixIcon,
      this.onChanged,
      this.inputFormatters,
      this.maxLines = 1,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      readOnly: readOnly,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      obscureText: obscureText,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.all(Sizes.paddingRegular),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.borderRadius)),
        hintText: hint,
      ),
    );
  }
}
