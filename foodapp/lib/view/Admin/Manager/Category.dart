import 'package:flutter/material.dart';

class ManageCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ManageCategory'),
      ),
      body: Center(
        child: Text(
          'Xin chào ManageCategory',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
