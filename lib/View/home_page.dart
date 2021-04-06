import 'package:cz2006/View/CreatePost.dart';
import 'package:cz2006/View/Profile_view.dart';
import 'package:cz2006/View/Report_Bite.dart';
import 'package:cz2006/View/ViewPost.dart';
import 'package:cz2006/View/ViewPostMap.dart';
import 'package:cz2006/View/ViewPostMap2.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

// homePage login alr

//logined in but not verified
//https://pub.dev/packages/convex_bottom_bar/versions/2.0.0#custom-example

const primaryColor = Colors.greenAccent;

class HomePage extends StatefulWidget {
  AuthenticationServices auth;
  VoidCallback onSignOut; //other widget function can giev to this widget
  String userID, userEmail;

  HomePage({Key key, this.auth, this.onSignOut, this.userID, this.userEmail})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isEmailVerified = false;
  int selectedpage;
  final _pageOption = [
    ViewDengueMap(),
    ViewPost(),
    MainPage(),
    ViewPost(),
    ProfileView()
  ];

  @override
  void initState() {
    super.initState();
    _checkEmailVerification();
    selectedpage = 3;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white10,
      appBar: new AppBar(
        title: Text("MosQUITo", textAlign: TextAlign.center),
        actions: [
          FlatButton(
            onPressed: _signOut,
            child: Text("SignOut"),
            onLongPress: _signOut,
          )
        ],
      ),
      body: _pageOption[selectedpage],
      bottomNavigationBar: ConvexAppBar(
        items: [
          TabItem(icon: Icons.map, title: 'map'),
          TabItem(icon: Icons.note_add, title: 'posts'),
          TabItem(
              icon: Icons.home,
              activeIcon: Image.asset(
                "images/logo.png",
                color: Colors.blue,
              ),
              title: "Home",
              isIconBlend: true),
          TabItem(icon: Icons.group, title: 'community'),
          TabItem(icon: Icons.person, title: 'profile'),
        ],
        backgroundColor: Colors.white,
        activeColor: primaryColor,
        curveSize: 100,
        top: -30,
        style: TabStyle.reactCircle,
        color: Colors.grey,
        onTap: (int i) => setState(() {
          selectedpage = i;
        }),
      ),
    );
  }

  void _checkEmailVerification() async {
    _isEmailVerified = await widget.auth.isEmailVerified();
    if (!_isEmailVerified) {
      _showVerifyEmailDialog();
    }
  }

  void _showVerifyEmailDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("please verify your email"),
            content: new Text("We need you verify email to"),
            actions: [
              // ignore: deprecated_member_use
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _sendVerifyEmail();
                  },
                  child: Text("send")),
              new FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("dismiss")),
            ],
          );
        });
  }

  void _sendVerifyEmail() {
    widget.auth.sendEmailVerification();
    _showVerifyEmailSentDialog();
  }

  void _showVerifyEmailSentDialog() {
    AlertDialog(
      title: new Text("Thank you"),
      content: new Text("Link has been sent to your email"),
      actions: [
        new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("ok")),
      ],
    );
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();

      widget.onSignOut();
    } catch (e) {
      print(e);
    }
  }
}
