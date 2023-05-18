
import 'dart:convert';

class User{
  int id;
  String name;
  String image;
  String email;
  String phone;
  int role;
  String address;

  User({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.phone,
    required this.role,
    required this.address,
  });
  factory User.fromJson(Map<String,dynamic> json)=>User(
      id:json['id'],
      name:json['name'],
      image:json['image'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      address: json['address'],
  );
  static User getUser(String jsonData){
    final data = json.decode(jsonData);
    return User.fromJson(data);
  }
}