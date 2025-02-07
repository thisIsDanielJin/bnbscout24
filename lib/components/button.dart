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
        padding: EdgeInsets.symmetric(
            vertical: Sizes.paddingRegular, horizontal: Sizes.paddingBig),
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

class SquareArrowButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const SquareArrowButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorPalette.lightGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.fromLTRB(Sizes.paddingBig, Sizes.paddingRegular,
              Sizes.paddingRegular, Sizes.paddingRegular),
          elevation: 0, // No shadow
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black, size: 40)
          ],
        ));
  }
}
