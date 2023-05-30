import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static uploadinfohaveimage(File image, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.MultipartRequest(
        "POST", Uri.parse("${Apihelper.url_base}/changeimage"));
    var picture = await http.MultipartFile.fromPath("avatar", image.path);
    // if (picture!=null){
    response.files.add(picture);
    var statusres = await response.send();
    var responseData = await statusres.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if (statusres.statusCode == 200) {
    } else {
      print(statusres.statusCode.toString());
    }
  }

  static updateInfo(
      String name, String phone, String address, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.MultipartRequest(
        "POST", Uri.parse("${Apihelper.url_base}/changeinfo"));
    int user_id = pref.getInt("id");
    response.fields['name'] = name;
    response.fields['user_id'] = user_id.toString();
    response.fields['phone'] = phone;
    response.fields['address'] = address;

    var statusres = await response.send();
    var responseData = await statusres.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    if (statusres.statusCode == 200) {
      var jsonResponse = json.decode(responseString);
      if (jsonResponse != null) {}
      // print(jsonResponse['token']);
      pref.setString('token', jsonResponse['token']);
      pref.setString('name', jsonResponse['name']);
      pref.setString('phone', jsonResponse['phone']);
      pref.setString('email', jsonResponse['email']);
      pref.setString('address', jsonResponse['address']);
      pref.setInt('id', jsonResponse['id']);
      pref.setInt('role', jsonResponse['role']); //role = 1 :admin
      pref.setString('image', jsonResponse['image']); //role = 1 :admin
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
      print(statusres.statusCode.toString());
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse("${Apihelper.url_base}/users"));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedUsers =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));

        return fetchedUsers;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return [];
  }

  static Future<bool> deleteUser(int userId) async {
    try {
      final response =
          await http.delete(Uri.parse('${Apihelper.url_base}/users/$userId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return false;
  }

  static Future<bool> updateUser(
      int userId, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('${Apihelper.url_base}/users/$userId'),
        body: jsonEncode(userData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return false;
  }
}
