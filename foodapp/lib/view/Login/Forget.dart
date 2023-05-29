import 'package:flutter/material.dart';
import 'package:foodapp/view/Home/MailService/email_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:random_string/random_string.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  String confirmationCode = '';
  bool emailExists = false;
  bool codeCorrect = false;

  void checkEmailExists() async {
    String url = 'http://10.0.2.2:8000/api/users';
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);

    for (var user in data) {
      if (user['email'] == emailController.text) {
        setState(() {
          emailExists = true;
        });
        break;
      }
    }

    if (!emailExists) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Không tìm thấy email'),
            content: Text(
                'Địa chỉ email đã nhập không tồn tại trong hệ thống của chúng tôi.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      var bytes = utf8.encode(emailController.text);
      var digest = sha256.convert(bytes);
      confirmationCode = digest.toString().substring(0, 6);

      EmailService.sendConfirmationCode(emailController.text, confirmationCode);
    }
  }

  void checkConfirmationCode() {
    var inputCode = codeController.text;

    if (inputCode == confirmationCode) {
      setState(() {
        codeCorrect = true;
      });
      generateNewPassword(); // Tạo mật khẩu mới khi xác nhận mã thành công
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mã xác nhận không tồn tại'),
            content: Text('Vui lòng nhập mã xác nhận hợp lệ'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void generateNewPassword() async {
    var newPassword = randomAlphaNumeric(8);

    if (codeCorrect) {
      String url = 'http://10.0.2.2:8000/api/user/${emailController.text}';
      var response = await http.put(
        Uri.parse(url),
        body: {
          'password': newPassword,
        },
      );

      if (response.statusCode == 200) {
        EmailService.sendResetPasswordEmail(emailController.text, newPassword);

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Mật khẩu được cập nhật'),
              content: Text(
                  'Mật khẩu của bạn đã được cập nhật thành công. Mật khẩu mới của bạn đã được gửi đến email của bạn.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Lỗi'),
              content: Text('Không thể cập nhật mật khẩu. Vui lòng thử lại.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Mã không hợp lệ'),
            content: Text('Vui lòng nhập mã xác nhận hợp lệ.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 25),
              width: 400,
              height: 70,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(59, 185, 52, 1),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: Image.asset('assets/image/petlogo.png'),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: checkEmailExists,
                      child: Text('Gửi mã xác nhận'),
                    ),
                    SizedBox(height: 16.0),
                    Visibility(
                      visible: emailExists,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: TextFormField(
                              controller: codeController,
                              decoration: InputDecoration(
                                labelText: 'Mã xác nhận',
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: checkConfirmationCode,
                            child: Text('Xác minh mã'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
