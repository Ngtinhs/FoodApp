import 'dart:convert';
import 'package:foodapp/config/apihelper.dart';
import 'package:http/http.dart' as http;
import 'package:foodapp/model/Review.dart';

class ReviewApi {
  static String apiUrl = '${Apihelper.url_base}/review/';

  static Future<List<Review>> getAllReviews() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return List<Review>.from(jsonData.map((item) => Review.fromJson(item)));
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  static Future<Review> createReview(Review review) async {
    final response = await http.post(
      Uri.parse(apiUrl + 'create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(review.toJson()),
    );

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      return Review.fromJson(jsonData);
    } else {
      throw Exception('Failed to create review');
    }
  }

  static Future<Review> updateReview(int id, Review review) async {
    final response = await http.put(
      Uri.parse(apiUrl + 'update/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(review.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Review.fromJson(jsonData);
    } else {
      throw Exception('Failed to update review');
    }
  }

  static Future<void> deleteReview(int id) async {
    final response = await http.delete(Uri.parse(apiUrl + 'delete/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete review');
    }
  }
}
