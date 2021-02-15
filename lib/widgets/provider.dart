import 'package:cz2006/controller/auth_servcie.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final AuthenticationServices auth;

  Provider({Key key, Widget child, this.auth}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      // ignore: deprecated_member_use
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}
