import 'package:flutter/material.dart';
import 'package:foodapp/view/Admin/Manager/Category.dart';
import 'package:foodapp/view/Admin/Manager/Foods.dart';
import 'package:foodapp/view/Admin/Manager/ManageOrders.dart';
import 'package:foodapp/view/Admin/Manager/Users.dart';
import 'package:foodapp/view/Admin/Manager/Revenue.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HomeAdmin'),
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
