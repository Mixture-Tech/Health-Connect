import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  // Kiểu cho tiêu đề chính
  static const TextStyle headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryBlue,
  );

  // Kiểu cho tiêu đề phụ
  static const TextStyle subHeaderStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryBlue,
  );

  // Kiểu cho nhãn trường nhập liệu
  static const TextStyle labelStyle = TextStyle(
    fontSize: 16,
    color: AppColors.grey,
  );

  // Kiểu cho văn bản nhập vào
  static const TextStyle inputStyle = TextStyle(
    fontSize: 16,
    color: AppColors.black,
  );

  // Kiểu cho văn bản gợi ý (placeholder)
  static const TextStyle hintStyle = TextStyle(
    fontSize: 16,
    color: AppColors.grey,
    fontStyle: FontStyle.italic,
  );

  // Kiểu cho văn bản lỗi
  static const TextStyle errorStyle = TextStyle(
    fontSize: 14,
    color: AppColors.red,
  );

  // Kiểu cho nút bấm
  static const TextStyle buttonStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // Kiểu cho văn bản thông tin
  static const TextStyle infoStyle = TextStyle(
    fontSize: 14,
    color: AppColors.black,
  );

  // Cách sử dụng

  /*
    import 'app_text_styles.dart';

    // Trong widget của bạn
    Text('Đặt lịch khám bệnh', style: AppTextStyles.headerStyle);

    TextField(
    decoration: InputDecoration(
    labelText: 'Họ tên bệnh nhân',
    labelStyle: AppTextStyles.labelStyle,
    hintText: 'Nhập họ và tên',
    hintStyle: AppTextStyles.hintStyle,
    errorStyle: AppTextStyles.errorStyle,
    ),
    style: AppTextStyles.inputStyle,
    );

    ElevatedButton(
    child: Text('Xác nhận', style: AppTextStyles.buttonStyle),
    onPressed: () {},
    );
  */
}