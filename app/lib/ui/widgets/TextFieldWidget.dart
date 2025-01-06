import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';
import 'package:app/styles/text.dart';

class TextFieldWidget extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isRequired;
  final String? helperText;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;

  const TextFieldWidget({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isRequired = false,
    this.helperText,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
  });

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
              controller: controller,
              enabled: enabled,
              readOnly: readOnly,
              style: TextStyle(
                color: enabled ? AppColors.black : AppColors.grey,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                label: RichText(
                  text: TextSpan(
                    text: hintText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                      fontSize: 16,
                    ),
                    children: isRequired
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
                    prefixIcon,
                    color: enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                    size: 22
                ),
                filled: true,
                fillColor: enabled ? AppColors.white : const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: AppColors.grey.withOpacity(0.5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryBlue),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
        ),
        if (helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 18),
            child: Text(
              helperText!,
              style: TextStyle(
                  color: enabled ? Colors.grey : Colors.grey.withOpacity(0.5),
                  fontSize: 12
              ),
            ),
          ),
      ],
    );
  }
}