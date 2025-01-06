import 'package:app/models/appointment.dart';
import 'package:app/services/AppointmentService.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/widgets/ButtonWidget.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/utils/date_time.dart';



class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<AppointmentService> _notificationService;
  List<Appointment> notifications = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _notificationService = AppointmentService.create();
    _loadNotification();
  }
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _loadNotification(); // Gọi lại để cập nhật dữ liệu khi màn hình hiển thị lại
  // }

  Future<void> _loadNotification() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final notificationService = await _notificationService;
      final notificationData = await notificationService.fetchAppointments();

      setState(() {
        notifications = notificationData
            .map((data) => Appointment.fromJson(data))
            .toList();
      });
    } catch (e) {
      setState(() {
        error = 'Không thể tải danh sách lịch hẹn: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    // Hiển thị loading
    setState(() {
      isLoading = true;
    });
    try {
      final notificationService = await _notificationService;
      await notificationService.cancelAppointment(appointmentId);

      // Hiển thị thông báo thành công
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Huỷ lịch hẹn thành công'),
        ),
      );
      // Tải lại danh sách lịch hẹn
      await _loadNotification();

    } catch (e) {
      // Hiển thị thông báo lỗi
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể hủy lịch hẹn: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    } finally {
      // Tắt loading nếu component vẫn mounted
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }


  void _showCancelConfirmDialog(String appointmentId) {
    print('Attempting to cancel appointment with ID: ${appointmentId}');
    showDialog(
      context: context,
      barrierDismissible: false, // Không cho phép tắt dialog bằng cách chạm ngoài
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận hủy lịch hẹn'),
          content: const Text('Bạn có chắc chắn muốn hủy lịch hẹn này không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
              child: const Text('Không'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // Đóng dialog
                await _cancelAppointment(appointmentId); // Gọi hàm hủy
              },
              child: const Text('Có, hủy lịch'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            HeaderWidget(
              isHomeScreen: true,
              onIconPressed: () {
                // Navigator.pop(context);
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
                  _buildContent(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget _buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text(
            error!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotification, // Chỉ định hàm để tải lại dữ liệu
      child: ListView(
        children: [
          _buildAppointmentsList(),
        ],
      ),
    );
  }


  Widget _buildAppointmentsList() {
    if (notifications.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Text(
            'Bạn chưa đặt cuộc hẹn nào!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.red,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final appointment = notifications[index];
        return _buildAppointmentItem(appointment);
      },
    );
  }



  Widget _buildAppointmentItem(Appointment appointment) {
    final DateFormat dateFormatter = DateFormat('dd-MM-yyyy');
    final DateFormat timeFormatter = DateFormat('HH:mm');
    //chỉnh sửa định dạng taken_date
    String formattedCreatedAt = 'Không xác định';
    if (appointment.createdAt != null) {
      try {
        DateTime createdAtDateTime = DateTime.parse(appointment.createdAt!);
        formattedCreatedAt = DateTimeUtils.formatDate(createdAtDateTime); // Sử dụng hàm custom formatDate
      } catch (e) {
        print('Error parsing createdat: ${appointment.createdAt}');
      }
    }
    //chỉnh sửa định dạng taken_date
    String formattedAppointmentTakenDate = 'Không xác định';
    if (appointment.appointmentTakenDate != null) {
      try {
        DateTime appointmentTakenDateTime = DateTime.parse(appointment.appointmentTakenDate!);
        formattedAppointmentTakenDate = DateTimeUtils.formatDate(appointmentTakenDateTime); // Sử dụng hàm custom formatDate
      } catch (e) {
        print('Error parsing appointmentTakenDate: ${appointment.appointmentTakenDate}');
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
               formattedCreatedAt,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 4),
            // Thay đổi thông báo theo trạng thái
            Text(
              appointment.status == 'CONFIRMED'
                  ? 'Đặt lịch khám thành công'
                  : appointment.status == 'CANCELLED'
                  ? 'Lịch hẹn đã bị huỷ'
                  : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: appointment.status == 'CANCELLED' ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: appointment.status == 'CONFIRMED'
                    ? 'Quý khách đã đặt lịch khám với bác sĩ: '
                    : appointment.status == 'CANCELLED'
                    ? 'Quý khách đã hủy lịch khám với bác sĩ: '
                    : '',
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: '${appointment.doctorName ?? 'Không xác định'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ', vào ngày: $formattedAppointmentTakenDate',
                  ),
                ],
              ),
            ),
            Text(
              'Thời gian: ${DateTimeUtils.formatTimeRange(appointment.startTime, appointment.endTime) ?? 'N/A'}',
            ),
            const SizedBox(height: 8), // Khoảng cách giữa thông tin và nút Hủy
            // Hiển thị nút Hủy chỉ khi status là CONFIRMED
            if (appointment.status == 'CONFIRMED')
              ElevatedButton(
                onPressed: isLoading ? null : () {
                  // Disable nút khi đang loading
                  _showCancelConfirmDialog(appointment.id);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  disabledBackgroundColor: Colors.grey, // Màu khi disable
                ),
                child: Text(
                  isLoading ? 'Đang xử lý...' : 'Hủy lịch hẹn',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
