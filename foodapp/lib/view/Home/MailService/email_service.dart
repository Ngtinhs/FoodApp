import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static Future<void> sendRegistrationEmail(String recipientEmail) async {
    final smtpServer =
        gmail('contact.tripletfood@gmail.com', 'zfuyqewxzdhedgol');
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
}
