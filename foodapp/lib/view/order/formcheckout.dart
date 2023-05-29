import 'package:flutter/material.dart';
import 'package:foodapp/api/CartApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/view/Login/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodapp/view/Home/MailService/email_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Checkout extends StatefulWidget {
  const Checkout({Key? key}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  int total_cart = 0;
  TextEditingController namec = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController note = new TextEditingController();
  TextEditingController promoCodeController = TextEditingController();
  String promoCode = '';
  bool isPromoCodeApplied = false;

  void checktotal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      total_cart = pref.getInt("total_cart");
      namec.text = pref.getString("name");
      phone.text = pref.getString("phone");
      address.text = pref.getString("address");
      // address.text = pref.getString("name");
    });
  }

  void checkPromoCode() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2:8000/api/coupon/'));
    if (response.statusCode == 200) {
      final couponData = jsonDecode(response.body);
      final List<dynamic> coupons = couponData;
      final foundCoupon = coupons.firstWhere(
        (coupon) => coupon['code'] == promoCodeController.text,
        orElse: () => null,
      );
      if (foundCoupon != null && !isPromoCodeApplied) {
        // Mã khuyến mãi tồn tại
        final promotionPercentage = foundCoupon['promotion'] as int;
        // Cập nhật tổng tiền dựa trên giảm giá phần trăm
        setState(() {
          total_cart = (total_cart * (100 - promotionPercentage) / 100).round();
          isPromoCodeApplied = true;
        });
      } else {
        // Mã khuyến mãi không tồn tại
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Mã khuyến mãi không tồn tại'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Đóng'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Lỗi khi tải mã khuyến mãi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Lỗi'),
            content: Text('Không thể tải mã khuyến mãi'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Đóng'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
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
    checktotal();
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text("Thông tin đặt món"),
            ],
          ),
          backgroundColor: Color.fromRGBO(59, 185, 52, 1),
        ),
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
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
                    "TIẾN HÀNH ĐẶT MÓN",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
                ),
                onTap: () async {
                  if (namec.text != "" &&
                      phone.text != "" &&
                      address.text != "" &&
                      note.text != "") {
                    await CartApi.orderproduct(namec.text, phone.text,
                        address.text, note.text, context);

                    // Gửi thông tin đơn hàng vào email đăng nhập
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String recipientEmail = prefs.getString('email') ?? '';
                    String orderInfo = 'Thông tin đơn đặt món:\n\n';
                    orderInfo += 'Họ và tên: ${namec.text}\n';
                    orderInfo += 'Số điện thoại: ${phone.text}\n';
                    orderInfo += 'Địa chỉ: ${address.text}\n';
                    orderInfo += 'Ghi chú: ${note.text}\n';
                    orderInfo += 'Tổng tiền: ${Apihelper.money(total_cart)}\n';

                    EmailService.sendOrderInfoEmail(recipientEmail, orderInfo);
                    EmailService.sendOrderInfoEmails(recipientEmail, orderInfo);

                    // Thực hiện các xử lý khác sau khi gửi email

                    // Ví dụ: chuyển sang trang thành công hoặc xóa giỏ hàng
                  } else {
                    _showDialog("Vui lòng nhập đầy đủ các trường");
                  }
                },
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                width: 440,
                height: 500,
                padding: EdgeInsets.all(5),
                child: SingleChildScrollView(
                    child: Container(
                  width: 440,
                  height: 500,
                  // child: Text("Tổng đơn ${total_cart}"),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "THÔNG TIN ĐẶT MÓN",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                                color: Colors.deepOrangeAccent),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: namec,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                bottom: -9, left: 13, right: 13),
                            hintText: "Họ và tên",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Roboto',
                                fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 185, 52, 1),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: phone,
                          keyboardType: TextInputType.numberWithOptions(),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                bottom: -9, left: 13, right: 13),
                            hintText: "Số điện thoại",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Roboto',
                                fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 185, 52, 1),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: address,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                bottom: -9, left: 13, right: 13),
                            hintText: "Địa chỉ",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Roboto',
                                fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 185, 52, 1),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: note,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                bottom: -9, left: 13, right: 13),
                            hintText: "Ghi chú",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Roboto',
                                fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 185, 52, 1),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: promoCodeController,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                          obscureText: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                bottom: -9, left: 13, right: 13),
                            hintText: "Mã khuyến mãi, không có bỏ qua ạ",
                            hintStyle: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Roboto',
                                fontSize: 13),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(59, 185, 52, 1),
                                  width: 2.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        ElevatedButton(
                            onPressed: () {
                              checkPromoCode();
                            },
                            child: Text(
                              "Áp dụng",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: TextButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.only(
                                    top: 10, bottom: 10, left: 50, right: 50),
                                backgroundColor: Color.fromRGBO(59, 185, 52, 1),
                                shape: StadiumBorder())),
                        Text(
                          "Tổng tiền : ${Apihelper.money(total_cart)}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ))),
            SizedBox(
              height: 50,
            ),
          ],
        ));
  }

  void _showDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text('Failed'),
            content: new Text('$text'),
            actions: <Widget>[
              new ElevatedButton(
                child: new Text(
                  'Close',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
