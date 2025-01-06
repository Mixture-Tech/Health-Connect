import 'package:app/models/appointment.dart';
import 'package:app/models/schedule.dart';
import 'package:app/models/user.dart';
import 'package:app/services/BaseApiService.dart';
import 'package:intl/intl.dart';

class AppointmentService {
  late final BaseApiService _apiService;

  static Future<AppointmentService> create() async {
    final apiService = await BaseApiService.create();
    return AppointmentService._(apiService);
  }

  AppointmentService._(this._apiService);

  Future<Appointment> createAppointment({
    required String doctorId,
    required Schedule schedule,
    required UserData user,
    required String type,
  }) async {
    try {
      print('Start Time: ${schedule.startTime}');
      print('End Time: ${schedule.endTime}');
      // Format dates and times
      final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
      final DateFormat timeFormatter = DateFormat('HH:mm:ss');

      print(user.dateOfBirth);
      print(user.gender);
      print(user.address);


      final response = await _apiService.post('/appointments/$doctorId', {
        'startTime': schedule.startTime, // Already in "HH:mm:ss" format
        'endTime': schedule.endTime, // Already in "HH:mm:ss" format
        'appointmentTakenDate': schedule.workingDate, // Already in "yyyy-MM-dd" format
        'patientName': user.username,
        'patientPhone': user.phone,
        'patientAddress': user.address,
        'patientDateOfBirth': user.dateOfBirth, // Already in "yyyy-MM-dd" format
        'patientGender': user.gender,
        'bookingType': type,
      });

      if (response['error_code'] == 'OK') {
        return Appointment.fromJson(response['data']);
      }
      throw Exception(response['message']);
    } catch (e) {
      print(e);
      // if (e is Map<String, dynamic>) {
      //   throw Exception(e['message'] ?? 'Unknown error occurred');
      // }
      if(e is Exception){
        throw e;
      }
      throw Exception('Failed to create appointment: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchAppointments() async {
    final response = await _apiService.get('/appointments');

    if (response['error_code'] == 'OK') {
      return List<Map<String, dynamic>>.from(response['data']);
    }

    // Kiểm tra mã lỗi để xử lý khi không có lịch hẹn
    if (response['error_code'] == 'APPOINTMENT_NOT_FOUND') {
      // Trả về danh sách rỗng thay vì ném lỗi
      return [];
    }

    // Ném lỗi chung cho các trường hợp khác
    throw Exception(response['message']);
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      final response = await _apiService.post(
        '/appointments/$appointmentId/cancel',
        {},
      );

      // Kiểm tra response có dữ liệu không
      if (response == null || response is! Map) {
        throw Exception('Empty or invalid response from server');
      }

      // Kiểm tra error_code
      if (response['error_code'] == 'OK') {
        print('Appointment cancelled successfully');
        // Có thể thêm callback để cập nhật UI nếu cần
        return;
      } else {
        // Nếu error_code không phải OK, ném exception với message từ server
        throw Exception(response['message'] ?? 'Unknown error occurred');
      }

    } catch (e) {
      // Xử lý các lỗi khác
      print('Error cancelling appointment: $e');
      throw Exception('Failed to cancel appointment: ${e.toString()}');
    }
  }



}