import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';
import 'package:app/styles/text.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  final Icon? prefixIcon; // Có thể truyền vào icon
  final Widget? suffixIcon; // Suffix icon

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false; // Biến để kiểm tra khi focus vào TextField

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: _isFocused
                  ? AppColors.accentBlue.withOpacity(0.5) // Khi chọn vào
                  : AppColors.grey.withOpacity(0.3), // Khi không chọn
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            labelText: widget.labelText,
            labelStyle: AppTextStyles.labelStyle,
            border: InputBorder.none, // Loại bỏ khung viền của TextField
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20,
            ),
          ),
        ),
      ),
    );
  }
}
