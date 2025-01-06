import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NotificationService {
  static String restApiKeyOneSignal = dotenv.env['REST_API_KEY_ONE_SIGNAL'] ?? '';
  static String baseUrlOneSignal = dotenv.env['BASE_URL_API_ONE_SIGNAL'] ?? '';
  static String appIdOneSignal = dotenv.env['APP_ID_ONE_SIGNAL'] ?? '';

  static Future<void> init() async{
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.initialize(appIdOneSignal);
    OneSignal.Notifications.requestPermission(true);
  }

    // Đăng ký nhận thông báo
    // OneSignal.Notifications.addForegroundWillDisplayListener((OSNotification notification) {
    //   // Xử lý thông báo khi ứng dụng đang ở trạng thái chạy
    //   print('Received notification: ${notification.jsonRepresentation()}');
    // } as OnNotificationWillDisplayListener);

    // OneSignal.Notifications.addNotificationOpenedHandler((OSNotificationOpenedResult result) {
    //   // Xử lý khi người dùng nhấp vào thông báo
    //   print('Notification opened: ${result.notification.jsonRepresentation()}');
    // });

  // static Future<void> init() async{
  //   //Remove this method to stop OneSignal Debugging
  //   OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  //
  //   OneSignal.initialize(appIdOneSignal);
  //
  // // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  //   OneSignal.Notifications.requestPermission(true);
  //
  //   final permission = await OneSignal.Notifications.permission;
  //     print('Notification permission status: $permission');
  // }

  // sendNotification(String title, String description) async {
  //   try {
  //     var response = await http.post(
  //         Uri.parse(baseUrlOneSignal),
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': "Basic $restApiKeyOneSignal"
  //         },
  //         body: jsonEncode({
  //           "app_id": appIdOneSignal,
  //           "target_channel": "push",
  //           "contents": {"en": description},
  //           "included_segments": ["Total Subscriptions"],
  //           "headings": {
  //             "en": title,
  //           }}
  //         ));
  //     if(response.statusCode == 200){
  //       print("Notification sent successfully");
  //     }
  //     else{
  //       print("Notification failed to send with status code: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to send notification: $e');
  //   }
  // }

  static Future<void> sendImmediateNotification({
    required String title,
    required String description,
    Map<String, dynamic>? additionalData,
  }) async{
    try{
      var response = await http.post(
          Uri.parse(baseUrlOneSignal),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Basic $restApiKeyOneSignal"
          },
          body: jsonEncode({
            "app_id": appIdOneSignal,
            "contents": {"en": description},
            "included_segments": ["Total Subscriptions"],
            "headings": {"en": title},
            "data" : additionalData,
          })
      );
      if(response.statusCode == 200) {
        print("RESPONSE: ${response.body}");
        print("Immediate notification sent successfully");
      }
      else{
        print("Immediate notification failed to send with status code: ${response.statusCode}");
      }
    }catch(e){
      throw Exception('Failed to send immediate notification: $e');
    }
  }

  static Future<void> sheduleAppointmentReminder({
    required String appointmentId,
    required patientName,
    required String doctorName,
    required DateTime appointmentTime,
  }) async {
    try{
      DateTime reminderTime = appointmentTime.subtract(const Duration(hours: 1));

      var response = await http.post(
        Uri.parse(baseUrlOneSignal),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Basic $restApiKeyOneSignal"
        },
        body: jsonEncode({
          "app_id": appIdOneSignal,
          "contents": {
            "en": "Bạn có cuộc hẹn với Bác sĩ $doctorName trong 1 giờ nữa"
          },
          "headings": {
            "en": "Nhắc nhở lịch hẹn"
          },
          "included_segments": ["Total Subscriptions"],
          "send_after": reminderTime.toIso8601String(),
          "data": {
            "appointmentId": appointmentId,
            "type": "appointment_reminder",
            "doctorName": doctorName,
          },
        }),
      );
      if(response.statusCode == 200){
        print(response);
        print("Appointment reminder scheduled successfully");
      }
      else{
        print("Failed to schedule appointment reminder with status code: ${response.statusCode}");
      }
    }catch(e){
      throw Exception('Failed to schedule appointment reminder: $e');
    }
  }
}