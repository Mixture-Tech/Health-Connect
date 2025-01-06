// import 'package:app/models/doctor.dart';
//
// class ErrorCodeAppointment {
//   ErrorCodeAppointment({
//     required this.errorCode,
//     required this.message,
//     required this.data,
//   });
//
//   final String? errorCode;
//   final String? message;
//   final List<Doctor> data;
//
//   factory ErrorCodeAppointment.fromJson(Map<String, dynamic> json){
//     return ErrorCodeAppointment(
//       errorCode: json["error_code"],
//       message: json["message"],
//       data: json["data"] == null ? [] : List<Doctor>.from(json["data"]!.map((x) => Doctor.fromJson(x))),
//     );
//   }
//
//   Map<String, dynamic> toJson() => {
//     "error_code": errorCode,
//     "message": message,
//     "data": data.map((x) => x?.toJson()).toList(),
//   };
//
// }