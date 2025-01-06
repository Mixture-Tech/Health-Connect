import 'package:app/models/auth_request.dart';
import 'package:app/services/AuthenticationService.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/widgets/ButtonWidget.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:app/utils/auth_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/widgets/TextChangePassword.dart';
import 'package:app/styles/text.dart';
import 'package:app/ui/screens/LoginScreen.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  Future<void> _submitChangePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Kiểm tra các trường nhập liệu
    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        // _errorMessage = 'Vui lòng nhập đầy đủ thông tin';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vui lòng nhập đầy đủ thông tin'),
          ),
        );
      });
      return;
    }

    // Kiểm tra mật khẩu mới và xác nhận mật khẩu
    if (newPassword != confirmPassword) {
      setState(() {
        // _errorMessage = ;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu mới chưa trùng khớp.'),
          ),
        );
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset error message
    });

    try {
      // Gọi service để đổi mật khẩu
      final authService = await AuthenticationService.create();
      final response = await authService.changePassword(currentPassword, newPassword);

      // Hiển thị thông báo thành công
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đổi mật khẩu thành công'),
        ),
      );

      // Reset các trường nhập liệu
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      // Xử lý lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mật khẩu cũ chưa đúng'),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            // Header
            HeaderWidget(
              isHomeScreen: false,
              onIconPressed: () {
                Navigator.pop(context, CupertinoPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background image
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Background_3.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 50),
                          // Icon tiêu đề
                          Icon(
                            Icons.lock_reset,
                            size: 80,
                          ),
                          const SizedBox(height: 20),
                          // Tiêu đề
                          Text(
                            'Thay đổi mật khẩu',
                            style: AppTextStyles.labelStyle.copyWith(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Text(
                              'Vui lòng nhập mật khẩu hiện tại và mật khẩu mới để tiếp tục.',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 30),
                          // Mật khẩu cũ
                          TextChangePassword(
                            controller: _currentPasswordController,
                            hintText: 'Nhập mật khẩu cũ',
                            prefixIcon: Icons.lock_outline,
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),
// New Password
                          TextChangePassword(
                            controller: _newPasswordController,
                            hintText: 'Nhập mật khẩu mới',
                            prefixIcon: Icons.lock,
                            isRequired: true,
                          ),
                          const SizedBox(height: 20),
                          TextChangePassword(
                            controller: _confirmPasswordController,
                            hintText: 'Xác nhận mật khẩu mới',
                            prefixIcon: Icons.lock,
                            isRequired: true,
                          ),
                          if (_errorMessage != null) // Hiện thông báo lỗi
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _errorMessage!,
                                style: TextStyle(color: Colors.red, fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 35),
                          CustomElevatedButton(
                            text: 'Cập nhật',
                            onPressed: _isLoading ? null : _submitChangePassword,
                          ),
                        ],
                      ),
                    ),
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
