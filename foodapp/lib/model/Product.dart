import 'dart:convert';

import 'package:foodapp/model/Category.dart';

class Product {
  int id;
  String name;
  String image;
  int price;
  String detail;
  int quantity;
  String category;
  int category_id;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.detail,
    required this.quantity,
    required this.category,
    required this.category_id,
  });
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      price: json['price'],
      detail: json['detail'],
      quantity: json['quantity'],
      category: json['category'],
      category_id: json['category_id']);

  static List<Product> listProduct(String jsonData) {
    final data = json.decode(jsonData);
    return List<Product>.from(data.map((item) => Product.fromJson(item)));
  }

// static Product product(String jsonData){
//   final data = json.decode(jsonData);
//   return Product.fromJson(data[0]);
// }
}
