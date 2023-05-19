import 'package:flutter/material.dart';
import 'package:foodapp/view/Admin/Manager/Category.dart';
import 'package:foodapp/view/Admin/Manager/Foods.dart';
import 'package:foodapp/view/Admin/Manager/ManageOrders.dart';
import 'package:foodapp/view/Admin/Manager/Users.dart';
import 'package:foodapp/view/Admin/Manager/Revenue.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAdmin extends StatefulWidget {
  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  Future<void> _refreshData() async {
    // Do something to refresh the data
    // For example, fetch new data from an API

    // Simulate a delay for demonstration purposes
    await Future.delayed(Duration(seconds: 2));

    // After refreshing the data, call setState() to rebuild the UI
    setState(() {});
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear the stored user information
    await prefs.remove('userId');

    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Trang quản trị'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageCategory()),
                );
              },
              child: Text('Quản lý danh mục món ăn'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageFood()),
                );
              },
              child: Text('Quản lý món ăn'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageOrders()),
                );
              },
              child: Text('Quản lý đơn đặt món ăn'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManageUsers()),
                );
              },
              child: Text('Quản lý người dùng'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Revenue()),
                );
              },
              child: Text('Doanh thu'),
            ),
          ],
        ),
      ),
    );
  }
}
