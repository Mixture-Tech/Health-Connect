import 'package:app/services/BaseApiService.dart';

class SpecializationService {
  late final BaseApiService _apiService;

  // Factory constructor
  static Future<SpecializationService> create() async {
    final apiService = await BaseApiService.create();
    return SpecializationService._(apiService);
  }

  // Private constructor
  SpecializationService._(this._apiService);

  Future<List<Map<String, dynamic>>> getSpecializations() async {
    final response = await _apiService.get('/specializations');
    if (response['error_code'] == 'OK') {
      return List<Map<String, dynamic>>.from(response['data']);
    }
    throw Exception(response['message']);
  }

  Future<List<Map<String, dynamic>>> getDoctorsBySpecialization(String specializationId) async {
    final response = await _apiService.get('/specializations/$specializationId');
    if (response['error_code'] == 'OK') {
      return List<Map<String, dynamic>>.from(response['data']);
    }
    throw Exception(response['message']);
  }
}