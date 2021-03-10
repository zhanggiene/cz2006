import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/locator.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

final primaryColor = Colors.green[400];

class SignupView extends StatefulWidget {
  final AuthenticationServices _auth;
  SignupView(this._auth);

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  @override
  final formKey =
      GlobalKey<FormState>(); // the parent class can referenc the form object
  // FormState is the type
  String _email, _password, _name;
  bool isLoading;

  void initState() {
    isLoading = false;
  }

  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("sign up"),
      ),
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
              child: Column(children: [
            SizedBox(height: _height * 0.05), // no child, just to add gap
            AutoSizeText("Welcome",
                maxLines: 1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.grey,
                )),
            SizedBox(height: _height * 0.05),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(fontSize: 15.0),
                        keyboardType: TextInputType.emailAddress,
                        decoration: buildSignUpInputDecoration(
                            "Email Address", "abc@example.com"),
                        validator: (value) {
                          // will be called by key.currentState.validate()
                          if (value.isEmpty) {
                            return "please enter some text";
                          } else if (!EmailValidator.validate(value)) {
                            return "enter a valid email address";
                          }
                          return null;
                        },
                        onSaved:
                            (val) // will be actiavted by key.currentstate.save()
                            {
                          _email = val;
                        },
                      ),
                      SizedBox(height: _height * 0.01),
                      TextFormField(
                        style: TextStyle(fontSize: 15.0),
                        obscureText: true,
                        decoration: buildSignUpInputDecoration(
                            "password", "must be at least 6 characters"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "please enter some text";
                          } else if (value.length < 6) {
                            return "password must be 6 characters or more";
                          }
                          _password = value;

                          return null;
                        },
                      ),
                      SizedBox(height: _height * 0.01),
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(fontSize: 15.0),
                        decoration: buildSignUpInputDecoration(
                            "confirm password", "enter your password again"),
                        validator: (value) {
                          if (value != _password) {
                            return "password must match";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: _height * 0.01),
                      TextFormField(
                        style: TextStyle(fontSize: 15.0),
                        decoration:
                            buildSignUpInputDecoration("name", "Xiaoming"),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "please enter some text";
                          }
                          return null;
                        },
                        onSaved:
                            (val) // will be actiavted by key.currentstate.save()
                            {
                          _name = val;
                        },
                      ),
                      SizedBox(height: _height * 0.07),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: primaryColor,
                        textColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "CREATE ACCOUNT",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            formKey.currentState.save();
                            SignUp();
                          }
                        },
                      ),
                    ],
                  )),
            )
          ])),
          showCircularProgress(),
        ]),
      ),
    );
  }

  void SignUp() async {
    setState(() {
      isLoading = true;
    });

    String userID = "";
    try {
      locator
          .get<UserController>()
          .signUp(_email, _password, _name)
          .then((value) {
        Fluttertoast.showToast(
            msg: "verification link  has been send to " + _email.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: primaryColor,
            textColor: Colors.white,
            fontSize: 16.0);

        formKey.currentState.reset();
        setState(() {
          isLoading = false;
        });
        Navigator.pop(context);
      });

      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      _showAlertDialog(e.code);
    } finally {
      print("finished with exceptions");
    }
  }

  InputDecoration buildSignUpInputDecoration(label, hintText) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.white,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green, width: 1.0)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 1),
      ),
      contentPadding: const EdgeInsets.only(left: 10.0, bottom: 5.0, top: 5.0),
    );
  }

  Widget showCircularProgress() {
    if (isLoading)
      return Center(
        child: CircularProgressIndicator(),
      );

    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void _showAlertDialog(String message) async {
    print(message);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("wrong login information"),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
