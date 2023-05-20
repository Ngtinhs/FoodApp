import 'package:flutter/material.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:foodapp/view/Login/Register.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key});
  @override
  State<Welcome> createState() => _Welcome();
}

class _Welcome extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          InkWell(
            child: Container(
              width: 250,
              child: Image.asset("assets/image/petlogo.png"),
            ),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height: 60,
                        width: 110,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              "ĐĂNG NHẬP",
                              style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))),
                    SizedBox(
                        height: 60,
                        width: 110,
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()));
                            },
                            child: Text(
                              "ĐĂNG KÍ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ))),
                  ],
                ),
                decoration:
                    BoxDecoration(color: Color.fromRGBO(59, 185, 52, 1)),
              )),
        ],
      ),
    );
  }
}
