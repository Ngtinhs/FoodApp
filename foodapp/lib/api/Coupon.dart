import 'package:http/http.dart' as http;
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/model/Coupon.dart';

class CouponApi {
  Future<List<Coupon>> getCoupon() async {
    String myUrl = '${Apihelper.url_base}/coupon/';
    print(myUrl);
    var response = await http.get(Uri.parse(myUrl));
    if (response.statusCode == 200) {
      print("get");
      print(response.body);
    }
    return Coupon.listCoupon(response.body);
  }
}
