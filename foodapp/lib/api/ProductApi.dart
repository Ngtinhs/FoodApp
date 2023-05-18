import 'package:http/http.dart' as http;
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/model/Product.dart';

class ProductApi {
  Future<List<Product>> getProductnew() async {
    String myurl = '${Apihelper.url_base}/product/newproduct';
    var response = await http.get(Uri.parse(myurl));
    if (response.statusCode == 200) {
      print("get");
      print(response.body);
    }
    return Product.listProduct(response.body);
  }

  Future<List<Product>> muanhieu() async {
    String myurl = '${Apihelper.url_base}/product/muanhieu';
    var response = await http.get(Uri.parse(myurl));
    if (response.statusCode == 200) {
      print("get");
      print(response.body);
    }
    return Product.listProduct(response.body);
  }

  Future<List<Product>> tatcasanpham() async {
    String myurl = '${Apihelper.url_base}/product/tatcasanpham';
    var response = await http.get(Uri.parse(myurl));
    if (response.statusCode == 200) {
      print("get");
      print(response.body);
    }
    return Product.listProduct(response.body);
  }

  Future<List<Product>> search(String keyword) async {
    String myurl = '${Apihelper.url_base}/product/searchproduct/$keyword';
    var response = await http.get(Uri.parse(myurl));
    if (response.statusCode == 200) {
      // print("get");
      // print(response.body);
    }
    return Product.listProduct(response.body);
  }

  Future<List<Product>> searchdanhmuc(int keyword) async {
    String myurl = '${Apihelper.url_base}/product/danhmuc/$keyword';
    var response = await http.get(Uri.parse(myurl));
    if (response.statusCode == 200) {
      // print("get");
      // print(response.body);
    }
    return Product.listProduct(response.body);
  }
}
