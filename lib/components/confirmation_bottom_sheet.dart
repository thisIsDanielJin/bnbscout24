import 'package:flutter/material.dart';
import '../constants/constants.dart';

class ConfirmationBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Centered content row with constrained text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  'Booking Confirmed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorPalette.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 32,
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Centered button
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorPalette.primary,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 40,
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // Close bottom sheet
                Navigator.pop(context);
                Navigator.pop(context);// Go back to previous page
              },
              child: Text(
                'Go Back',
                style: TextStyle(
                  fontSize: 18,
                  color: ColorPalette.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}