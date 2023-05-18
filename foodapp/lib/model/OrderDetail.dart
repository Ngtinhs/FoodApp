
import 'dart:convert';

class OrderD {
  int id;
  int product_id;
  String name;
  int price;
  int quantity;
  String image;

  OrderD({
    required this.id,
    required this.product_id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
  });
  factory OrderD.fromJson(Map<String,dynamic> json)=>OrderD(
    id:json['id'],
    name:json['name'],
    product_id:json['product_id'],
    price:json['price'],
    quantity:json['quantity'],
    image:json['image'],
  );
  static List<OrderD> listOrder(String jsonData){
    final data = json.decode(jsonData);
    return List<OrderD>.from(data[0].map((item)=>OrderD.fromJson(item)));
  }
}