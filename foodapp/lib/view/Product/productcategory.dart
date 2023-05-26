import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/api/ProductApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/model/Product.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:foodapp/view/Product/detailproduct.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchDanhMuc extends StatefulWidget {
  final int keyword;

  const SearchDanhMuc(this.keyword);
  @override
  _SearchDanhMucState createState() => _SearchDanhMucState(this.keyword);
}

class _SearchDanhMucState extends State<SearchDanhMuc> {
  final int keyword;
  _SearchDanhMucState(this.keyword);
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

  late ProductApi productApi = new ProductApi();
  late Future<List<Product>> sanpham = productApi.searchdanhmuc(keyword);

  Future<List<Product>> refreshsearch() async {
    setState(() {
      sanpham = productApi.searchdanhmuc(keyword);
    });
    return sanpham;
  }

  @override
  initState() {
    checklogin();
    refreshsearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Danh sách món ăn"),
          ],
        ),
        backgroundColor: Color.fromRGBO(59, 185, 52, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(7),
              child: Text("MÓN ĂN CÓ TRONG DANH MỤC",
                  style: TextStyle(
                      color: Color.fromRGBO(0, 128, 0, 1.0),
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
            ),
            Container(
              height: 600,
              child: FutureBuilder(
                  future: sanpham,
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
                                    itemBuilder: (BuildContext context, index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProductDetail(
                                                        tatcasanpham[index],
                                                      )));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(top: 5),
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(186, 186,
                                                  186, 0.12549019607843137),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          child: Column(
                                            children: [
                                              Container(
                                                  height: 100,
                                                  child: CachedNetworkImage(
                                                      imageUrl:
                                                          "${Apihelper.image_base}/product/${tatcasanpham[index].image}")),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 15,
                                                    top: 10),
                                                child: Text(
                                                    tatcasanpham[index].name),
                                              ),
                                              Container(
                                                  child: Text(
                                                Apihelper.money(
                                                    tatcasanpham[index].price),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.pink),
                                              ))
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                onRefresh: refreshsearch);
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
                                refreshsearch;
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
