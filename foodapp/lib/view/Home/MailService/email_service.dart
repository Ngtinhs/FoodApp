import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static final SmtpServer smtpServer =
      gmail('contact.tripletfood@gmail.com', 'zfuyqewxzdhedgol');

// Mail tạo tài khoản thành công
  static Future<void> sendRegistrationEmail(String recipientEmail) async {
    final message = Message()
      ..from = Address('contact.tripletfood@gmail.com')
      ..recipients.add(recipientEmail)
      ..subject = 'Tạo tài khoản thành công'
      ..text = 'Bạn đã tạo tài khoản thành công';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

//Mail đặt món thành công
  static Future<void> sendOrderInfoEmail(
      String recipientEmail, String orderDetails) async {
    final message = Message()
      ..from = Address('contact.tripletfood@gmail.com')
      ..recipients.add(recipientEmail)
      ..subject = 'Đặt món ăn thành công'
      ..text = '$orderDetails';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

//Mail có đơn đặt món mới dành cho Admin
  static Future<void> sendOrderInfoEmails(
      String recipientEmail, String orderDetails) async {
    final message = Message()
      ..from = Address('contact.tripletfood@gmail.com')
      ..recipients.add('tripletfood.vn@gmail.com')
      ..subject = 'Đơn đặt món mới'
      ..text = '$orderDetails';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

//Mail gửi mã xác nhận
  static Future<void> sendConfirmationCode(
      String recipientEmail, String code) async {
    final message = Message()
      ..from = Address('contact.tripletfood@gmail.com')
      ..recipients.add(recipientEmail)
      ..subject = 'Mã xác nhận mật khẩu'
      ..text = 'Mã xác nhận của bạn là: $code';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

//Mail nhận mật khẩu mới
  static Future<void> sendResetPasswordEmail(
      String recipientEmail, String newPassword) async {
    final message = Message()
      ..from = Address('contact.tripletfood@gmail.com')
      ..recipients.add(recipientEmail)
      ..subject = 'Mật khẩu mới'
      ..text =
          'Mật khẩu của bạn đã được đặt lại thành công. Mật khẩu mới của bạn là: $newPassword';

    try {
      final sendReport = await send(message, smtpServer);
      print('Email sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }
}
