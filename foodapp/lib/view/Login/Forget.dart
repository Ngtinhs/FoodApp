import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodapp/view/Home/MailService/email_service.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  ForgetState _forgetState = ForgetState.enterEmail;
  String _email = '';
  String _verificationCode = '';

  void _sendVerificationCode() {
    // Tạo mã xác nhận ngẫu nhiên
    String verificationCode = _generateRandomCode();

    // Gọi phương thức sendResetPasswordEmail từ EmailService để gửi email với mã xác nhận
    EmailService.sendResetPasswordEmail(_email, verificationCode);

    // Chuyển sang trạng thái nhập mã xác nhận
    setState(() {
      _forgetState = ForgetState.enterVerificationCode;
      _verificationCode = verificationCode;
    });
  }

  void _resetPassword() {
    // Kiểm tra xem mã xác nhận có khớp với mã đã gửi đi không
    if (_verificationCode == 'mã_xác_nhận') {
      // Tạo mật khẩu mới ngẫu nhiên
      String newPassword = _generateRandomPassword();
      // Gửi mật khẩu mới đến email
      EmailService.sendResetPasswordEmail(_email, newPassword);
      // Chuyển sang trang đăng nhập (có thể sử dụng Navigator để điều hướng)
      // ...
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quên mật khẩu'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_forgetState == ForgetState.enterEmail)
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _sendVerificationCode,
                    child: Text('Gửi mã xác nhận'),
                  ),
                ],
              ),
            if (_forgetState == ForgetState.enterVerificationCode)
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _verificationCode = value;
                      });
                    },
                    decoration: InputDecoration(labelText: 'Mã xác nhận'),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _resetPassword,
                    child: Text('Đặt lại mật khẩu'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // Phương thức tạo mã xác nhận ngẫu nhiên
  String _generateRandomCode() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final codeLength = 6;

    String code = '';

    for (var i = 0; i < codeLength; i++) {
      code += chars[random.nextInt(chars.length)];
    }

    return code;
  }

  // Phương thức tạo mật khẩu ngẫu nhiên
  String _generateRandomPassword() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    final passwordLength = 10;

    String password = '';

    for (var i = 0; i < passwordLength; i++) {
      password += chars[random.nextInt(chars.length)];
    }

    return password;
  }
}

enum ForgetState {
  enterEmail,
  enterVerificationCode,
}
