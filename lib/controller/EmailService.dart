import 'dart:math';

import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/models/Coupon.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:cz2006/models/User.dart';

class EmailService {
  void sendMail(User user, Coupon coupon) async {
    String username = 'zhangzhuyan53@gmail.com';
    String password = 'Dhsh2019';

    String userMail = await AuthenticationServices().getMail();
    int randomNum = (Random().nextDouble() * 1000000).round();

    final smtpServer = gmail(username, password);
    final equivalentMessage = Message()
      ..from = Address(username, 'mosQUITo')
      ..recipients.add(Address(userMail))
      ..subject = 'mosQUITo | Coupon Redemption'
      ..text = "hello"
      ..html = "<p>Dear ${user.name}</p>" +
          "<p>We would like to inform you that you have redeemed this coupon:</p>" +
          '<p><b>${coupon.title}</b></p>' +
          '<img src="${coupon.imageURL}" width="100", height="100">' +
          '<p>Please use this code below to use the voucher when buying at store:</p>' +
          '<p><b>${randomNum.toString()}</b></p>' +
          '<p>Best regards,</p>' +
          '<p>MosQUITo Team</p>';

    try {
      await send(equivalentMessage, smtpServer);
    } catch (e) {
      print(e);
    }
  }
}
