import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/api/CartApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/model/Product.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodapp/api/ReviewApi.dart';
import 'package:foodapp/model/Review.dart';

class ProductDetail extends StatefulWidget {
  final Product product;
  const ProductDetail(this.product);

  @override
  _ProductDetailState createState() => _ProductDetailState(product);
}

class _ProductDetailState extends State<ProductDetail> {
  final Product product;
  _ProductDetailState(this.product);
  late Pref pref = new Pref();
  late bool login;
  late String name;
  late String image;
  bool isOutOfStock = false; // Thêm biến kiểm tra hết hàng
  List<Review> reviews = [];

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

  void getReviews() async {
    try {
      List<Review> fetchedReviews = await ReviewApi.getAllReviews();
      List<Review> productReviews = fetchedReviews
          .where((review) => review.productId == product.id)
          .toList();
      setState(() {
        reviews = productReviews;
      });
    } catch (error) {
      print('Error getting reviews: $error');
      // Xử lý lỗi khi không thể lấy danh sách đánh giá
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
    super.initState();
    checklogin();
    getReviews();

    // Kiểm tra số lượng sản phẩm và cập nhật giá trị cho biến isOutOfStock
    if (product.quantity == 0) {
      setState(() {
        isOutOfStock = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabBar Demo'),
      ),
      body: Column(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: "${Apihelper.image_base}/product/${product.image}",
              height: 200,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 5),
            child: Text(
              Apihelper.money(product.price),
              style: TextStyle(
                fontSize: 24,
                color: Colors.deepOrangeAccent,
              ),
            ),
          ),
          Expanded(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: 'Chi tiết'),
                      Tab(text: 'Đánh giá'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: Container(
                            // Nội dung tab "Chi tiết"
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, top: 15, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text("Danh mục món ăn: "),
                                      Text(product.category),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, top: 15, bottom: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Chi tiết món ăn:"),
                                      SizedBox(height: 5),
                                      Text(
                                        product.detail,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, top: 15, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text("Số lượng có sẳn: "),
                                      Flexible(
                                        child: Text(
                                          product.quantity.toString(),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          child: Container(
                            // Nội dung tab "Đánh giá"
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (reviews.isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 8, top: 15, bottom: 10),
                                    child: Text(
                                      'Đánh giá món ăn:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                if (reviews.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: reviews.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                            'Người đánh giá: ${reviews[index].userId.toString()}'),
                                        subtitle: Text(
                                            'Bình luận: ${reviews[index].comment}\nThời gian: ${reviews[index].created_at}'),
                                      );
                                    },
                                  ),
                                if (reviews.isEmpty)
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Không có đánh giá',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.add_shopping_cart,
            color: Colors.white,
          ),
          onPressed: () {
            if (!isOutOfStock) {
              CartApi.insert(product.id, context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isOutOfStock ? Colors.grey : Color.fromRGBO(59, 185, 52, 1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          label: Text(
            isOutOfStock ? "Hết món ăn" : "Thêm vào giỏ",
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Raleway',
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
