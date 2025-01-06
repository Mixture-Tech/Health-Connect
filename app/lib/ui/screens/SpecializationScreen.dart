import 'package:app/services/SpecializationService.dart';
import 'package:app/styles/colors.dart';
import 'package:app/ui/screens/HomeScreen.dart';
import 'package:app/ui/widgets/HeaderWidget.dart';
import 'package:app/ui/widgets/NavigationBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../models/specialization.dart';
import 'SpecializationDetailScreen.dart';

class SpecializationScreen extends StatefulWidget {
  const SpecializationScreen({super.key});

  @override
  _SpecializationScreenState createState() => _SpecializationScreenState();
}

class _SpecializationScreenState extends State<SpecializationScreen> {
  late Future<SpecializationService> _specializationService;
  List<Specialization> specializations = [];
  bool isLoading = true;
  String? error;

  @override
  void initState(){
    super.initState();
    _specializationService = SpecializationService.create();
    _loadSpecializations();
  }


  // final List<Map<String, String>> specializations = [
  //   {'name': 'Cơ Xương Khớp', 'imagePath': 'assets/images/Joints Bone.png'},
  //   {'name': 'Thần kinh', 'imagePath': 'assets/images/Brain.png'},
  //   {'name': 'Răng', 'imagePath': 'assets/images/Tooth.png'},
  //   {'name': 'Phổi', 'imagePath': 'assets/images/Lungs.png'},
  //   // Add more specializations here if needed
  // ];

  Future<void> _loadSpecializations() async {
    try{
      setState(() {
        isLoading = true;
        error = null;
      });
      final specializationService = await _specializationService;
      final specializationsData = await specializationService.getSpecializations();

      setState(() {
        specializations = specializationsData
            .map((data) => Specialization.fromJson(data))
            .toList();
        isLoading = false;
      });
    }catch (e){
      setState(() {
        error = 'Không thể tải danh sách chuyên khoa: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 65,
              child: HeaderWidget(
                isHomeScreen: false,
                onIconPressed: () {
                  Navigator.of(context).pop(
                    CupertinoPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(){
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loadSpecializations,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: specializations.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
          ),
          itemBuilder: (context, index) {
            final specialization = specializations[index];
            return _buildSpecializationItem(
              context,
              specialization.name,
              specialization.id,
              specialization.imgPath,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSpecializationItem(BuildContext context, String name, String id, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => SpecializationDetailScreen(
            specializationId: id,
            specializationName: name,
            // specializationImage: imagePath,
          )),
        );
      },
      child: SizedBox(
        height: 150,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      imagePath,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
