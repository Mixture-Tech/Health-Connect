import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/styles/colors.dart';
import 'package:app/styles/text.dart';

class DatePickerTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isRequired;
  final String? helperText;
  final Function(DateTime)? onDateSelected;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;
  final DateTime? initialDate;

  const DatePickerTextField({
    Key? key,
    required this.hintText,
    required this.prefixIcon,
    this.isRequired = false,
    this.helperText,
    this.onDateSelected,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.initialDate,
  }) : super(key: key);

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    // Chỉ set text ban đầu nếu có initialDate
    if (widget.initialDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(widget.initialDate!);
    }
  }

  @override
  void didUpdateWidget(DatePickerTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Chỉ cập nhật text khi initialDate thay đổi và không null
    if (widget.initialDate != oldWidget.initialDate && widget.initialDate != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(widget.initialDate!);
    }
  }

  @override
  void dispose() {
    // Only dispose the controller if it wasn't provided externally
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    // Chỉ check readOnly, bỏ check enabled
    if (!widget.enabled) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

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
              readOnly: true,
              enabled: widget.enabled,
              onTap: () => _selectDate(context),
              style: AppTextStyles.labelStyle.copyWith(
                  color: widget.enabled ? Colors.black : AppColors.grey,
                  fontWeight: FontWeight.w500
              ),
              decoration: InputDecoration(
                hintText: null,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                label: RichText(
                  text: TextSpan(
                    text: widget.hintText,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                        fontSize: 16
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
                    color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
                    size: 22
                ),
                filled: true,
                fillColor: widget.enabled ? AppColors.white : AppColors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: widget.enabled ? AppColors.primaryBlue : AppColors.grey.withOpacity(0.5)),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              ),
            ),
          ),
        ),
        if (widget.helperText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 18),
            child: Text(
              widget.helperText!,
              style: TextStyle(
                  color: widget.enabled ? Colors.grey : Colors.grey.withOpacity(0.5),
                  fontSize: 12
              ),
            ),
          ),
      ],
    );
  }
}