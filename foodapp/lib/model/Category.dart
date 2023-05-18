
import 'dart:convert';

class Category {
   int id;
   String name;
   String image;

  Category({
    required this.id,required this.name, required this.image
  });
  factory Category.fromJson(Map<String,dynamic> json)=>Category(
      id:json['id'],name:json['name'],image:json['image']);

  static List<Category> listCategory(String jsonData){
    final data = json.decode(jsonData);
    return List<Category>.from(data.map((item)=>Category.fromJson(item)));
  }
   // static Product product(String jsonData){
   //   final data = json.decode(jsonData);
   //   return Product.fromJson(data[0]);
   // }
}