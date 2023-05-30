import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/model/Category.dart';
import 'dart:convert';

class CategoryApi {
  Future<List<Category>> getCategories() async {
    String myUrl = '${Apihelper.url_base}/categories/';
    print(myUrl);
    var response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      print("get");
      print(response.body);
    }
    return Category.listCategory(response.body);
  }

  static Future<List<Map<String, dynamic>>> fetchCategories() async {
    try {
      final response =
          await http.get(Uri.parse('${Apihelper.url_base}/categories'));
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> fetchedCategories =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
        return fetchedCategories;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return [];
  }

  static Future<bool> deleteCategory(int categoryId) async {
    try {
      final response = await http.delete(
          Uri.parse('${Apihelper.url_base}/categories/delete/$categoryId'));
      if (response.statusCode == 200) {
        print(jsonDecode(response.body)['message']);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return false;
  }

  static Future<bool> updateCategory(Map<String, dynamic>? selectedCategory,
      String updatedName, String updatedImage) async {
    if (selectedCategory != null) {
      final categoryData = {
        'name': updatedName,
        'image': updatedImage,
      };

      try {
        final response = await http.put(
          Uri.parse(
              '${Apihelper.url_base}/categories/update/${selectedCategory['id']}'),
          body: jsonEncode(categoryData),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          print(jsonDecode(response.body)['message']);
          return true;
        } else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    }

    return false;
  }

  static Future<bool> createCategory(
      String newCategoryName, String newCategoryImage) async {
    final categoryData = {
      'name': newCategoryName,
      'image': newCategoryImage,
    };

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Apihelper.url_base}/categories/create'),
      );

      request.fields['name'] = newCategoryName;

      if (newCategoryImage.isNotEmpty) {
        final imageBytes = await File(newCategoryImage).readAsBytes();
        final imageName = '${DateTime.now().millisecondsSinceEpoch}-image.jpg';
        final image = http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: imageName,
        );
        request.files.add(image);
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        print(jsonDecode(responseData)['message']);
        return true;
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return false;
  }
}
