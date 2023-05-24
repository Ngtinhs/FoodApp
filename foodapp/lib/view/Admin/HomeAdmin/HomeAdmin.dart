import 'package:flutter/material.dart';
import 'package:foodapp/view/Admin/Manager/Category.dart';
import 'package:foodapp/view/Admin/Manager/Foods.dart';
import 'package:foodapp/view/Admin/Manager/ManageOrders.dart';
import 'package:foodapp/view/Admin/Manager/Users.dart';
import 'package:foodapp/view/Admin/Manager/Revenue.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trang chủ'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageCategory()),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 40,
                  child: Icon(Icons.category, size: 40),
                ),
                SizedBox(height: 8),
                Text(
                  'Quản lý danh mục',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageFood()),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 40,
                  child: Icon(Icons.restaurant_menu, size: 40),
                ),
                SizedBox(height: 8),
                Text(
                  'Quản lý món ăn',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageOrders()),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 40,
                  child: Icon(Icons.assignment, size: 40),
                ),
                SizedBox(height: 8),
                Text(
                  'Quản lý đơn',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageUsers()),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.purple,
                  radius: 40,
                  child: Icon(Icons.people, size: 40),
                ),
                SizedBox(height: 8),
                Text(
                  'Quản lý người dùng',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Revenue()),
              );
            },
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 40,
                  child: Icon(Icons.bar_chart, size: 40),
                ),
                SizedBox(height: 8),
                Text(
                  'Quản lý doanh thu',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
