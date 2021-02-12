import 'package:cz2006/home_page.dart';
import 'package:cz2006/services/auth_servcie.dart';
import 'package:cz2006/services/views/open_views/Signin_view.dart';
import 'package:flutter/material.dart';
import 'package:cz2006/services/views/open_views/signUp_view.dart';

//check if already login, if login then go homepage, if not show login/signup page


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new myHomeApp(auth: new AuthenticationServices()),
    );
  }
}

class myHomeApp extends StatefulWidget {
  // auth is constantly changing
  myHomeApp({this.auth});
  AuthenticationServices auth;

  @override
  _myHomeAppState createState() => _myHomeAppState();
}

enum Authstatus { NOT_LOGIN, LOGIN, UNDETERMINED }

// ignore: camel_case_types
class _myHomeAppState extends State<myHomeApp> {
  // the  state is the three attribute _userID, _userEmail
  Authstatus authStatus = Authstatus.UNDETERMINED;
  String _userID = "", _userEmail = "";
  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) => {
          setState(() {
            if (user != null) {
              // login alr
              _userID = user?.uid; //
              print(_userID);
              _userEmail = user?.email;
            }
            // havnt logged in
            authStatus =
                user?.uid == null ? Authstatus.NOT_LOGIN : Authstatus.LOGIN;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case Authstatus.UNDETERMINED:
        return _showLoading();
        break;

      case Authstatus.NOT_LOGIN:
        return new SigninView(auth: widget.auth, onSignedIn: _onSignedIn);
      case Authstatus.LOGIN:
        return new HomePage(
          userID: _userID,
          userEmail: _userEmail,
          auth: widget.auth,
          onSignOut: _onSignedOut,
        );
      default:
        return _showLoading();
    }
  }

  void _onSignedIn() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userID = user.uid.toString();
        _userEmail = user.email.toString();
      });
    });

    setState(() {
      authStatus = Authstatus.LOGIN;
    });
  }

  void _onSignedOut() {
    setState(() {
      authStatus = Authstatus.NOT_LOGIN;
      _userID = _userEmail = "";
    });
  }

  Widget _showLoading() {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    ));
  }
}
