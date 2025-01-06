import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';

class HeaderWidget extends StatelessWidget {
  final VoidCallback? onIconPressed;
  final bool isHomeScreen;

  const HeaderWidget({
    super.key,
    this.onIconPressed,
    this.isHomeScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColors.grey,
        //     spreadRadius: 1,
        //     blurRadius: 3,
        //     offset: Offset(0, 2),
        //   ),
        // ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/Logo.png',
                height: 55,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 9,
            child: IconButton(
              icon: Icon(isHomeScreen ? Icons.menu : Icons.arrow_back),
              onPressed: onIconPressed,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }
}