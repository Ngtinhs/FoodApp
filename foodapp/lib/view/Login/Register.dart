import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key});
  @override
  State<Register> createState() => _Register();
}

class _Register extends State<Register> {
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController c_password = new TextEditingController();
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
                    color: Color.fromRGBO(243, 98, 105, 1),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 180,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: fname,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  bottom: -9, left: 13, right: 13),
                              hintText: "Họ",
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
                                    color: Color.fromRGBO(243, 98, 105, 1),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 180,
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: TextFormField(
                            controller: lname,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  bottom: -9, left: 13, right: 13),
                              hintText: "Tên",
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
                                    color: Color.fromRGBO(243, 98, 105, 1),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextFormField(
                        controller: email,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Email",
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
                                color: Color.fromRGBO(243, 98, 105, 1),
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
                        controller: password,
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
                                color: Color.fromRGBO(243, 98, 105, 1),
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
                        controller: c_password,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Nhập lại mật khẩu",
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
                                color: Color.fromRGBO(243, 98, 105, 1),
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
                            if (fname.text != "" &&
                                lname.text != "" &&
                                email.text != "" &&
                                password.text != "" &&
                                c_password.text != "") {
                              if (password.text == c_password.text) {
                                signUp(fname.text, lname.text, email.text,
                                    password.text, c_password.text);
                              } else {
                                _showDialog("Mật khẩu không trùng");
                              }
                            } else {
                              _showDialog("Không được chừa trống");
                            }
                            signUp(fname.text, lname.text, email.text,
                                password.text, c_password.text);
                          },
                          child: Text(
                            "ĐĂNG KÍ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, left: 50, right: 50),
                              backgroundColor: Color.fromRGBO(243, 98, 105, 1),
                              shape: StadiumBorder())),
                    ),
                    TextButton(
                        child: Text("Đăng nhập"),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
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

  signUp(String fname, String lname, String email, String password,
      String c_password) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {
      'fname': fname,
      'lname': lname,
      'email': email,
      'password': password,
      'c_password': c_password,
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse('${Apihelper.url_base}/register'),
        body: data);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
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
      // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => WelcomePage()), (Route<dynamic> route) => false);
    } else {
      print("dsa");
      setState(() {});
      _showDialog("Thành công");
    }
  }

  void _showDialog(String messa) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Failed'),
            content: new Text('$messa'),
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
