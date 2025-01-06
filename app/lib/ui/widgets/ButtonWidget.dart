import 'package:app/styles/text.dart';
import 'package:flutter/material.dart';

import '';
import '../../styles/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;


  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: AppTextStyles.buttonStyle,
      backgroundColor: AppColors.accentBlue,
      foregroundColor: Colors.white, // Or AppColors.white if you have it defined
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Padding
    );
    return ElevatedButton(
      style: style,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}