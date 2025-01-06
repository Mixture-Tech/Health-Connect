import 'package:flutter/material.dart';
import '../../styles/colors.dart';
import '../../styles/text.dart';

class DoctorInfoWidget extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String date;
  final String time;
  final String price;

  const DoctorInfoWidget({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.all(16),
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(15),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.3),
        //     spreadRadius: 2,
        //     blurRadius: 5,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              imageUrl, // Use a placeholder image
              width: 100,
              height: 110,
              fit: BoxFit.cover,
              // errorBuilder: (context, error, stackTrace) {
              //   return Container(
              //     width: 100,
              //     height: 100,
              //     color: Colors.grey[300],
              //     child: Icon(Icons.person, color: Colors.grey[600]),
              //   );
              // },
            ),
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
                  date,
                  style: AppTextStyles.infoStyle,
                ),
                Text(
                  time,
                  style: AppTextStyles.infoStyle,
                ),
                Text(
                  'Giá khám: $price',
                  style: AppTextStyles.infoStyle,
                ),
                Text(
                  'Miễn phí đặt lịch',
                  style: AppTextStyles.infoStyle.copyWith(color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}