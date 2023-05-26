import 'package:flutter/material.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ordersuccess extends StatefulWidget {
  const Ordersuccess({Key? key}) : super(key: key);

  @override
  _OrdersuccessState createState() => _OrdersuccessState();
}

class _OrdersuccessState extends State<Ordersuccess> {
  late Pref pref = new Pref();
  late bool login;
  late String name;
  late String image;
  void checklogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool test = prefs.containsKey("id");
    if (test) {
      setState(() {
        login = true;
        name = prefs.getString('name');
        image = prefs.getString('image');
      });
    } else {
      setState(() {
        login = false;
      });
    }
  }

  TextEditingController search = new TextEditingController();
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    setState(() {
      name = "";
      login = false;
      image = "";
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    // TODO: implement initState
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text("Đặt món ăn thành công"),
            ],
          ),
          backgroundColor: Color.fromRGBO(59, 185, 52, 1),
        ),
        body: Stack(
          children: [
            Container(
                width: 390,
                height: 650,
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                    child: Container(
                  width: 390,
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 150),
                          width: 250,
                          child: Image.asset("assets/image/petlogo.png")),
                      Text(
                        "BẠN ĐÃ ĐẶT MÓN THÀNH CÔNG",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "TrippetFood chân thành cảm ơn !",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      )
                    ],
                  ),
                ))),
            Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                child: Container(
                  // height: constraints.maxHeight / 2,
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration:
                      BoxDecoration(color: Color.fromRGBO(59, 185, 52, 1)),
                  child: Center(
                      child: Text(
                    "VỀ TRANG CHỦ",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
            )
          ],
        ));
  }
}
