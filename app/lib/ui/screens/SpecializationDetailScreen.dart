import 'package:app/models/disease.dart';
import 'package:app/models/doctor.dart';
import 'package:app/models/schedule.dart';
import 'package:app/services/SpecializationService.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/screens/AppointmentDetailScreen.dart';
import 'package:app/ui/screens/AppointmentScreen.dart';
import 'package:app/ui/screens/HomeScreen.dart';
import 'package:app/ui/screens/SpecializationScreen.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:app/utils/date_time.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/DiseaseService.dart';
import '../widgets/NavigationBarWidget.dart';

class SpecializationDetailScreen extends StatefulWidget {
  final String specializationId;
  final String specializationName;
  // final String specializationImage;

  const SpecializationDetailScreen({
    super.key,
    required this.specializationId,
    required this.specializationName,
    // required this.specializationImage
  });

  @override
  State<SpecializationDetailScreen> createState() => _SpecializationDetailScreenState();
}

class _SpecializationDetailScreenState extends State<SpecializationDetailScreen> {
  String selectedLocation = 'Toàn quốc';
  Map<String, DateTime> selectedDates = {};
  String? selectedTimeSlot;

  final List<String> locations = ['Toàn quốc', 'Hà Nội', 'TP. Hồ Chí Minh', 'Đà Nẵng', 'Cần Thơ'];
  List<Doctor> doctors = [];
  List<Disease> diseases = [];

  late Future<SpecializationService> _specializationService;
  late Future<DiseaseService> _diseaseService;

  bool isLoading = true;
  bool isExpanded = false;
  String? error;

  @override
  void initState(){
    super.initState();
    _initializeServices();
    _loadData();
  }

  void _initializeServices() {
    _specializationService = SpecializationService.create();
    _diseaseService = DiseaseService.create();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadDoctors(),
      _loadDisease()
    ]);
  }

  Future<void> _loadDoctors() async {
    try {
      setState(() => isLoading = true);

      final specializationService = await _specializationService;
      final doctorsData = await specializationService.getDoctorsBySpecialization(widget.specializationId);

      setState(() {
        doctors = doctorsData.map((data) => Doctor.fromJson(data)).toList();
        isLoading = false;
      });
    } catch (e) {
      _handleError('Không thể tải danh sách bác sĩ: $e');
    }
  }

  Future<void> _loadDisease() async {
    try {
      final diseaseService = await _diseaseService;
      final diseasesData = await diseaseService.getDiseaseBySpecialization(widget.specializationId);

      setState(() {
        diseases = diseasesData.map((data) => Disease.fromJson(data)).toList();
      });
    } catch (e) {
      _handleError('Không thể tải danh sách bệnh: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      error = message;
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 65,
              child: HeaderWidget(
                isHomeScreen: false,
                onIconPressed: () {
                  Navigator.of(context).pop(
                    CupertinoPageRoute(builder: (context) => const SpecializationScreen()),
                  );
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.specializationName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Danh sách các bác sĩ uy tín đầu ngành ${widget.specializationName} tại Việt Nam:',
                        style: TextStyle(fontSize: 14),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• Các chuyên gia có quá trình đào tạo bài bản, nhiều kinh nghiệm'),
                          const Text('• Các giáo sư, phó giáo sư đang trực tiếp nghiên cứu và giảng dạy tại các trường Đại học Y Khoa nổi tiếng ở Hà Nội và TP.HCM'),
                          const Text('• Các bác sĩ đã, đang công tác tại các bệnh viện hàng đầu'),
                          if(isExpanded) ... [
                            if(isLoading) 
                              const CircularProgressIndicator()
                            else if(error != null) 
                              Text(error!, style: const TextStyle(color: AppColors.red))
                            else if(diseases.isEmpty)
                              const Text('Không có bệnh nào trong chuyên khoa này')
                            else ...[
                              const SizedBox(height: 10),
                              Text(
                                  'Bệnh ${widget.specializationName}: ',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                              ),
                                  const SizedBox(height: 5),
                                  ...diseases.map((disease) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4.0),
                                      child: Text('• ${disease.name}'),
                                  )).toList(),
                                ]
  
                          ],
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded = !isExpanded;
                          });
                        },
                        child: Text(
                          isExpanded ? 'Thu gọn' : 'Xem thêm',
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DropdownButton<String>(
                        value: selectedLocation,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 6,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                        underline: Container(
                          height: 2,
                          color: Colors.blue,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                          });
                        },
                        items: locations.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      ...doctors.map((doctor) => _buildDoctorCard(doctor)).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // bottomNavigationBar: Container(
        //   height: 70,
        //   child: const NavigationBarWidget(),
        // ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime){
    return DateTimeUtils.formatDate(dateTime);
  }

  String formatTimeSlot(Schedule schedule) {
    return DateTimeUtils.formatScheduleTimeRange(schedule);
  }

  List<DateTime> getAvailableDates(Doctor doctor) {
    // Convert string dates to DateTime objects
    List<DateTime> dates = doctor.schedules.map((schedule) {
      if (schedule.workingDate == null) return DateTime.now();
      return DateFormat('yyyy-MM-dd').parse(schedule.workingDate!);
    }).toSet().toList();

    // Sort the dates
    dates.sort();
    return dates;
  }

  List<Schedule> getTimeSlotsByDate(Doctor doctor, DateTime date) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return doctor.schedules.where((schedule) =>
      schedule.workingDate == formattedDate
    ).toList();
  }

  Widget _buildDoctorCard(Doctor doctor){
    if(!selectedDates.containsKey(doctor.doctorId)){
      List<DateTime> availableDates = getAvailableDates(doctor);
      if(availableDates.isNotEmpty){
        selectedDates[doctor.doctorId ?? ''] = availableDates.first;
      }
    }

    List<DateTime> availableDates = getAvailableDates(doctor);

    if(isLoading){
      return const Center(child: CircularProgressIndicator());
    }

    if(error != null){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: AppColors.red)),
            ElevatedButton(
              onPressed: _loadDoctors,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if(doctors.isEmpty){
      return const Center(
        child: Text('Không có bác sĩ nào trong chuyên khoa này'),
      );
    }
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(doctor.doctorImage ?? 'assets/images/doctor.png'),
              ),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.doctorName ?? 'NO NAME DOCTOR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      doctor.doctorDescription ?? 'NO DESCRIPTION',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Nguyên Phó Giám đốc Bệnh viện E',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if(availableDates.isNotEmpty) ...[
                DropdownButton<DateTime>(
                  value: selectedDates[doctor.doctorId ?? ''],
                  icon: const Icon(Icons.arrow_drop_down),
                  elevation: 16,
                  style: const TextStyle(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  underline: Container(
                    height: 2,
                    color: AppColors.primaryBlue,
                  ),
                  onChanged: (DateTime? newValue) {
                    setState(() {
                      if(newValue != null){
                        selectedDates[doctor.doctorId ?? ''] = newValue;
                      }
                    });
                  },
                  items: availableDates.map<DropdownMenuItem<DateTime>>((DateTime date) {
                    return DropdownMenuItem<DateTime>(
                      value: date,
                      child: Text(formatDateTime(date)),
                    );
                  }).toList(),
                ),
              ],
              ],
          ),
          const Divider(),
          const Row(
            children: [
              Icon(
                Icons.calendar_month,
              ),
              Text(
                'LỊCH KHÁM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: getTimeSlotsByDate(doctor, selectedDates[doctor.doctorId ?? ''] ?? DateTime.now()).map((schedule) {
                // String timeSlot = '${schedule.startTime} - ${schedule.endTime}';
                String timeSlot = formatTimeSlot(schedule);
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedTimeSlot = timeSlot;
                      });
                      Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => AppointmentDetailScreen(
                              previousScreen: widget,
                              doctorId: doctor.doctorId ?? '', // Truyền ID của bác sĩ
                              schedule: schedule, // Truyền lịch đã chọn
                              doctorName: doctor.doctorName ?? 'NO NAME DOCTOR', // Truyền tên bác sĩ
                              doctorImage: doctor.doctorImage, // Truyền ảnh bác sĩ
                              price: '350.000đ',
                            )
                          )
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: selectedTimeSlot == timeSlot
                          ? AppColors.primaryBlue.withOpacity(0.1)
                          : Colors.white,
                      side: BorderSide(
                        color: selectedTimeSlot == timeSlot
                            ? AppColors.primaryBlue
                            : Colors.grey.shade400,
                      ),
                    ),
                    child: Text(
                      timeSlot,
                      style: TextStyle(
                        color: selectedTimeSlot == timeSlot
                            ? AppColors.primaryBlue
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          const Row(
            children: [
              Icon(
                Icons.location_on,
                size: 16,
                color: Colors.grey,
              ),
              Text(
                'ĐỊA CHỈ KHÁM',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 4,
          ),
          const Text(
            'Phòng khám Đa khoa Mediplus',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            'Tầng 2, Trung tâm thương mại Mandarin Garden 2, 99 phố Tân Mai, Hoàng Mai, Hà Nội',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              const Text(
                'Giá khám: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text(
                '350.000đ',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Xử lý khi người dùng nhấn vào "Xem chi tiết"
                },
                child: const Text(
                  'Xem chi tiết',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );;
  }
}
