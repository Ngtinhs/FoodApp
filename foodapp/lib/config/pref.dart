
import 'package:shared_preferences/shared_preferences.dart';

class Pref {
  late bool test;
  Future<bool> checklogin() async{
    final prefs = await SharedPreferences.getInstance();
    test = prefs.containsKey("id");
    if (test){
      return true;
    }
    else {
      return false;
    }
}







}