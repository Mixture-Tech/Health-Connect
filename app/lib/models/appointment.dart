import 'package:app/models/doctor.dart';
import 'package:app/models/schedule.dart';
import 'package:app/models/user.dart';

class Appointment{
  Appointment({
    this.startTime,
    this.endTime,
    this.takenDate,
    this.type,
    this.user,
    this.doctor,
    this.status,
    this.probableStartTime,
    this.actualEndTime,
    this.appointmentTakenDate,
    this.createdAt,
    this.doctorName,
    required this.id,
  });

  final String? startTime; // Format "HH:mm:ss"
  final String? endTime; // Format "HH:mm:ss"
  final String? takenDate; // Format "yyyy-MM-dd"
  final String? type;
  final UserData? user;
  final Doctor? doctor;
  final String? status;
  final String? probableStartTime; // Format "HH:mm:ss"
  final String? actualEndTime; // Format "HH:mm:ss"
  final String? appointmentTakenDate; // Format "yyyy-MM-dd"
  final String? createdAt;
  final String? doctorName;
  final String id;

  factory Appointment.fromJson(Map<String, dynamic> json) {
    try {
      // Thêm print để debug
      print('Parsing JSON: $json');
      print(json['doctor_name']); // Kiểm tra doctor_name

      return Appointment(
        id: json['appointment_id'].toString(),
        startTime: json['start_time']?.toString(),
        endTime: json['end_time']?.toString(),
        type: json['booking_type']?.toString(),
        user: json['user'] != null ? UserData(
          username: json['user']['username']?.toString(),
          phone: json['user']['phone']?.toString(),
          address: json['user']['address']?.toString(),
          dateOfBirth: json['user']['date_of_birth']?.toString(),
          gender: json['user']['gender']?.toString(),
          email: json['user']['email']?.toString(),
        ) : null,
        doctor: json['doctor'] != null ? Doctor(
          doctorId: json['doctor']['doctor_id']?.toString(),
          doctorName: json['doctor']['doctor_name']?.toString(),
          doctorDescription: json['doctor']['doctor_description']?.toString(),
          doctorImage: json['doctor']['doctor_image']?.toString(),
          schedules: json['doctor']['schedules'] == null ? [] :
          List<Schedule>.from((json['doctor']['schedules'] as List)
              .map((x) => Schedule.fromJson(x))),
          specializationName: json['doctor']['specialization_name']?.toString(),
        ) : null,
        status: json['status']?.toString(),
        probableStartTime: json['probable_start_time']?.toString(),
        actualEndTime: json['actual_end_time']?.toString(),
        appointmentTakenDate: json['taken_date']?.toString(),
        createdAt: json['created_at'],
        doctorName: json['doctor_name'],
      );
    } catch (e) {
      print('Error in fromJson: $json');
      print('Error details: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      // 'start_time': startTime,
      //       // 'end_time': endTime,
      //       // 'taken_date': takenDate,
      'type': type,
      'username': user?.username,
      'phone': user?.phone,
      'patientAddress': user?.address,
      'patientDateOfBirth': user?.dateOfBirth,
      'patientGender': user?.gender,
      'email': user?.email,
      'doctor_name': doctor?.doctorName,
      'status': status,
      'probable_start_time': probableStartTime,
      'actual_end_time': actualEndTime,
      'appointment_taken_date': appointmentTakenDate,
      'created_at': createdAt,
      'doctor_name': doctorName,
      'appointment_id': id,
    };
  }
}