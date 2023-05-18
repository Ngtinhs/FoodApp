import 'package:flutter/material.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:foodapp/view/Product/productsearch.dart';
import 'package:foodapp/view/User/Infomation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';
import 'listorder.dart';

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
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                    children: [
                      Center(child: Text("Xin chào !")),
                      Text(name),
                      if (image != "")
                        InkWell(
                          child: CircleAvatar(
                            child: Image.network(
                                "${Apihelper.image_base}/avatar/${image}"),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Information()));
                          },
                        )
                    ],
                  )),
              ListTile(
                title: Text("TRANG CHỦ"),
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Home()));
                },
              ),
              ListTile(
                title: Text("GIỎ HÀNG"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CartList()));
                },
              ),
              ListTile(
                title: Text("TẤT CẢ ĐƠN HÀNG"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListOrder("4")));
                },
              ),
              ListTile(
                title: Text("ĐANG XỬ LÝ"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListOrder("0")));
                },
              ),
              ListTile(
                title: Text("ĐANG GIAO HÀNG"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListOrder("1")));
                },
              ),
              ListTile(
                title: Text("THÀNH CÔNG"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListOrder("2")));
                },
              ),
              ListTile(
                title: Text("ĐÃ HỦY"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ListOrder("3")));
                },
              ),
              if (login)
                ListTile(
                  title: Text("ĐĂNG XUẤT"),
                  onTap: () {
                    logout();
                  },
                )
              else
                ListTile(
                  title: Text("ĐĂNG Nhập"),
                  onTap: () {
                    logout();
                  },
                ),
            ],
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: InkWell(
                    child: Icon(Icons.arrow_back_ios, color: Colors.pinkAccent),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  )),
              Container(
                  padding: EdgeInsets.only(top: 5, left: 20),
                  height: 40,
                  width: 300,
                  // margin: EdgeInsets.only(),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        controller: search,
                        textInputAction: TextInputAction.search,
                        //   onTap: (){
                        //
                        // },
                        onEditingComplete: () {
                          if (search.text != "")
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SearchProduct(search.text)));
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(bottom: 3, left: 13, right: 30),
                          hintText: "Tìm kiếm",
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Roboto',
                              fontSize: 13),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(243, 98, 105, 1),
                                width: 1.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: InkWell(
                          child: Icon(
                            Icons.dangerous_rounded,
                            color: Colors.pinkAccent,
                          ),
                          onTap: () {
                            search.text = "";
                          },
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: InkWell(
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.pinkAccent,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CartList()));
                  },
                ),
              ),
            ],
          ),

          backgroundColor: Colors.white,
          // leading: IconButton(icon:Icon( Icons.arrow_back_ios,color: Color.fromRGBO(243, 98, 105, 1),),onPressed: (){
          //   Navigator.pop(context);
          // },),
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
                        "BẠN ĐÃ ĐẶT HÀNG THÀNH CÔNG",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Petshop chân thành cảm ơn !",
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
                      BoxDecoration(color: Color.fromRGBO(243, 98, 105, 1)),
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
