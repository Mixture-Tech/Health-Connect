import 'dart:convert';

import 'package:app/services/UserService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_response.dart';
import '../models/user.dart';

class StorageService {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  Future<void> saveAuthData(AuthenticationResponse response) async {
    await _prefs.setString(accessTokenKey, response.accessToken ?? '');

    if(response.refreshToken != null) {
      await _prefs.setString(refreshTokenKey, response.refreshToken!);
    }

    if(response.userData != null) {
      await _prefs.setString(userDataKey, jsonEncode(response.userData!.toJson()));
    }
  }
  Future<String?> getAccessToken() async {
    return _prefs.getString(accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return _prefs.getString(refreshTokenKey);
  }

  Future<UserData?> getUserDataFromToken() async {
    final token = await getAccessToken();
    if (token != null && !JwtDecoder.isExpired(token)) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final email = decodedToken['sub'];

      // Tạo một instance của UserService trong phương thức này
      final userService = await UserService.create();
      try {
        return await userService.getUserDataByEmail(email); // Gọi từ instance mới tạo
      } catch (e) {
        print('Error retrieving user data: $e');
        return null;
      }
    }
    return null;
  }




  Future<void> clearAuthData() async {
    await _prefs.remove(accessTokenKey);
    await _prefs.remove(refreshTokenKey);
    await _prefs.remove(userDataKey);
  }
}