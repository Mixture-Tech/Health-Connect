import 'dart:convert';
import 'package:app/models/auth_request.dart';
import 'package:app/models/auth_response.dart';
import 'package:app/services/StorageService.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService{
  static String baseUrl = dotenv.env['BASE_URL_API'] ?? '';
  final StorageService _storageService;
  final http.Client _httpClient;

  // Factory constructor để khởi tạo AuthenticationService
  static Future<AuthenticationService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthenticationService._(
      storageService: StorageService(prefs),
      httpClient: http.Client(),
    );
  }

  AuthenticationService._({
    required StorageService storageService,
    required http.Client httpClient,
  }) : _storageService = storageService,
        _httpClient = httpClient;

  Future<bool> isAuthenticated() async {
    final token = await _storageService.getAccessToken();
    return token != null;
  }

  Future<AuthenticationResponse> register(AuthenticationRequest request) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: await _getBasicHeaders(),
        body: jsonEncode(request.toJson()),
      );
      print("RESPONSE: " + response.body);

      return _handleAuthResponse(response);
    } catch (e) {
      throw Exception('Failed to register: $e');
    }
  }

  Future<AuthenticationResponse> authenticate(AuthenticationRequest request) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/authenticate'),
        headers: await _getBasicHeaders(),
        body: jsonEncode(request.toJson()),
      );

      final authResponse = _handleAuthResponse(response);
      await _storageService.saveAuthData(authResponse);
      return authResponse;
    } catch (e) {
      throw Exception('Failed to authenticate: $e');
    }
  }

  Future<AuthenticationResponse> forgotPassword(AuthenticationRequest request) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/forgot-password'),
        headers: await _getBasicHeaders(),
        body: jsonEncode(request.toJson()),
      );

      return _handleAuthResponse(response);
    } catch (e) {
      throw Exception('Failed to process forgot password request: $e');
    }
  }

  Future<AuthenticationResponse> refreshToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if(refreshToken == null) {
        throw Exception('No refresh token available');
      }

      final response = await _httpClient.post(
        Uri.parse('$baseUrl/auth/refresh-token'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      final authResponse = _handleAuthResponse(response);
      await _storageService.saveAuthData(authResponse);
      return authResponse;
    } catch (e) {
      throw Exception('Failed to refresh token: $e');
    }
  }

  Future<void> logout() async {
    try {
      final token = await _storageService.getAccessToken();
      if(token != null) {
        await _httpClient.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: await getAuthHeaders(),
        );
      }
    } catch (e) {
      print('Error during logout: $e');
    } finally {
      await _storageService.clearAuthData();
    }
  }

  // Helper methods
  Future<Map<String, String>> _getBasicHeaders() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  Future<Map<String, String>> getAuthHeaders() async {
    final token = await _storageService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  AuthenticationResponse _handleAuthResponse(http.Response response) {
    final responseData = jsonDecode(utf8.decode(response.bodyBytes));
    // print("RESPONSE: " + responseData);
    return AuthenticationResponse.fromJson(responseData);
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    final token = await _storageService.getAccessToken();
    final url = Uri.parse('$baseUrl/auth/change-password');

    try {
      final response = await _httpClient.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Xử lý nếu thành công (ví dụ: hiển thị thông báo thành công cho người dùng)
        print('Password changed successfully');
      } else {
        // Xử lý nếu gặp lỗi
        print('Failed to change password: ${response.body}');
        throw Exception('Failed to change password');
      }
    } catch (e) {
      // Xử lý lỗi mạng hoặc lỗi khác
      print('Error changing password: $e');
      throw Exception('Error changing password');
    }
  }


}