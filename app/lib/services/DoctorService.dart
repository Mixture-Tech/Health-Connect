import 'package:app/services/BaseApiService.dart';

class DoctorService {
  late final BaseApiService _apiService;

  // Factory constructor
  static Future<DoctorService> create() async {
    final apiService = await BaseApiService.create();
    return DoctorService._(apiService);
  }

  // Private constructor
  DoctorService._(this._apiService);

  Future<List<Map<String, dynamic>>> getDoctors() async {
    final response = await _apiService.get('/doctors');
    if (response['error_code'] == 'OK') {
      return List<Map<String, dynamic>>.from(response['data']);
    }
    throw Exception(response['message']);
  }
}







