import 'package:flutter/material.dart';
import 'package:foodapp/api/CategoryApi.dart';
import 'package:foodapp/api/ProductApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/model/Category.dart';
import 'package:foodapp/model/Product.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:foodapp/view/Product/detailproduct.dart';
import 'package:foodapp/view/Product/productcategory.dart';
import 'package:foodapp/view/Product/productsearch.dart';
import 'package:foodapp/view/User/Infomation.dart';
import 'package:foodapp/view/order/cart.dart';
import 'package:foodapp/view/order/listorder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  late CategoryApi categoryapi = new CategoryApi();
  late ProductApi productapi = new ProductApi();

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

  late Future<List<Category>> categories = categoryapi.getCategories();
  late Future<List<Product>> muanhieu = productapi.muanhieu();
  late Future<List<Product>> tatcasanpham = productapi.tatcasanpham();
  late Future<List<Product>> sanphammoi = productapi.getProductnew();
  TextEditingController search = new TextEditingController();
  //refresh danh mục sản phẩm
  Future<List<Category>> refreshCate() async {
    setState(() {
      categories = categoryapi.getCategories();
      sanphammoi = productapi.getProductnew();
    });
    return categories;
  }

  //refresh sản phẩm mới
  Future<List<Product>> refreshProductnew() async {
    setState(() {
      sanphammoi = productapi.getProductnew();
    });
    return sanphammoi;
  }

  Future<List<Product>> refreshmuanhieu() async {
    setState(() {
      muanhieu = productapi.muanhieu();
    });
    return sanphammoi;
  }

  Future<List<Product>> refreshtatca() async {
    setState(() {
      tatcasanpham = productapi.tatcasanpham();
    });
    return tatcasanpham;
  }

  @override
  initState() {
    checklogin();
    refreshCate();
    refreshProductnew();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOrder("4")));
                    },
                  ),
                  ListTile(
                    title: Text("ĐANG XỬ LÝ"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOrder("0")));
                    },
                  ),
                  ListTile(
                    title: Text("ĐANG GIAO HÀNG"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOrder("1")));
                    },
                  ),
                  ListTile(
                    title: Text("THÀNH CÔNG"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOrder("2")));
                    },
                  ),
                  ListTile(
                    title: Text("ĐÃ HỦY"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListOrder("3")));
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
                    child: Builder(
                        builder: (BuildContext context) => IconButton(
                              onPressed: () =>
                                  Scaffold.of(context).openDrawer(),
                              icon: Icon(Icons.menu, color: Colors.pinkAccent),
                            )),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      height: 40,
                      width: 280,
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
                              contentPadding: EdgeInsets.only(
                                  bottom: 3, left: 13, right: 30),
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartList()));
                      },
                    ),
                  ),
                ],
              ),

              backgroundColor: Colors.white,
              // leading: IconButton(icon:Icon( Icons.arrow_back_ios,color: Color.fromRGBO(59, 185, 52, 1),),onPressed: (){
              //   Navigator.pop(context);
              // },),
              bottom: TabBar(
                tabs: [
                  Tab(child: Text("Trang chủ")),
                  Tab(child: Text("Bán chạy")),
                  Tab(child: Text("Sản phẩm")),
                ],
              ),
            ),
            body: TabBarView(children: [
              Container(
                width: 360,
                // height: 580,
                child: SingleChildScrollView(
                    // physics: ScrollPhysics(),
                    child: ConstrainedBox(
                  constraints: BoxConstraints(),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15, bottom: 10),
                        child: Text(
                          "DANH MỤC MÓN ĂN",
                          style: TextStyle(
                              color: Color.fromRGBO(227, 67, 67, 1.0),
                              fontSize: 15),
                        ),
                      ),
                      Container(
                          width: 360, height: 380, child: buildFutureBuilder()),
                    ],
                  ),
                )),
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text("MÓN ĂN BÁN CHẠY",
                          style: TextStyle(
                              color: Color.fromRGBO(227, 67, 67, 1.0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: 600,
                      child: FutureBuilder(
                          future: muanhieu,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Product>> snapshot) {
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
                                    List<Product>? muanhieu = snapshot.data;
                                    return RefreshIndicator(
                                        child: GridView.builder(
                                            itemCount: muanhieu!.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 5.0,
                                              mainAxisSpacing: 10,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetail(
                                                                muanhieu[index],
                                                              )));
                                                },
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          186,
                                                          186,
                                                          186,
                                                          0.12549019607843137),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          height: 100,
                                                          child: Image.network(
                                                              "${Apihelper.image_base}/product/${muanhieu[index].image}")),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15,
                                                                top: 10),
                                                        child: Text(
                                                            muanhieu[index]
                                                                .name),
                                                      ),
                                                      Container(
                                                          child: Text(
                                                        Apihelper.money(
                                                            muanhieu[index]
                                                                .price),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.pink),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                        onRefresh: refreshmuanhieu);
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
                                        refreshProductnew();
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
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(7),
                      child: Text("TẤT CẢ MÓN ĂN",
                          style: TextStyle(
                              color: Color.fromRGBO(227, 67, 67, 1.0),
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      height: 600,
                      child: FutureBuilder(
                          future: tatcasanpham,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Product>> snapshot) {
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
                                    List<Product>? tatcasanpham = snapshot.data;
                                    return RefreshIndicator(
                                        child: GridView.builder(
                                            itemCount: tatcasanpham!.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 5.0,
                                              mainAxisSpacing: 10,
                                            ),
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              return InkWell(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProductDetail(
                                                                tatcasanpham[
                                                                    index],
                                                              )));
                                                },
                                                child: Container(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  decoration: BoxDecoration(
                                                      color: Color.fromRGBO(
                                                          186,
                                                          186,
                                                          186,
                                                          0.12549019607843137),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20))),
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          height: 100,
                                                          child: Image.network(
                                                              "${Apihelper.image_base}/product/${tatcasanpham[index].image}")),
                                                      Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                right: 15,
                                                                top: 10),
                                                        child: Text(
                                                            tatcasanpham[index]
                                                                .name),
                                                      ),
                                                      Container(
                                                          child: Text(
                                                        Apihelper.money(
                                                            tatcasanpham[index]
                                                                .price),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.pink),
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                        onRefresh: refreshmuanhieu);
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
                                        refreshtatca();
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
            ])));
  }

  FutureBuilder<List<Category>> buildFutureBuilder() {
    return FutureBuilder(
        future: categories,
        builder: (BuildContext contex, AsyncSnapshot<List<Category>> snapshot) {
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
                  List<Category>? category = snapshot.data;
                  return RefreshIndicator(
                      child: GridView.builder(
                          itemCount: category!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.0,
                            mainAxisSpacing: 5.0,
                          ),
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                                width: 180,
                                margin: EdgeInsets.only(
                                    left: 5, right: 5, bottom: 5, top: 5),
                                padding: EdgeInsets.all(10),
                                // color: Colors.deepOrange,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0.5, 0.1),
                                          blurRadius: 0.5,
                                          spreadRadius: 1.0,
                                          color: Colors.grey),
                                    ],
                                    color: Color.fromRGBO(241, 241, 241, 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: Column(
                                  children: [
                                    InkWell(
                                      child: Container(
                                          width: 100,
                                          child: Image.network(
                                              "${Apihelper.image_base}/categories/${category[index].image}")),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SearchDanhMuc(
                                                        category[index].id)));
                                      },
                                    ),
                                    // Image.asset("assets/image/${category[index].image}")),
                                    Text(
                                      "${category[index].name} ",
                                      style: TextStyle(
                                        color: Color.fromRGBO(245, 90, 90, 1.0),
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                      onRefresh: refreshCate);
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
                      refreshCate();
                    },
                    child: Text("Refresh"),
                  ),
                ],
              ),
            );
          }
        });
  }
}
