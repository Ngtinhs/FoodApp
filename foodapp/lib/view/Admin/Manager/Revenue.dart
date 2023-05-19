import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Revenue extends StatefulWidget {
  const Revenue({Key? key}) : super(key: key);

  @override
  _RevenueState createState() => _RevenueState();
}

class _RevenueState extends State<Revenue> {
  late int totalRevenue;
  bool isLoading = true;

  Future<int> _fetchTotalRevenue() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/cart/revenue'));
    if (response.statusCode == 200) {
      final jsonResult = jsonDecode(response.body);
      final revenue = int.parse(jsonResult['totalRevenue']);
      return revenue;
    } else {
      throw Exception('Failed to load total revenue');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTotalRevenue().then((revenue) {
      setState(() {
        totalRevenue = revenue;
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quản lý doanh thu"),
      ),
      body: Container(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Tổng doanh thu:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            isLoading
                ? const CircularProgressIndicator()
                : FutureBuilder<int>(
                    future: _fetchTotalRevenue(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                          'Failed to load total revenue',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
