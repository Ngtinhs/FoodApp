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
  String sortBy = "mới nhất"; // Biến để theo dõi lựa chọn sắp xếp đánh giá
  TextEditingController reviewController = TextEditingController();

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
    List<Review> sortedReviews = [
      ...reviews
    ]; // Tạo một bản sao của danh sách đánh giá

    if (sortBy == "mới nhất") {
      sortedReviews.sort((a, b) => b.created_at?.compareTo(a.created_at!) ?? 0);
    } else if (sortBy == "cũ nhất") {
      sortedReviews.sort((a, b) => a.created_at?.compareTo(b.created_at!) ?? 0);
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Chi tiết món ăn"),
          ],
        ),
        backgroundColor: Color.fromRGBO(59, 185, 52, 1),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                sortBy = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: "mới nhất",
                child: Text('Mới nhất'),
              ),
              PopupMenuItem<String>(
                value: "cũ nhất",
                child: Text('Cũ nhất'),
              ),
            ],
            icon: Icon(Icons.sort),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: "${Apihelper.image_base}/product/${product.image}",
              height: 170,
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
                                      Text("Danh mục món ăn: ",
                                          style: TextStyle(fontSize: 16)),
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
                                      Text("Chi tiết món ăn:",
                                          style: TextStyle(fontSize: 16)),
                                      SizedBox(height: 5),
                                      Text(
                                        product.detail,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.5)),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, top: 15, bottom: 10),
                                  child: Row(
                                    children: [
                                      Text("Số lượng có sẳn: ",
                                          style: TextStyle(fontSize: 16)),
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
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: 8, top: 15, bottom: 10),
                                  child: Text('Đánh giá món ăn:',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: reviewController,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(
                                                bottom: -9,
                                                left: 13,
                                                right: 13),
                                            hintText: "Nhập đánh giá",
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontFamily: 'Roboto',
                                                fontSize: 13),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: BorderSide(),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Color.fromRGBO(
                                                      59, 185, 52, 1),
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Các xử lý khi nhấn nút đăng
                                        },
                                        child: Text('Đăng'),
                                        style: TextButton.styleFrom(
                                          backgroundColor:
                                              Color.fromRGBO(59, 185, 52, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (reviews.isNotEmpty)
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: sortedReviews.length,
                                    itemBuilder: (context, index) {
                                      return Card(
                                        elevation: 3, // Độ nổi của card
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              2), // Bo góc của card
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            'Nội dung: ${sortedReviews[index].comment.toString()}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          subtitle: Text(
                                            'Tên: ${sortedReviews[index].userId}\n Thời gian: ${sortedReviews[index].created_at}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
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
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(18.0),
            // ),
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
