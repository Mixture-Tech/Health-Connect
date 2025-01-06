import 'package:app/services/NotificationService.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/screens/AppointmentScreen.dart';
import 'package:app/ui/screens/AppointmentDetailScreen.dart';
import 'package:app/ui/screens/BookingSuccessScreen.dart';
import 'package:app/ui/screens/HomeScreen.dart';
import 'package:app/ui/screens/ListDoctorScreen.dart';
import 'package:app/ui/screens/LoginScreen.dart';
import 'package:app/ui/screens/MainScreen.dart';
import 'package:app/ui/screens/NotificationScreen.dart';
import 'package:app/ui/screens/NotificationScreen.dart';
import 'package:app/ui/screens/PersonalInformationScreen.dart';
import 'package:app/ui/screens/RegisterScreen.dart';
import 'package:app/ui/screens/SpecializationScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
  await NotificationService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Connect App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accentBlue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}
