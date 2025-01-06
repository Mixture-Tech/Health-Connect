import 'package:app/ui/screens/AppointmentScreen.dart';
import 'package:app/ui/widgets/DoctorInfoWidget.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import '../../services/DoctorService.dart';
import '../../styles/colors.dart';
import '../../styles/text.dart';
import '../widgets/DoctorCardWidget.dart';

class ListDoctorScreen extends StatefulWidget {
  const ListDoctorScreen({
    super.key,
  });

  @override
  State<ListDoctorScreen> createState() => _ListDoctorScreenState();
}

class _ListDoctorScreenState extends State<ListDoctorScreen> {
  late Future<DoctorService> _doctorService;
  List<Doctor> doctors = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _doctorService = DoctorService.create();
    _loadDoctors();
  }

  Future<void> _loadDoctors() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final doctorService = await _doctorService;
      final response = await doctorService.getDoctors();

      final List<Doctor> loadedDoctors = response.map((doctorJson) {
        return Doctor.fromJson(doctorJson);
      }).toList();

      setState(() {
        doctors = loadedDoctors;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void handleDoctorCardTap(Doctor doctor) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => AppointmentScreen(doctor: doctor),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $error'),
            ElevatedButton(
              onPressed: _loadDoctors,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (doctors.isEmpty) {
      return const Center(
        child: Text('No doctors available'),
      );
    }

    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: DoctorCardWidget(
            name: doctor.doctorName ?? 'Unknown Doctor',
            imageUrl: doctor.doctorImage ?? 'assets/images/default_doctor.jpg',
            facility: doctor.specializationName ?? 'No description available',
            description: doctor.doctorDescription ?? 'No description available',
            onTap: () => handleDoctorCardTap(doctor),
          ),
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
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Background_2.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  RefreshIndicator(
                    onRefresh: _loadDoctors,
                    child: _buildContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}