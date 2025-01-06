import 'package:app/ui/screens/ListDoctorScreen.dart';
import 'package:flutter/material.dart';
import 'package:app/ui/screens/HomeScreen.dart';
import 'package:app/ui/screens/NotificationScreen.dart';
import 'package:app/ui/screens/AppointmentScreen.dart';
import 'package:app/ui/screens/ProfileScreen.dart';
import 'package:app/ui/widgets/NavigationBarWidget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) {
      // Pop to first route in current tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[index],
        tabItem: TabItem.values[index],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_selectedIndex].currentState!.maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_selectedIndex != 0) {
            _onItemTapped(0);
            return false;
          }
        }
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
            _buildOffstageNavigator(3),
          ],
        ),
        bottomNavigationBar: NavigationBarWidget(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}

enum TabItem { home, notification, appointment, profile }

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final TabItem tabItem;

  const TabNavigator({
    Key? key,
    required this.navigatorKey,
    required this.tabItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    switch (tabItem) {
      case TabItem.home:
        child = const HomeScreen();
        break;
      case TabItem.notification:
        child = const NotificationScreen();
        break;
      case TabItem.appointment:
        child = const ListDoctorScreen();
        break;
      case TabItem.profile:
        child = const ProfileScreen();
        break;
    }

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}