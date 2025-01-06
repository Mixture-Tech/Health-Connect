import 'package:flutter/material.dart';
import 'package:app/styles/text.dart';
import 'package:app/styles/colors.dart';

class ProfileOptionWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileOptionWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(30), // Tạo bo tròn cho container
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3), // Màu và độ mờ của bóng
                spreadRadius: 2,
                blurRadius: 7, // Tăng độ blur cho giống hình
                offset: const Offset(0, 3), // Đặt vị trí bóng
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.accentBlue,
                size: 30,
              ),
              const SizedBox(width: 25), // Điều chỉnh khoảng cách giữa icon và text
              Text(
                label,
                style: AppTextStyles.labelStyle.copyWith(
                  fontSize: 18,
                  color: AppColors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
