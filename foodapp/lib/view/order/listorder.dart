import 'package:flutter/material.dart';
import 'package:foodapp/api/CartApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/model/Order.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:foodapp/view/Product/productsearch.dart';
import 'package:foodapp/view/order/orderdetail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class ListOrder extends StatefulWidget {
  final String fstatus;
  const ListOrder(this.fstatus);

  @override
  _ListOrderState createState() => _ListOrderState(fstatus);
}

class _ListOrderState extends State<ListOrder> {
  final String fstatus;
  _ListOrderState(this.fstatus);
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
  Future<List<Order>> refresh() {
    orders = cartApi.getOrder(fstatus);
    return orders;
  }

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

  CartApi cartApi = new CartApi();
  late Future<List<Order>> orders = cartApi.getOrder(fstatus);
  @override
  void initState() {
    // TODO: implement initState

    checklogin();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(59, 185, 52, 1),
                ),
                child: Column(
                  children: [
                    Center(child: Text("Xin chào !")),
                    Text(name),
                    if (image != "")
                      CircleAvatar(
                        child: Image.network(
                            "${Apihelper.image_base}/avatar/${image}"),
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
            ),
            ListTile(
              title: Text("ĐANG GIAO HÀNG"),
            ),
            ListTile(
              title: Text("THÀNH CÔNG"),
            ),
            ListTile(
              title: Text("ĐÃ HỦY"),
              onTap: () {},
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
                              color: Color.fromRGBO(59, 185, 52, 1),
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
        // leading: IconButton(icon:Icon( Icons.arrow_back_ios,color: Color.fromRGBO(59, 185, 52, 1),),onPressed: (){
        //   Navigator.pop(context);
        // },),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(7),
              child: Text("Đơn hàng",
                  style: TextStyle(
                      color: Color.fromRGBO(227, 67, 67, 1.0),
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 600,
              child: FutureBuilder(
                  future: orders,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Order>> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError) {
                            return Text("Error Data");
                          } else {
                            List<Order>? tatcasanpham = snapshot.data;
                            return RefreshIndicator(
                                child: ListView.builder(
                                    itemCount: tatcasanpham!.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderDetail(
                                                        tatcasanpham[index].id,
                                                      )));
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(bottom: 30),
                                          padding: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(186, 186,
                                                  186, 0.12549019607843137),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          "${tatcasanpham[index].name}"),
                                                      Text(Apihelper.money(
                                                          tatcasanpham[index]
                                                              .total_price))
                                                    ],
                                                  )),
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text(
                                                    "${tatcasanpham[index].phone}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pink),
                                                  )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                  padding:
                                                      EdgeInsets.only(left: 20),
                                                  child: Text(
                                                    "${tatcasanpham[index].address}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pink),
                                                  )),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 20, bottom: 20),
                                                  child: Text(
                                                    "${tatcasanpham[index].note}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.pink),
                                                  )),
                                              Container(
                                                padding: EdgeInsets.all(20),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.only(
                                                          left: 20, bottom: 20),
                                                      child: (Text(
                                                        "${tatcasanpham[index].status}",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.pink),
                                                      )),
                                                    ),
                                                    if (tatcasanpham[index]
                                                            .status ==
                                                        "Đang xử lý")
                                                      TextButton(
                                                          onPressed: () {
                                                            CartApi.huydon(
                                                                tatcasanpham[
                                                                        index]
                                                                    .id,
                                                                context);
                                                          },
                                                          child:
                                                              Text("HỦY ĐƠN")),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                onRefresh: refresh);
                          }
                      }
                    } else {
                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                refresh;
                              },
                              child: Text("Refresh"),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
