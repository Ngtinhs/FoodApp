import 'package:flutter/material.dart';
import 'package:foodapp/api/CartApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/model/Cart.dart';
import 'package:foodapp/view/Home/home.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:foodapp/view/Product/productsearch.dart';
import 'package:foodapp/view/User/Infomation.dart';
import 'package:foodapp/view/order/formcheckout.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'listorder.dart';

class CartList extends StatefulWidget {
  const CartList({Key? key}) : super(key: key);

  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  late CartApi cartApi = new CartApi();
  late Future<List<Cart>> carts = cartApi.getCart();
  late bool checkcart = true;
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
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
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
                      "ĐẶT HÀNG",
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
