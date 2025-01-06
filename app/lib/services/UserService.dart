import 'dart:convert';
import 'package:app/models/user.dart';
import 'package:app/services/BaseApiService.dart';

class UserService {
  late final BaseApiService _apiService;

  // Factory constructor
  static Future<UserService> create() async {
    final apiService = await BaseApiService.create();
    return UserService._(apiService);
  }

  // Private constructor
  UserService._(this._apiService);

  Future<UserData?> getUserDataByEmail(String email) async{
    final response = await _apiService.get('/user/getUser/$email');
    if(response['error_code'] == 'OK'){
      return UserData.fromJson(response['data']);
    }
    throw Exception(response['message']);
  }

}