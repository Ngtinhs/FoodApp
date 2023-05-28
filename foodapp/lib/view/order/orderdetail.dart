import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/api/CartApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/model/OrderDetail.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetail extends StatefulWidget {
  final int order_id;
  const OrderDetail(this.order_id);

  @override
  _OrderDetailState createState() => _OrderDetailState(order_id);
}

class _OrderDetailState extends State<OrderDetail> {
  final int order_id;
  _OrderDetailState(this.order_id);
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
  Future<List<OrderD>> refresh() {
    // orders= cartApi.getOrder(fstatus);
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
  late Future<List<OrderD>> orders = cartApi.getOrderD(order_id);
  @override
  void initState() {
    // TODO: implement initState

    checklogin();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Chi tiết đơn đặt món"),
          ],
        ),
        backgroundColor: Color.fromRGBO(59, 185, 52, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(7),
              child: Text("Đơn đặt món",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 128, 0, 1.0),
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 600,
              child: FutureBuilder(
                  future: orders,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<OrderD>> snapshot) {
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
                            List<OrderD>? muanhieu = snapshot.data;
                            return RefreshIndicator(
                                child: ListView.builder(
                                    itemCount: muanhieu!.length,
                                    itemBuilder: (BuildContext context, index) {
                                      return InkWell(
                                          onTap: () {
                                            // Navigator.push(context, MaterialPageRoute(builder:(context) =>ProductDetail(tatcasanpham[index],)));
                                          },
                                          child: Container(
                                            width: 400,
                                            height: 150,
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width: 100,
                                                    height: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                "${Apihelper.image_base}/product/${muanhieu[index].image}"),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        width: 280,
                                                        padding:
                                                            EdgeInsets.all(5),
                                                        child: Text(
                                                            "${muanhieu[index].name}",
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Container(
                                                        width: 250,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5),
                                                                  child: Text(
                                                                    "${Apihelper.money(muanhieu[index].price)}",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              10),
                                                                  child: Text(
                                                                    "Số lượng ${muanhieu[index].quantity}",
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "${Apihelper.money(muanhieu[index].price * muanhieu[index].quantity)}",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .deepOrange),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )
                                                ]),
                                          ));
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
