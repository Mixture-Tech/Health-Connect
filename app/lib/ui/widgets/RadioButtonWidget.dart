import 'package:app/styles/colors.dart';
import 'package:app/styles/text.dart';
import 'package:flutter/material.dart';

// Enum cho other_booking và self_booking
enum SingingCharacter { OTHER_BOOKING, SELF_BOOKING }

// Enum cho male và female
enum Gender { male, female }

// TypeSelectorWidget cho other_booking và self_booking
class TypeSelectorWidget extends StatelessWidget {
  final SingingCharacter character;
  final ValueChanged<SingingCharacter?> onChanged;

  const TypeSelectorWidget({
    super.key,
    required this.character,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Radio<SingingCharacter>(
          value: SingingCharacter.SELF_BOOKING,
          groupValue: character,
          activeColor: AppColors.primaryBlue,
          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            return states.contains(MaterialState.selected)
                ? AppColors.primaryBlue
                : AppColors.grey;
          }),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        GestureDetector(
          onTap: () => onChanged(SingingCharacter.SELF_BOOKING),
          child: const Text('Đặt cho bản thân'),
        ),
        const SizedBox(width: 20),
        Radio<SingingCharacter>(
          value: SingingCharacter.OTHER_BOOKING,
          groupValue: character,
          activeColor: AppColors.primaryBlue,
          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            return states.contains(MaterialState.selected)
                ? AppColors.primaryBlue
                : AppColors.grey;
          }),
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
        GestureDetector(
          onTap: () => onChanged(SingingCharacter.OTHER_BOOKING),
          child: const Text('Đặt cho người thân'),
        ),
      ],
    );
  }
}
// GenderSelectorWidget cho lựa chọn giới tính
class GenderSelectorWidget extends StatefulWidget {
  final Gender selectedGender;
  final ValueChanged<Gender> onChanged;
  final bool enabled;
  final bool readOnly;

  const GenderSelectorWidget({
    super.key,
    required this.selectedGender,
    required this.onChanged,
    this.enabled = true,
    this.readOnly = false,
  });

  @override
  _GenderSelectorWidgetState createState() => _GenderSelectorWidgetState();
}

class _GenderSelectorWidgetState extends State<GenderSelectorWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio<Gender>(
          value: Gender.male,
          groupValue: widget.selectedGender,
          activeColor: widget.enabled ? AppColors.primaryBlue : AppColors.grey.withOpacity(0.5),
          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (!widget.enabled) return AppColors.grey.withOpacity(0.5);
            return states.contains(MaterialState.selected)
                ? AppColors.primaryBlue
                : AppColors.grey;
          }),
          onChanged: widget.enabled && !widget.readOnly ? (Gender? value) {
            if (value != null) {
              widget.onChanged(value);
            }
          } : null,
        ),
        Text(
          'Nam',
          style: TextStyle(
            fontSize: 14,
            color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
          ),
        ),
        Radio<Gender>(
          value: Gender.female,
          groupValue: widget.selectedGender,
          activeColor: widget.enabled ? AppColors.primaryBlue : AppColors.grey.withOpacity(0.5),
          fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
            if (!widget.enabled) return AppColors.grey.withOpacity(0.5);
            return states.contains(MaterialState.selected)
                ? AppColors.primaryBlue
                : AppColors.grey;
          }),
          onChanged: widget.enabled && !widget.readOnly ? (Gender? value) {
            if (value != null) {
              widget.onChanged(value);
            }
          } : null,
        ),
        Text(
          'Nữ',
          style: TextStyle(
            fontSize: 14,
            color: widget.enabled ? AppColors.grey : AppColors.grey.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}