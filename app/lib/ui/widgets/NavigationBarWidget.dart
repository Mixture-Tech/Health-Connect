import 'package:flutter/material.dart';
import 'package:app/styles/colors.dart';

class NavigationBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const NavigationBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Thông báo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Lịch hẹn',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Cá nhân',
        )
      ],
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryBlue,
      unselectedItemColor: AppColors.black,
      selectedLabelStyle: const TextStyle(fontSize: 15),
      onTap: onItemTapped,
      iconSize: 30,
    );
  }
}