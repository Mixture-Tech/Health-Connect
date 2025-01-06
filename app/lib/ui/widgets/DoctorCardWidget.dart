import 'package:flutter/material.dart';
import '../../styles/colors.dart';
import '../../styles/text.dart';

class DoctorCardWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String facility;
  final String description;
  final VoidCallback onTap; // Thêm callback

  const DoctorCardWidget({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.facility,
    required this.description,
    required this.onTap, // Nhận callback trong constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell( // Thêm InkWell để xử lý sự kiện nhấn
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Sử dụng crossAxisAlignment.center để căn giữa
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imageUrl),
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: AppTextStyles.subHeaderStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Khoa: $facility',
                    style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    '$description',
                    style: AppTextStyles.infoStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
