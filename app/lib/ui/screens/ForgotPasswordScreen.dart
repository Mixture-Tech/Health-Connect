import 'package:app/models/auth_request.dart';
import 'package:app/services/AuthenticationService.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/widgets/ButtonWidget.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:app/utils/auth_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/widgets/TextFieldWidget.dart';
import 'package:app/styles/text.dart';
import 'package:app/ui/screens/LoginScreen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late AuthenticationService _authenticationService;

  @override
  void initState() {
    super.initState();
    _initializeAuthenticationService();
  }

  Future<void> _initializeAuthenticationService() async {
    _authenticationService = await AuthenticationService.create();
  }

  bool _isLoading = false;
  Future<void> _submitForgotPassword() async {

    final errors = AuthenticationValidator.validateForm(
      email: _emailController.text,
      isForgotPassword: true
    );

    if(errors.isNotEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AuthenticationValidator.getErrorMessage(errors)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try{
      final request = AuthenticationRequest(
        email: _emailController.text,
      );

      final response = await _authenticationService.forgotPassword(request);

      if(!mounted) return;

      if(response.errorCode.code == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu mới đã được gửi đến email của bạn'),
          ),
        );

        await Future.delayed(const Duration(seconds: 2));

        Navigator.pop(
          context,
          CupertinoPageRoute(builder: (context) => const LoginScreen()),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
          ),
        );
      }
    }
    catch(e){
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Có lỗi xảy ra, vui lòng thử lại sau'),
      //   ),
      // );
      throw e;
    }
    finally{
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
                Navigator.pop(
                  context,
                  CupertinoPageRoute(builder: (context) => const LoginScreen()), // Chuyển đến trang Profile
                );
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50),

                          // Tiêu đề
                          Text(
                            'Quên mật khẩu',
                            style: AppTextStyles.labelStyle.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                            child: Text(
                              'Để khôi phục mật khẩu, vui lòng nhập email đã đăng ký hoặc đăng nhập tài khoản.',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFieldWidget(
                            controller: _emailController,
                            hintText: 'Nhập email',
                            prefixIcon: Icons.mail,
                            isRequired: true,
                          ),

                          const SizedBox(height: 30),

                          // Nút Gửi
                          CustomElevatedButton(
                            text: 'Gửi',
                            onPressed: _isLoading ? null : _submitForgotPassword,
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
