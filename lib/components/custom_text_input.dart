import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextInput extends StatelessWidget {
  final String? hint;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final bool? readOnly;
  final int? maxLines;
  final Widget? suffixIcon;

  final ValueChanged<String>? onChanged; 
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextInput({super.key, this.hint, this.keyboardType, this.controller, this.readOnly, this.suffixIcon, this.onChanged, this.inputFormatters, this.maxLines});

  @override
  Widget build(BuildContext context) {  
    return TextField(
      maxLines: maxLines,
      readOnly: readOnly ?? false,
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,

        fillColor: ColorPalette.lightGrey,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(Sizes.borderRadius)
        ),
        hintText: hint,
      ),
    );
  }
}