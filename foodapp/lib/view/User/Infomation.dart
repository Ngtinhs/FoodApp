import 'package:flutter/material.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/view/User/Changinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information extends StatefulWidget {
  const Information({Key? key}) : super(key: key);

  @override
  _InformationState createState() => _InformationState();
}

class _InformationState extends State<Information> {
  late Pref pref = new Pref();
  late bool login;
  late String name;
  late String image;
  late String address;
  late String email;
  late String phone;

  void checklogin() async {
    final prefs = await SharedPreferences.getInstance();
    bool test = prefs.containsKey("id");
    if (test) {
      setState(() {
        login = true;
        name = prefs.getString('name');
        address = prefs.getString('address');
        phone = prefs.getString('phone');
        email = prefs.getString('email');
        image = prefs.getString('image');
      });
    } else {
      setState(() {
        login = false;
      });
    }
  }

  TextEditingController search = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    checklogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Thông tin cá nhân"),
          ],
        ),
        backgroundColor: Color.fromRGBO(59, 185, 52, 1),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Center(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Color.fromRGBO(59, 185, 52, 1), width: 2),
              ),
              width: 150,
              height: 150,
              child: ClipOval(
                child: Image.network(
                  "${Apihelper.image_base}/avatar/$image",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
            child: Text(
              "Họ tên:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              "$name",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
            child: Text(
              "Số điện thoại:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              (phone != null) ? "$phone" : "",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
            child: Text(
              "Email:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              (email != null) ? "$email" : "",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 10),
            child: Text(
              "Địa chỉ:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              (address != null) ? "$address" : "",
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Changinfo(),
                    ),
                  );
                },
                child: Text(
                  "CẬP NHẬT THÔNG TIN",
                  style: TextStyle(fontSize: 18),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color.fromRGBO(59, 185, 52, 1),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
