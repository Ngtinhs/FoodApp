
import 'dart:convert';

class Cart{
  int product_id;
  int user_id;
  String name;
  int price;
  int quantity;
  String image;
  int total;

  Cart({
    required this.product_id,
    required this.user_id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.image,
    required this.total,
  });
  factory Cart.fromJson(Map<String,dynamic> json)=>Cart(
    product_id:json['product_id'],
    user_id:json['user_id'],
    name:json['name'],
    price:json['price'],
    quantity:json['quantity'],
    image:json['image'],
    total:json['total'],
  );
  static List<Cart> listCart(String jsonData){
    final data = json.decode(jsonData);
    return List<Cart>.from(data["0"].map((item)=>Cart.fromJson(item)));
  }
}