import 'package:cz2006/View/onBoard_screen.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/controller/rootPage.dart';
import 'package:cz2006/locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//check if already login, if login then go homepage, if not show login/signup page

int init;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  init = await preferences.getInt('init');
  await preferences.setInt('init', 1);
  print("se to 1");
  setup();
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
        primarySwatch: Colors.green,
      ),
      //home: new RootPage(auth: new AuthenticationServices()),
      initialRoute: init == 1 || init == null ? 'onBoard' : 'home',
      routes: {
        'home': (context) => new RootPage(auth: new AuthenticationServices()),
        'onBoard': (context) => OnBoardScreen(),
      },
    );
  }
}
