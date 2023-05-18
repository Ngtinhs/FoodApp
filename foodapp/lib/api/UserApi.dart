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
}
