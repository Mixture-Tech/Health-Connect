import 'package:app/styles/colors.dart';
import 'package:app/ui/screens/SpecializationScreen.dart';
import 'package:app/ui/widgets/NavigationBarWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/HeaderWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

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
                print('hehe');
              },
            ),
            Expanded(
              child: Stack(
                children: [
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Background_3.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // SizedBox(height: AppBar().preferredSize.height),
                          SizedBox(height: 15),
                          // Thêm thanh tìm kiếm tại đây thay vì trong Positioned
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/Home - Find Doctor.png',
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 20,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                                      child: const Text(
                                        'Tìm và đặt hẹn với bác sĩ \n yêu thích của bạn',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              blurRadius: 5.0,
                                              color: Colors.black,
                                              offset: Offset(1.0, 1.0),
                                            ),
                                          ],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 120,
                                    left: 30.0,
                                    right: 30.0,
                                    child: _buildSearchBar(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 12.0),
                          const Text(
                            'Chuyên khoa',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSpecialtyCircle('assets/images/Lungs.png', 'Phổi'),
                                _buildSpecialtyCircle('assets/images/Tooth.png', 'Răng'),
                                _buildSpecialtyCircle('assets/images/Brain.png', 'Thần kinh'),
                                _buildSpecialtyCircle('assets/images/Joints Bone.png', 'Cơ-Xương-Khớp'),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.0),
                          const Divider(
                            color: AppColors.accentBlue,
                            thickness: 1.0,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                          SizedBox(height: 12.0),
                          const Text(
                            'Bác sĩ nổi bật',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildDoctorAvatar('assets/images/bs1.jpg', 'TS.BS.Trần Thu Hương', 'Nhi khoa, Thần kinh'),
                                _buildDoctorAvatar('assets/images/bs2.jpg', 'PGS.TS.BS.Nguyễn Xuân Thành', 'Nội tiêu hóa - Gan mật'),
                                _buildDoctorAvatar('assets/images/bs3.png', 'GS.TS.Thái Hồng Quang','Nội tiết - Tuyến giáp'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextButton(
                            onPressed: () {
                              // Thực hiện hành động khi nhấn vào nút "Xem thêm"
                              print('Xem thêm bác sĩ nổi bật');
                              // Có thể điều hướng đến trang khác hoặc hiển thị thêm thông tin
                            },
                            child: const Text(
                              'Xem thêm',
                              style: TextStyle(
                                color: AppColors.primaryBlue, // Màu chữ cho nút
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(
                            color: AppColors.accentBlue,
                            thickness: 1.0,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                          const SizedBox(height: 12.0),
                          const Text(
                            'Dịch vụ toàn diện',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          GridView.count(
                            shrinkWrap: true, // Đảm bảo GridView không chiếm quá nhiều không gian
                            physics: const NeverScrollableScrollPhysics(), // Vô hiệu hóa cuộn cho GridView
                            crossAxisCount: 2, // Số cột
                            mainAxisSpacing: 16.0, // Khoảng cách giữa các hàng
                            crossAxisSpacing: 16.0, // Khoảng cách giữa các cột
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            children: [
                              _buildServiceBox(
                                'Khám\nchuyên khoa',
                                'assets/images/Medical Symbol.png',
                                  () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(builder: (context) => const SpecializationScreen())
                                  );
                                }),
                              // _buildServiceBox('Khám\ntổng quát', 'assets/images/Heart Rate.png'),
                              // _buildServiceBox('Tham khảo\nchi phí', 'assets/images/Dollar (USD).png'),
                              // _buildServiceBox('Sức khỏe\ntinh thần', 'assets/images/Body.png'),
                              // _buildServiceBox('Khám\nnha khoa', 'assets/images/Tooth.png'),
                              // _buildServiceBox('Bài test\nsức khỏe', 'assets/images/Clipboard-alt.png'),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          const Divider(
                            color: AppColors.accentBlue,
                            thickness: 1.0,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                          const SizedBox(height: 12.0),
                          const Text(
                            'Cơ sở y tế hàng đầu',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 16.0), // Space after the title
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            children: [
                              // _buildServiceBox('Bệnh viện\nnhân dân 115', 'assets/images/115.png',),
                              // _buildServiceBox('Bệnh viện\nnhi đồng 1', 'assets/images/NhiDong1.png'),
                              // _buildServiceBox('Bệnh viện\nChợ Rẫy', 'assets/images/ChoRay.png'),
                              // _buildServiceBox('Bệnh viện\nnhân dân Gia Định', 'assets/images/GiaDinh.png'),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Thực hiện hành động khi nhấn vào nút "Xem thêm"
                              print('Xem thêm bác sĩ nổi bật');
                              // Có thể điều hướng đến trang khác hoặc hiển thị thêm thông tin
                            },
                            child: const Text(
                              'Xem thêm',
                              style: TextStyle(
                                color: AppColors.primaryBlue, // Màu chữ cho nút
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const Divider(
                            color: AppColors.accentBlue,
                            thickness: 1.0,
                            indent: 20.0,
                            endIndent: 20.0,
                          ),
                          const SizedBox(height: 12.0),
                          const Text(
                            'Cẩm nang sức khỏe',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.primaryBlue,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildLargeBox('7 nguyên tắc an toàn vệ sinh thực\nphẩm dành cho bạn', 'Nội dung khung 1', 'assets/images/fruit_resized.jpg'),
                                const SizedBox(width: 16.0), // Space between boxes
                                _buildLargeBox('10 triệu chứng HIV thường gặp và\ncách điều trị', 'Nội dung khung 2', 'assets/images/hiv_resized.jpg'),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Thực hiện hành động khi nhấn vào nút "Xem thêm"
                              print('Xem thêm bác sĩ nổi bật');
                              // Có thể điều hướng đến trang khác hoặc hiển thị thêm thông tin
                            },
                            child: const Text(
                              'Xem thêm',
                              style: TextStyle(
                                color: AppColors.primaryBlue, // Màu chữ cho nút
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(height: 70.0),
                        ],
                      ),
                    ),
                  ),
                  // const NavigationBarWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLargeBox(String title, String content, String imagePath) {
    return Column(
      children: [
        Container(
          width: 300, // Width of the large box
          height: 150, // Adjust height as needed
          decoration: BoxDecoration(
            color: AppColors.lightYellow,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              imagePath,
              width: 300,
              height: 150,
            ),
          ),
        ),
        const SizedBox(height: 8.0), // Space between box and title
        Text(
          title,
          style: const TextStyle(
            color: AppColors.primaryBlue,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildServiceBox(String title, String imagePath, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120, // Chiều rộng của hình chữ nhật
        height: 60, // Chiều cao của hình chữ nhật
        decoration: BoxDecoration(
          color: AppColors.lightYellow,
          borderRadius: BorderRadius.circular(12.0), // Bo tròn các góc
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 80, // Điều chỉnh kích thước của logo
              height: 80,
            ),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: AppColors.primaryBlue),
        decoration: InputDecoration(
          hintText: 'Hãy nhập tên bác sĩ...',
          hintStyle: const TextStyle(color: AppColors.primaryBlue),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
          suffixIcon: const Icon(Icons.search, color: Colors.blue),
        ),
        onSubmitted: (value) {
          print('Tìm kiếm: $value');
        },
      ),
    );
  }

  Widget _buildSpecialtyCircle(String imagePath, String label) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: const BoxDecoration(
            color: AppColors.lightYellow,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: const TextStyle(color: AppColors.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildDoctorAvatar(String imagePath, String doctorName, String doctorDepartment) {
    return Column(
      children: [
        Container(
          width: 150,
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          doctorName,
          style: const TextStyle(color: AppColors.primaryBlue),
        ),
        Text(
          doctorDepartment,
          style: const TextStyle(color: AppColors.primaryBlue),
        ),
      ],
    );
  }
}
