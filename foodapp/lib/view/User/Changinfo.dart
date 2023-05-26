import 'package:flutter/material.dart';
import 'package:foodapp/api/UserApi.dart';
import 'package:foodapp/config/apihelper.dart';
import 'package:foodapp/config/pref.dart';
import 'package:foodapp/view/User/MapScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Changinfo extends StatefulWidget {
  const Changinfo({Key? key}) : super(key: key);

  @override
  _ChanginfoState createState() => _ChanginfoState();
}

class _ChanginfoState extends State<Changinfo> {
  late Pref pref = new Pref();
  late bool login;
  late String name;
  late String image;
  late String address;
  late String email;
  late String phone;
  late String selectedAddress;
  TextEditingController namec = new TextEditingController();
  TextEditingController phonec = new TextEditingController();
  TextEditingController addressc = new TextEditingController();
  late BuildContext context;
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
        namec.text = name;
        phonec.text = phone;
        addressc.text = address;
      });
    } else {
      setState(() {
        login = false;
      });
    }
  }

  void navigateToMapScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        selectedAddress = result;
        addressc.text = selectedAddress;
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
    this.context = context;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Cập nhật thông tin cá nhân"),
          ],
        ),

        backgroundColor: Color.fromRGBO(59, 185, 52, 1),
        // leading: IconButton(icon:Icon( Icons.arrow_back_ios,color: Color.fromRGBO(59, 185, 52, 1),),onPressed: (){
        //   Navigator.pop(context);
        // },),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
                width: 150,
                child: Image.network(
                  "${Apihelper.image_base}/avatar/$image",
                  width: 250,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              width: 440,
              padding: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      controller: namec,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(bottom: -9, left: 13, right: 13),
                        hintText: "Họ tên",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Roboto',
                            fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(59, 185, 52, 1),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 440,
              padding: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Container(
                    width: 350,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextFormField(
                      controller: phonec,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(bottom: -9, left: 13, right: 13),
                        hintText: "Số điện thoại",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Roboto',
                            fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(59, 185, 52, 1),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 350,
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: addressc,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(bottom: -9, left: 13, right: 13),
                        hintText: "Địa chỉ",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Roboto',
                            fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromRGBO(59, 185, 52, 1),
                              width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      navigateToMapScreen(context);
                    },
                    child: Text("Chọn vị trí"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextButton(
              onPressed: () {
                if (namec.text != "" &&
                    phonec.text != "" &&
                    addressc.text != "") {
                  UserApi.updateInfo(
                      namec.text, phonec.text, addressc.text, context);
                }
              },
              child: Text(
                "CẬP NHẬT",
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
          ],
        ),
      ),
    );
  }
}
