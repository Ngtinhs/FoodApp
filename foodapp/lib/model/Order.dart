import 'dart:convert';


class Order{

  int id;
  String name;

  String phone;
  String address;
  int total_price;
  String status;
  String note;
  String date;
  Order({
    required this.id,
  required this.name,
  required this.phone,
  required this.address,
  required this.total_price,
  required this.status,
  required this.note,
  required this.date,

  });
  factory Order.fromJson(Map<String,dynamic> json)=>Order(
    id:json['id'],
    name:json['name'],
  phone:json['phone'],
  address:json['address'],
  total_price:json['total_price'],
  status:json['status1'],
  note:json['note'],
  date:json['date'],
  );
  static List<Order> listOrder(String jsonData){
  final data = json.decode(jsonData);
  return List<Order>.from(data.map((item)=>Order.fromJson(item)));
  }
  }