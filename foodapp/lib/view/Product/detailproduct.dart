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
        title: Row(
          children: [
            Text("Chi tiết món ăn"),
          ],
        ),
        backgroundColor: Color.fromRGBO(59, 185, 52, 1),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CachedNetworkImage(
                  imageUrl: "${Apihelper.image_base}/product/${product.image}",
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
              Padding(
                padding: EdgeInsets.only(left: 8, top: 15, bottom: 10),
                child: Row(
                  children: [
                    Text("Danh mục món ăn: "),
                    Text(product.category),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, top: 15, bottom: 10),
                child: Row(
                  children: [
                    Text("Chi tiết món ăn: "),
                    Flexible(
                      child: Text(
                        product.detail,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, top: 15, bottom: 10),
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
              if (reviews.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(left: 8, top: 15, bottom: 10),
                  child: Text(
                    'Đánh giá món ăn:',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                  padding: EdgeInsets.all(8.0), // Lề 8 điểm cho tất cả các cạnh
                  child: Text(
                    'Không có đánh giá',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
        ),
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
