import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/services/AuthenticationService.dart';

class BaseApiService {
  late final AuthenticationService _authenticationService;

  // Factory constructor để khởi tạo BaseApiService
  static Future<BaseApiService> create() async {
    final authService = await AuthenticationService.create();
    return BaseApiService._(authService);
  }

  // Private constructor
  BaseApiService._(this._authenticationService);

  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _authenticationService.getAuthHeaders();
      final response = await http.get(
        Uri.parse('${AuthenticationService.baseUrl}$endpoint'),
        headers: headers,
      );

      if (response.statusCode == 401) {
        await _authenticationService.refreshToken();
        final newHeaders = await _authenticationService.getAuthHeaders();
        final newResponse = await http.get(
          Uri.parse('${AuthenticationService.baseUrl}$endpoint'),
          headers: newHeaders,
        );
        return _handleResponse(newResponse);
      }
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    try {
      final headers = await _authenticationService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('${AuthenticationService.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 401) {
        // Token expired, try to refresh
        await _authenticationService.refreshToken();
        // Retry request with new token
        final newHeaders = await _authenticationService.getAuthHeaders();
        final newResponse = await http.post(
          Uri.parse('${AuthenticationService.baseUrl}$endpoint'),
          headers: newHeaders,
          body: jsonEncode(body),
        );
        return _handleResponse(newResponse);
      }

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    return jsonDecode(utf8.decode(response.bodyBytes));
  }
}