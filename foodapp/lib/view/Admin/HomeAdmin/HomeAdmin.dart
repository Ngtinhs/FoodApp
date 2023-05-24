import 'package:flutter/material.dart';
import 'package:foodapp/view/Admin/Manager/Category.dart';
import 'package:foodapp/view/Admin/Manager/Foods.dart';
import 'package:foodapp/view/Admin/Manager/ManageOrders.dart';
import 'package:foodapp/view/Admin/Manager/Users.dart';
import 'package:foodapp/view/Admin/Manager/Revenue.dart';

class HomeScreen extends StatelessWidget {
  Future<void> _refreshData() async {
    // Thực hiện logic làm mới dữ liệu ở đây
    // Ví dụ: gọi API để cập nhật dữ liệu mới
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
