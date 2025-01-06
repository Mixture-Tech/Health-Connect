import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';

class TextChangePassword extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isRequired;
  final TextEditingController? controller;

  const TextChangePassword({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isRequired = false,
    this.controller,
  });

  @override
  _TextChangePasswordState createState() => _TextChangePasswordState();
}

class _TextChangePasswordState extends State<TextChangePassword> {
  bool _obscureText = true; // Initially hide the password

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: TextField(
              controller: widget.controller,
              obscureText: _obscureText, // Obscure text based on state
              style: TextStyle(
                color: AppColors.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: widget.hintText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey,
                      fontSize: 16,
                    ),
                    children: widget.isRequired
                        ? [
                      const TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppColors.red),
                      ),
                    ]
                        : [],
                  ),
                ),
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: AppColors.grey,
                  size: 22,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText; // Toggle visibility
                    });
                  },
                ),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}