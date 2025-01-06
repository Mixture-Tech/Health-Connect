import 'package:app/models/schedule.dart';

class Doctor {
  Doctor({
    required this.doctorId,
    required this.doctorName,
    required this.doctorDescription,
    required this.doctorImage,
    required this.schedules,
    required this.specializationName,
  });

  final String? doctorId;
  final String? doctorName;
  final dynamic doctorDescription;
  final dynamic doctorImage;
  final List<Schedule> schedules;
  final String? specializationName;

  factory Doctor.fromJson(Map<String, dynamic> json){
    return Doctor(
      doctorId: json["doctor_id"],
      doctorName: json["doctor_name"],
      doctorDescription: json["doctor_description"],
      doctorImage: json["doctor_image"],
      schedules: json["schedules"] == null ? [] : List<Schedule>.from(json["schedules"]!.map((x) => Schedule.fromJson(x))),
      specializationName: json["specialization_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "doctor_id": doctorId,
    "doctor_name": doctorName,
    "doctor_description": doctorDescription,
    "doctor_image": doctorImage,
    "schedules": schedules.map((x) => x?.toJson()).toList(),
    "specialization_name": specializationName,
  };

}