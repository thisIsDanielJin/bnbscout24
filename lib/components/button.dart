import 'package:bnbscout24/constants/constants.dart';
import 'package:bnbscout24/constants/sizes.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const PrimaryButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        
        backgroundColor: ColorPalette.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        padding: EdgeInsets.all(Sizes.paddingBig),
        elevation: 0, // No shadow
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white, // White text
          fontSize: 16, 
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}