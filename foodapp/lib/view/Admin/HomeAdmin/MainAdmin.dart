import 'package:flutter/material.dart';
import 'package:foodapp/view/Admin/HomeAdmin/HomeAdmin.dart';
import 'package:foodapp/view/Admin/HomeAdmin/UserAdmin.dart';

void main() {
  runApp(MainAdmin());
}

class MainAdmin extends StatefulWidget {
  @override
  _MainAdminState createState() => _MainAdminState();
}

class _MainAdminState extends State<MainAdmin> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    UserScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Bottom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User',
            ),
          ],
        ),
      ),
    );
  }
}
