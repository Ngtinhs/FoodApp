import 'dart:convert';

class Review {
  int id;
  int productId;
  String userId;
  String comment;
  String created_at;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.comment,
    required this.created_at,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        productId: json['product_id'],
        userId: json['user_id'],
        comment: json['comment'],
        created_at: json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'user_id': userId,
        'comment': comment,
        'created_at': created_at,
      };

  static List<Review> listFromJson(String jsonData) {
    final data = json.decode(jsonData);
    return List<Review>.from(data.map((item) => Review.fromJson(item)));
  }
}
