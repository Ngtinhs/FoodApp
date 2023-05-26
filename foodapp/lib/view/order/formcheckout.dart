import 'package:flutter/material.dart';
import 'package:foodapp/api/CartApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int total_cart = 0;
  TextEditingController namec = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController note = new TextEditingController();

  void checktotal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      total_cart = pref.getInt("total_cart");
      namec.text = pref.getString("name");
      phone.text = pref.getString("phone");
      address.text = pref.getString("address");
      // address.text = pref.getString("name");
    });
  }

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
    checktotal();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text("Form checkout"),
            ],
          ),
          backgroundColor: Color.fromRGBO(59, 185, 52, 1),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
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
                    "TIẾN HÀNH ĐẶT HÀNG",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
                onTap: () {
                  if (namec.text != "" &&
                      phone.text != "" &&
                      address.text != "" &&
                      note.text != "") {
                    CartApi.orderproduct(namec.text, phone.text, address.text,
                        note.text, context);
                  } else {
                    _showDialog("Vui lòng nhập đầy đủ các trường");
                  }
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                width: 440,
                height: 500,
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                    child: Container(
                  width: 440,
                  height: 500,
                  // child: Text("Tổng đơn ${total_cart}"),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "THÔNG TIN ĐẶT HÀNG",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: Colors.deepOrangeAccent),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: namec,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Họ và tên",
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
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: phone,
                        keyboardType: TextInputType.numberWithOptions(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Số điện thoại",
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
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: address,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Địa chỉ",
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
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: note,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                        ),
                        obscureText: false,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: -9, left: 13, right: 13),
                          hintText: "Ghi chú",
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
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Tổng tiền : ${Apihelper.money(total_cart)}",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ))),
            SizedBox(
              height: 50,
            ),
          ],
        ));
  }

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Failed'),
            content: new Text('$text'),
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
