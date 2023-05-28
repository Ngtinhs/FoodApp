import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/api/CartApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/model/Cart.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:foodapp/view/order/formcheckout.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  late CartApi cartApi = new CartApi();
  late Future<List<Cart>> carts = cartApi.getCart();
  late bool checkcart = true;
  late bool isOutOfStock = false;
  Future<List<Cart>> refreshCart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      carts = cartApi.getCart();
      if (pref.getInt("cart").toString() == "1") {
        print("trang thai cart ${pref.getInt("cart")}");
        checkcart = true;
      } else {
        checkcart = false;
      }
      // if(carts.toString()=="giohangrong") checkcart=false;
    });
    return carts;
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
    refreshCart();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text("Giỏ hàng"),
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
                  child: FutureBuilder(
                    future: carts,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Cart>> snapshot) {
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
                              List<Cart>? muanhieu = snapshot.data;
                              return RefreshIndicator(
                                  child: Container(
                                    width: 390,
                                    height: 650,
                                    child: ListView.builder(
                                        itemCount: muanhieu!.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return Container(
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
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                        image:
                                                            CachedNetworkImageProvider(
                                                          "${Apihelper.image_base}/product/${muanhieu[index].image}",
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
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
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                "${Apihelper.money(muanhieu[index].price)}",
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
                                                            InkWell(
                                                              child: Icon(
                                                                Icons.delete,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onTap: () {
                                                                CartApi.deleteproduct(
                                                                    muanhieu[
                                                                            index]
                                                                        .product_id,
                                                                    context);
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  width: 25,
                                                                  height: 25,
                                                                  decoration: BoxDecoration(
                                                                      shape: BoxShape
                                                                          .circle,
                                                                      border: Border.all(
                                                                          color:
                                                                              Colors.black)),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons
                                                                          .arrow_back_ios_rounded,
                                                                      size: 10,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  CartApi.deleteone(
                                                                      muanhieu[
                                                                              index]
                                                                          .product_id,
                                                                      context);
                                                                },
                                                              ),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              if (muanhieu[
                                                                          index]
                                                                      .quantity <
                                                                  10)
                                                                Text(
                                                                  "${0}${muanhieu[index].quantity}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                )
                                                              else
                                                                Text(
                                                                    "${muanhieu[index].quantity}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15)),
                                                              SizedBox(
                                                                width: 10,
                                                              ),
                                                              InkWell(
                                                                child:
                                                                    Container(
                                                                  width: 25,
                                                                  height: 25,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          shape: BoxShape
                                                                              .circle,
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.black,
                                                                          )),
                                                                  child: Center(
                                                                    child: Icon(
                                                                      Icons.add,
                                                                      size: 10,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  CartApi.insert(
                                                                      muanhieu[
                                                                              index]
                                                                          .product_id,
                                                                      context);
                                                                },
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ]),
                                          );
                                        }),
                                  ),
                                  onRefresh: refreshCart);
                            }
                        }
                      } else {
                        return Align(
                          alignment: Alignment.center,
                          child: Center(
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
                                    refreshCart();
                                  },
                                  child: Text("Giỏ hàng trống"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ))),
            Container(
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
                    "Quay về trang chủ",
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
            ),
            if (checkcart == true)
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
                      "ĐẶT MÓN ĂN",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Checkout()));
                  },
                ),
              )
          ],
        ));
  }
}
