import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/model/Cart.dart';
import 'package:foodapp/model/Order.dart';
import 'package:foodapp/model/OrderDetail.dart';
import 'package:foodapp/view/order/cart.dart';
import 'package:foodapp/view/order/listorder.dart';
import 'package:foodapp/view/order/ordersuccess.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartApi {
  Future<List<Cart>> getCart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int user_id = pref.getInt("id");
    String myUrl = '${Apihelper.url_base}/cart/index';

    var response = await http.post(
      Uri.parse(myUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'user_id': user_id.toString(),
      }),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      pref.setInt("total_cart", data["total"]);
      pref.setInt("cart", 1);
    }
    if (response.statusCode == 404) {
      pref.setInt("cart", 0);
      // print(pref.getInt("cart").toString());
    }
    return Cart.listCart(response.body);
  }

  static insert(int product_id, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int user_id = pref.getInt("id");
    var response = await http.MultipartRequest(
        "POST", Uri.parse("${Apihelper.url_base}/cart/create"));
    response.fields['product_id'] = product_id.toString();
    response.fields['user_id'] = user_id.toString();
    var statusres = await response.send();
    var responseData = await statusres.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    if (statusres.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CartList()));
    }
  }

  static deleteone(int product_id, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int user_id = pref.getInt("id");
    var response = await http.MultipartRequest(
        "POST", Uri.parse("${Apihelper.url_base}/cart/delete"));
    response.fields['product_id'] = product_id.toString();
    response.fields['user_id'] = user_id.toString();
    var statusres = await response.send();
    var responseData = await statusres.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    if (statusres.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CartList()));
    }
  }

  static deleteproduct(int product_id, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int user_id = pref.getInt("id");
    var response = await http.MultipartRequest(
        "POST", Uri.parse("${Apihelper.url_base}/cart/deleteproduct"));
    response.fields['product_id'] = product_id.toString();
    response.fields['user_id'] = user_id.toString();
    var statusres = await response.send();
    var responseData = await statusres.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    if (statusres.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CartList()));
    }
  }

  static huydon(int order_id, BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int user_id = pref.getInt("id");
    var response = await http.MultipartRequest(
        "POST", Uri.parse("${Apihelper.url_base}/huydon"));
    response.fields['order_id'] = order_id.toString();
    var statusres = await response.send();
    var responseData = await statusres.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    if (statusres.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListOrder("3")));
    }
  }

  static orderproduct(String name, String phone, String address, String note,
      BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int user_id = pref.getInt("id");
    var response = await http.MultipartRequest(
        "POST", Uri.parse("${Apihelper.url_base}/cart/order"));
    // response.fields['product_id'] = product_id.toString();
    response.fields['user_id'] = user_id.toString();
    response.fields['name'] = name;
    response.fields['phone'] = phone;
    response.fields['address'] = address;
    response.fields['note'] = note;
    var statusres = await response.send();
    var responseData = await statusres.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    if (statusres.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Ordersuccess()));
    }
  }

  Future<List<Order>> getOrder(String status) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int user_id = pref.getInt("id");
    String myUrl = '${Apihelper.url_base}/listorder/$user_id/$status';

    var response = await http.get(
      Uri.parse(myUrl),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
    }
    if (response.statusCode == 404) {
      pref.setInt("cart", 0);
      // print(pref.getInt("cart").toString());
    }
    return Order.listOrder(response.body);
  }

  Future<List<OrderD>> getOrderD(int order) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    String myUrl = '${Apihelper.url_base}/orderdetail/$order';
    var response = await http.get(
      Uri.parse(myUrl),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
    }
    if (response.statusCode == 404) {
      pref.setInt("cart", 0);
      // print(pref.getInt("cart").toString());
    }
    return OrderD.listOrder(response.body);
  }
}
