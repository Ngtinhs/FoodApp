import 'dart:convert';

class Coupon {
  int id;
  String code;
  int count;
  int promotion;
  String description;

  Coupon({
    required this.id,
    required this.code,
    required this.count,
    required this.promotion,
    required this.description,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json['id'],
        code: json['code'],
        count: json['count'],
        promotion: json['promotion'],
        description: json['description'],
      );

  static List<Coupon> listCoupon(String jsonData) {
    final data = json.decode(jsonData);
    return List<Coupon>.from(data.map((item) => Coupon.fromJson(item)));
  }
}
