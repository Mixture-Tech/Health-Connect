import 'dart:convert';

import 'package:app/styles/colors.dart';
import 'package:app/styles/text.dart';
import 'package:app/ui/screens/PersonalInformationScreen.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:app/ui/screens/LoginScreen.dart';
import 'package:app/ui/widgets/NavigationBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/widgets/ProfileOptionWidget.dart';
import 'package:app/ui/screens/ChangePasswordScreen.dart';

import '../../models/user.dart';
import '../../services/StorageService.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  void _submitPersonalInfo() {
    // Xử lý thông tin cá nhân ở đây
  }

  String username = '';
  UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      final storageService = await StorageService.getInstance();
      _currentUser = await storageService.getUserDataFromToken();

      if (_currentUser != null) {
        setState(() {
          // Update fields with _currentUser data
          username = _currentUser?.username ?? '';
        });
      }
    } catch (e) {
      print('Error fetching user info: $e');
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
              isHomeScreen: true,
              onIconPressed: () {

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

                  // Thêm widget lên trên background
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 80),

                        // Hình đại diện và tên người dùng
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/images/Personal_Avatar.png"), // Thay backgroundColor bằng backgroundImage
                        ),
                        SizedBox(height: 10),
                        Text(
                          username.isEmpty ? 'Đang tải...' : username, // Kiểm tra nếu chưa có username thì hiển thị "Đang tải..."
                          style: AppTextStyles.labelStyle.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentBlue,
                          ),
                        ),
                        SizedBox(height: 80),

                        ProfileOptionWidget(
                          icon: Icons.person,
                          label: 'Thông tin cá nhân',
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(builder: (context) => const PersonalInfoScreen()),
                            );
                          },
                        ),
                        ProfileOptionWidget(
                          icon: Icons.vpn_key,
                          label: 'Đổi mật khẩu',
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(builder: (context) => const ChangePasswordScreen()),
                            );
                          },
                        ),
                        ProfileOptionWidget(
                          icon: Icons.logout,
                          label: 'Đăng xuất',
                          onTap: () {
                            // Xử lý khi người dùng bấm vào mục "Thông tin cá nhân"
                          },
                        ),
                      ],
                    ),
                  ),

                  // Navigation Bar ở dưới
                  // Align(
                  //   alignment: Alignment.bottomCenter,
                  //   child: NavigationBarWidget(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
