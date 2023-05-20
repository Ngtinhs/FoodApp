import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodapp/api/AuthApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/view/Admin/HomeAdmin/HomeAdmin.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key});
  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  AuthApi authApi = new AuthApi();
  TextEditingController emailcontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 25),
              width: 400,
              height: 70,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(59, 185, 52, 1),
                  ),
                ),
              ),
              // decoration: BoxDecoration(
              //   color: Colors.amber,
              // ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        height: 200,
                        width: 200,
                        child: Image.asset('assets/image/petlogo.png'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: emailcontroller,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Tài khoản",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                              fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(59, 185, 52, 1),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: passwordcontroller,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Mật khẩu",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                              fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(59, 185, 52, 1),
                                width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: TextButton(
                          onPressed: () {
                            print("Da");
                            signIn(
                                emailcontroller.text, passwordcontroller.text);
                          },
                          child: Text(
                            "ĐĂNG NHẬP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 50, right: 50),
                              backgroundColor: Color.fromRGBO(59, 185, 52, 1),
                              shape: StadiumBorder())),
                    ),
                    TextButton(
                        child: Text("Đăng kí"),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.blueAccent),
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  signIn(String email, String password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {
      'email': email,
      'password': password,
    };
    var jsonResponse = null;
    var response =
        await http.post(Uri.parse('${Apihelper.url_base}/login'), body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      if (jsonResponse != null) {
        pref.setString('token', jsonResponse['token']);
        pref.setString('name', jsonResponse['name']);
        pref.setString('phone', jsonResponse['phone']);
        pref.setString('email', jsonResponse['email']);
        pref.setString('address', jsonResponse['address']);
        pref.setInt('id', jsonResponse['id']);
        pref.setInt(
            'role', jsonResponse['role']); // role = 1: admin, role = 2: user
        pref.setString('image', jsonResponse['image']);

        if (jsonResponse['role'] == 1) {
          // Nếu role là 1, chuyển hướng đến trang HomeAdmin
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeAdmin()));
        } else {
          // Nếu role là 2 hoặc bất kỳ giá trị khác, chuyển hướng đến trang Home
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        }
      }
    } else {
      setState(() {});
      _showDialog();
    }
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Failed'),
            content: new Text('Check your email or password'),
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
}
