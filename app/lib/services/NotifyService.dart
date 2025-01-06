import 'dart:convert';

import 'package:http/http.dart' as http;

class NotifyService {
  String appId = "e311ec0f-04e6-4438-a9fb-f9d64049721b";
  String oneSignalApiKey = "YjI1MGJjYTUtY2E0Yy00NTZmLWJhYjItZjUyN2M0MzUwNDRk";
  String url = "https://api.onesignal.com/notifications";

  sendNotification(String title, String description) async{
    try{
      var response = await http.post(
          Uri.parse(
              url
          ),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Basic $oneSignalApiKey"
          },
          body: jsonEncode({
            "app_id": appId,
            "contents": {"en": description},
            "included_segments": ["Total Subscriptions"],
            "headings": {
              "en": title,
            },
          })
      );

      if(response.statusCode == 200){
        print("RESPONSE RESPONSE: ${response.body}");
        print("Notification sent successfully");
      }
      else{
        print("Notification failed to send with status code: ${response.statusCode}");
      }
    }catch(e){
      throw Exception('Failed to send notification: $e');
    }
  }

}