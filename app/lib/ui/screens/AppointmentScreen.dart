import 'package:app/models/doctor.dart';
import 'package:app/models/schedule.dart';
import 'package:app/services/DoctorService.dart';
import 'package:app/ui/screens/HomeScreen.dart';
import 'package:app/utils/date_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../styles/colors.dart';
import '../../styles/text.dart';
import '../widgets/ButtonWidget.dart';
import '../widgets/HeaderWidget.dart';
import '../widgets/NavigationBarWidget.dart';
import 'AppointmentDetailScreen.dart';

class AppointmentScreen extends StatefulWidget {
  final Doctor doctor;

  const AppointmentScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // final List<String> timeSlots = [
  //   "07:00 - 07:30", "07:30 - 08:00", "08:00 - 08:30", "08:30 - 09:00",
  //   "09:00 - 09:30", "09:30 - 10:00", "10:00 - 10:30", "10:30 - 11:00",
  //   "13:00 - 13:30", "13:30 - 14:00", "14:00 - 14:30", "14:30 - 15:00",
  //   "15:00 - 15:30", "15:30 - 16:00",
  // ];
  int selectedTimeSlotIndex = -1;
  String selectedDay = 'Monday';
  Schedule? selectedSchedule;

  // Map để chuyển đổi từ tiếng Anh sang tiếng Việt
  final Map<String, String> dayTranslations = {
    'Monday': 'Thứ 2',
    'Tuesday': 'Thứ 3',
    'Wednesday': 'Thứ 4',
    'Thursday': 'Thứ 5',
    'Friday': 'Thứ 6',
  };

  List<Schedule> getScheduleByDay(String dayOfWeek) {
    return widget.doctor.schedules
        .where((schedule) => schedule.dayOfWeek == dayOfWeek)
        .toList();
  }

  int getDateFromWorkingDate(String dayOfWeek){
    final schedule = widget.doctor.schedules
        .firstWhere((schedule) => schedule.dayOfWeek == dayOfWeek);
    if(schedule.workingDate != null){
      final date = DateTime.parse(schedule.workingDate!);
      return date.day;
    }
    return 0;
  }

  String getFormattedDateFromWorkingDate(String dayOfWeek) {
    final schedule = widget.doctor.schedules
        .firstWhere((schedule) => schedule.dayOfWeek == dayOfWeek);
    if (schedule.workingDate != null) {
      final date = DateTime.parse(schedule.workingDate!);
      // return '${date.day}/${date.month}';  // Trả về ngày/tháng
      return DateTimeUtils.formatDayMonth(date); // Trả về ngày/tháng/năm
    }
    return '';
  }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            HeaderWidget(
              isHomeScreen: false,
              onIconPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Hình nền
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Background_3.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Nội dung chính
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        // const Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        //   child: Row(
                        //     children: [
                        //       Icon(
                        //         Icons.home,
                        //         color: AppColors.primaryBlue,
                        //       ),
                        //       Text(
                        //         " / ",
                        //         style: TextStyle(
                        //           fontSize: 18,
                        //           color: Colors.grey,
                        //         ),
                        //       ),
                        //       Expanded(
                        //         child: Text(
                        //           "Đặt lịch khám bệnh",
                        //           style: AppTextStyles.subHeaderStyle,
                        //           textAlign: TextAlign.left,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   height: 0,
                        //   color: AppColors.primaryBlue,
                        //   width: double.infinity,
                        // ),
                        // const SizedBox(height: 10),
                        // Hình ảnh chiếm khoảng 45% màn hình
                        Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(widget.doctor.doctorImage ?? 'assets/images/bs2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Hộp thông tin lịch hẹn và thời gian đặt lịch
                        Transform.translate(
                          offset: Offset(0, -40),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 36, 16, 16), // Tăng padding top để tạo khoảng trống cho thông tin bác sĩ
                            // margin: EdgeInsets.only(top: -20), // Kéo container này lên để che phần dưới của thông tin bác sĩ
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(70),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                    "Ngày đặt lịch",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    'Monday',
                                    'Tuesday',
                                    'Wednesday',
                                    'Thursday',
                                    'Friday',
                                  ].map((day) {
                                    final formattedDate = getFormattedDateFromWorkingDate(day);
                                    return _buildDayButton(
                                      dayTranslations[day]!,
                                      formattedDate,
                                      isSelected: selectedDay == day,
                                      onPressed: () {
                                        setState(() {
                                          selectedDay = day;
                                          selectedTimeSlotIndex = -1;
                                          selectedSchedule = null;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                    "Thời gian đặt lịch",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    )
                                ),
                                const SizedBox(height: 10),

                                SizedBox(
                                  height: 220, // Bạn có thể điều chỉnh chiều cao này
                                  child: Wrap(
                                    spacing: 30, // Khoảng cách giữa các button theo chiều ngang
                                    runSpacing: 20, // Khoảng cách giữa các button theo chiều dọc
                                    children: getScheduleByDay(selectedDay).map((schedule) {
                                      final index = widget.doctor.schedules.indexOf(schedule);
                                      return _buildTimeButton(
                                        DateTimeUtils.formatScheduleTimeRange(schedule),
                                        index,
                                        schedule,
                                      );
                                    }).toList(),
                                  ),
                                ),

                                const SizedBox(height: 20),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    child: CustomElevatedButton(
                                      text: 'Tiếp theo',
                                      onPressed: selectedSchedule != null
                                          ? _navigateToAppointmentDetailScreen
                                          : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Thông tin bác sĩ đè lên ranh giới
                        Transform.translate(
                          offset: Offset(0, -620), // Di chuyển lên 40 pixel
                          child: Container(
                            // margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 50),
                                  child: Text(
                                    widget.doctor.doctorName ?? 'Unknown Doctor name',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text(
                                  widget.doctor.specializationName ?? 'Unknown Specialization name',
                                  style: TextStyle(fontSize: 14, color: AppColors.white)
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Thanh điều hướng
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayButton(String day, String formattedDate, {
    bool isSelected = false,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.secondaryYellow : AppColors.lightGrey,
          foregroundColor: isSelected ? AppColors.black : AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0)
      ),
      child: Text(
          "$day\n$formattedDate",  // Hiển thị ngày/tháng
          textAlign: TextAlign.center
      ),
    );
  }

  Widget _buildTimeButton(String time, int index, Schedule schedule) {
    bool isSelected = index == selectedTimeSlotIndex;
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedTimeSlotIndex = index;
          selectedSchedule = schedule;
        });
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? AppColors.secondaryYellow : AppColors
              .lightGrey,
          foregroundColor: AppColors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10)
      ),
      child: Text(
        time,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  void _navigateToAppointmentDetailScreen() {
    if (selectedSchedule != null) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => AppointmentDetailScreen(
            previousScreen: widget,
            doctorId: widget.doctor.doctorId!,
            schedule: selectedSchedule!,
            doctorName: widget.doctor.doctorName!,
            doctorImage: widget.doctor.doctorImage,
            price: '350.000 VNĐ',
          ),
        ),
      );
    }
  }
}