import 'package:app/models/auth_request.dart';
import 'package:app/services/AuthenticationService.dart';
import 'package:app/ui/screens/MainScreen.dart';
import 'package:app/ui/screens/RegisterScreen.dart';
import 'package:app/utils/auth_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/widgets/CustomtextAuthWidget.dart';
import '../widgets/ButtonWidget.dart';
import 'ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;
  late AuthenticationService _authenticationService;

  @override
  void initState() {
    super.initState();
    _initializeAuthenticationService();
  }

  Future<void> _initializeAuthenticationService() async {
    _authenticationService = await AuthenticationService.create();
  }

  Future<void> _login() async {
    final errors = AuthenticationValidator.validateForm(
        email: _emailController.text,
        password: _passwordController.text,
        isRegistration: false
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
          password: _passwordController.text
      );

        final response = await _authenticationService.authenticate(request);

      if (!mounted) return;

      if(response.errorCode.code == 200 && response.accessToken != null){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng nhập thành công'),
          ),
        );

        // Đợi người dùng đọc thông báo
        await Future.delayed(const Duration(seconds: 2));

        if(!mounted) return;

        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const MainScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
          ),
        );
      }
    }
    catch(ex){
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text('Đã xảy ra lỗi'),
      //   ),
      // );
      throw ex;
    }
    finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/Background_4.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo and Title
                      Column(
                        children: [
                          Image.asset(
                            'assets/images/Logo.png',
                            height: 200,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentBlue,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                      // Email field
                      CustomTextField(controller: _emailController,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: AppColors.accentBlue,),
                      ),
                      const SizedBox(height: 20),

                      // Password field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Mật khẩu',
                        obscureText: _obscureText, // Truyền giá trị _obscureText
                        prefixIcon: const Icon(Icons.lock, color: AppColors.accentBlue),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText ? Icons.visibility_off : Icons.visibility,
                            color: AppColors.accentBlue,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText; // Chuyển đổi trạng thái _obscureText
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 50),

                      // Login button
                     CustomElevatedButton(
                         text: 'Đăng nhập',
                         onPressed: _isLoading ? null : _login
                     ),//nút đăng nhập
                      const SizedBox(height: 130),

                      //chuyển trang đăng ký
                      TextButton(
                        onPressed: () {
                          // Hành động khi nhấn "Đăng ký"
                          Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => const RegisterScreen())
                          );
                        },
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(
                            color: AppColors.accentBlue,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => const ForgotPasswordScreen())
                          );
                          // Hành động khi nhấn "Quên mật khẩu"
                        },
                        child: const Text(
                          'Quên mật khẩu',
                          style: TextStyle(
                              color: AppColors.accentBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
