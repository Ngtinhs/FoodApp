import 'dart:convert';

class Review {
  int id;
  int productId;
  int userId;
  String comment;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.comment,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        productId: json['product_id'],
        userId: json['user_id'],
        comment: json['comment'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'user_id': userId,
        'comment': comment,
      };

  static List<Review> listFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Review>.from(data.map((item) => Review.fromJson(item)));
  }
}
