import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:foodapp/config/apihelper.dart';
import 'dart:convert';

class AuthApi {
  var status;
  static displayDialog(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: new Text('Lỗi')),
            content: new Text('$message'),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text(
                  'Close',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  signup(String email, String password) async {
    final response = await http.post(Uri.parse("${Apihelper.url_base}/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          'Accept-Encoding': 'gzip, deflate, br',
          'Accept': 'application/json',
        },
        body: json.encode(<String, String>{
          "email": "$email",
          "password": "$password",
        }));
    status = response.body.contains('errors');
    var data = json.decode(response.body);
    if (data.statusCode == 200) {
      print("oke");
      print("${data['token']}");
    }
  }
}
