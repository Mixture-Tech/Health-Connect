class Schedule {
  Schedule({
    required this.doctorScheduleId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.workingDate,
      // required this.currentAppointment,
    required this.doctorName,
  });

  final String? doctorScheduleId;
  final String? dayOfWeek;
  final String startTime; // Format "HH:mm:ss"
  final String endTime; // Format "HH:mm:ss"
  final String? workingDate; // Format "yyyy-MM-dd"
  // final int currentAppointment;
  final String? doctorName;

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      doctorScheduleId: json["doctor_schedule_id"],
      dayOfWeek: json["day_of_week"],
      startTime: json["start_time"],
      endTime: json["end_time"],
      workingDate: json["working_date"],
      // currentAppointment: json["current_appointment"] ?? 0,
      doctorName: json["doctor_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "doctor_schedule_id": doctorScheduleId,
    "day_of_week": dayOfWeek,
    "start_time": startTime,
    "end_time": endTime,
    "working_date": workingDate,
    // "current_appointment": currentAppointment,
    "doctor_name": doctorName,
  };
}
