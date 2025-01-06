import 'package:app/models/auth_request.dart';
import 'package:app/services/AuthenticationService.dart';
import 'package:app/ui/screens/LoginScreen.dart';
import 'package:app/utils/auth_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/widgets/CustomtextAuthWidget.dart';
import '../widgets/ButtonWidget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
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

  Future<void> _register() async {
    final errors = AuthenticationValidator.validateForm(
      username: _usernameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
      isRegistration: true,
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
        username: _usernameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: 1
      );

      final response = await _authenticationService.register(request);

      if (!mounted) return;

      if(response.errorCode.code == 200){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đăng ký thành công. Vui lòng kiểm tra email để xác thực tài khoản.'),
          ),
        );

        // Đợi người dùng đọc thông báo
        await Future.delayed(const Duration(seconds: 2));

        if(!mounted) return;

        Navigator.pop(
          context,
          CupertinoPageRoute(builder: (context) => const LoginScreen()),
        );

      }else if (response.errorCode.code == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.errorCode.message),
          ),
        );
      }else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
          ),
        );
      }
    }
    catch(ex){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đăng ký thất bại'),
        ),
      );
      print(ex);
      throw ex;
    }
    finally{
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
                            'Đăng ký tài khoản',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accentBlue,
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                      //Tên người dùng
                      CustomTextField(controller: _usernameController,
                          labelText: 'Tên người dùng',
                          prefixIcon: Icon(Icons.person, color: AppColors.accentBlue),
                      ),
                      const SizedBox(height: 16),
                      
                      //Phone
                      CustomTextField(controller: _phoneController,
                          labelText: 'Số điện thoại',
                          prefixIcon: Icon(Icons.phone, color: AppColors.accentBlue),
                      ),
                      const SizedBox(height: 16),

                      // Email field
                      CustomTextField(controller: _emailController,
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email, color: AppColors.accentBlue),
                      ),
                      const SizedBox(height: 16),

                      // Password field
                      CustomTextField(controller: _passwordController,
                          labelText: 'Mật khẩu',
                          obscureText: _obscureText,
                          prefixIcon: Icon(Icons.lock, color: AppColors.accentBlue),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _obscureText ? Icons.visibility_off : Icons.visibility, color: AppColors.accentBlue
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                      ),
                      const SizedBox(height: 24),

                      // Register button
                      CustomElevatedButton(
                          text: 'Đăng ký',
                          onPressed: _isLoading ? null : _register,
                      ),

                      const SizedBox(height: 55),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Đã có tài khoản?',
                            style: TextStyle(
                              color: AppColors.accentBlue,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(
                                context,
                                CupertinoPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(left: 2),
                            ),
                            child: const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
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
