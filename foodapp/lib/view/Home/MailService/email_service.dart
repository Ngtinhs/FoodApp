import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static final SmtpServer smtpServer =
      gmail('contact.tripletfood@gmail.com', 'zfuyqewxzdhedgol');

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
}
