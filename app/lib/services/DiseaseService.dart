import 'package:app/services/BaseApiService.dart';

class DiseaseService {
  late final BaseApiService _apiService;

  // Factory constructor
  static Future<DiseaseService> create() async {
    final apiService = await BaseApiService.create();
    return DiseaseService._(apiService);
  }

  // Private constructor
  DiseaseService._(this._apiService);

  Future<List<Map<String, dynamic>>> getDiseaseBySpecialization(String specializationId) async {
    final response = await _apiService.get('/diseases/$specializationId');
    if (response['error_code'] == 'OK') {
      return List<Map<String, dynamic>>.from(response['data']);
    }
    throw Exception(response['message']);
  }
}