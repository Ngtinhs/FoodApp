import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManageOrders extends StatefulWidget {
  @override
  _ManageOrdersState createState() => _ManageOrdersState();
}

class _ManageOrdersState extends State<ManageOrders> {
  List<dynamic> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:8000/api/cart/allorders'));
      if (response.statusCode == 200) {
        setState(() {
          orders = json.decode(response.body);
        });
      } else {
        print('Failed to fetch orders. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to fetch orders. Error: $error');
    }
  }

  Future<void> handleUpdateStatus(int orderId, int newStatus) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8000/api/cart/updatestatus/$orderId'),
        body: {'status': newStatus.toString()},
      );
      if (response.statusCode == 200) {
        fetchOrders(); // Fetch orders again to update the list
      } else {
        print('Failed to update status. Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Failed to update status. Error: $error');
    }
  }

  String getStatusLabel(int status) {
    switch (status) {
      case 0:
        return 'Đang xử lý';
      case 1:
        return 'Đang giao hàng';
      case 2:
        return 'Thành công';
      case 3:
        return 'Đã hủy';
      default:
        return '';
    }
  }

  Widget renderActions(dynamic order) {
    final int id = order['id'];
    final int status = order['status'];

    switch (status) {
      case 0:
        return Row(
          children: [
            IconButton(
              onPressed: () => handleUpdateStatus(id, 1),
              icon: Icon(Icons.local_shipping),
            ),
            IconButton(
              onPressed: () => handleUpdateStatus(id, 3),
              icon: Icon(Icons.cancel_outlined),
            ),
          ],
        );
      case 1:
        return IconButton(
          onPressed: () => handleUpdateStatus(id, 2),
          icon: Icon(Icons.check_outlined),
        );
      case 2:
        return Column(
          children: [
            Text('Đã hoàn thành'),
            // TextButton(
            //   onPressed: () {
            //     // Perform action
            //   },
            //   child: Text('Xem chi tiết'),
            // ),
          ],
        );
      case 3:
        return Column(
          children: [
            Text('Đơn đặt món đã hủy'),
            // TextButton(
            //   onPressed: () => handleUpdateStatus(id, 0),
            //   child: Text('Đặt lại'),
            // ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý đơn đặt món'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx, index) {
          final order = orders[index];
          return Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                'Mã đơn: ${order['id']}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Số điện thoại: ${order['phone']}'),
                  Text('Địa chỉ: ${order['address']}'),
                  Text('Tổng tiền: ${order['total_price'].toStringAsFixed(2)}'),
                  Text('Mã người dùng: ${order['user_id']}'),
                  Text(
                    'Ngày tạo: ${DateTime.parse(order['created_at']).toString()}',
                  ),
                  Text(
                    'Cập nhật lần cuối: ${DateTime.parse(order['updated_at']).toString()}',
                  ),
                  Text('Ghi chú: ${order['note']}'),
                ],
              ),
              trailing: Container(
                width: 120,
                child: renderActions(order),
              ),
            ),
          );
        },
      ),
    );
  }
}
