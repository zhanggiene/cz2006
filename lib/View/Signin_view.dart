import 'package:cz2006/View/signUp_view.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/locator.dart';
import 'package:flutter/material.dart';
//import 'package:cz2006/services/auth_servcie.dart'
import 'package:auto_size_text/auto_size_text.dart';
import 'package:email_validator/email_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';

final primaryColor = Colors.lightGreen[400];

class SigninView extends StatefulWidget {
  AuthenticationServices auth;
  VoidCallback onSignedIn;
  SigninView({this.auth, this.onSignedIn});

  @override
  _SignupViewState createState() => _SignupViewState();
}

class _SignupViewState extends State<SigninView> {
  @override
  GlobalKey<FormState> formKey =
      GlobalKey<FormState>(); // the parent class can referenc the form object
  // FormState is the type
  String _email, _password, _errorMessage;
  bool isLoading;
  bool onlyEmail;
  bool isVerified;
  @override
  void initState() {
    _errorMessage = "";
    isLoading = false;
    onlyEmail = false;
  }

  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.height;
    final _height = MediaQuery.of(context).size.height;
    return new Scaffold(
        body: SingleChildScrollView(
          child: Stack(children: <Widget>[
            Container(
              color: Colors.white,
              height: _height,
              width: _width,
              child: Column(


                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left:40.0,right:40,top: 100),
                                    child: Row(
  children: [
    Image.asset('images/logo.png'),
    AutoSizeText("mosQUITo",
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      )),
  ],
),
                                  ),
                  SizedBox(height: _height * 0.01), // no child, just to add gap
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
                                  "Email Address/admin", "abc@example.com"),
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
                              autofocus: false,
                              decoration: buildSignUpInputDecoration(
                                  "password", "must be at least 6 characters"),
                              validator: (value) {
                                if (onlyEmail == true) {
                                  return null;
                                }
                                if (value.isEmpty) {
                                  return "please enter some text";
                                } else if (value.length < 6) {
                                  return "password must be 6 characters or more";
                                }

                                return null;
                              },
                              onSaved:
                                  (val) // will be actiavted by key.currentstate.save()
                                  {
                                _password = val;
                              },
                            ),
                            SizedBox(height: _height * 0.002),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      onlyEmail = true;
                                      if (formKey.currentState.validate()) {
                                        formKey.currentState.save();
                                        reSet();

                                        onlyEmail = false;
                                      }
                                    },
                                    child: Text("forget password?"),
                                  )
                                ]),
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                    style: BorderStyle.solid),
                              ),
                              color: Colors.white,
                              textColor: primaryColor,
                              elevation: 4.0,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Text(
                                  "LOG IN",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  formKey.currentState.save();
                                  Submit();
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SignupView(widget.auth)));
                              },
                              child: Text("create account"),
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
            showCircularProgress(),
          ]),
        ));
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

//reSet is a event, must use then then catch error.
  void reSet() async {
    widget.auth
        .resetPassword(_email)
        .then((value) => Fluttertoast.showToast(
            msg: "reset link has been send to " + _email.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: primaryColor,
            textColor: Colors.white,
            fontSize: 16.0))
        .catchError((onError) {
      _showAlertDialog(onError.toString());
    });
  }

  void Submit() async {
    setState(() {
      _errorMessage = "";
      isLoading = true;
    });

    try {
      await locator
          .get<UserController>()
          .signInWithEmailAndPassword(_email, _password);
      isVerified = await widget.auth.isEmailVerified();
      setState(() {
        isLoading = false;
      });
      if (isVerified) {
        widget.onSignedIn();
      } else {
        _showAlertDialog("please verify your email");
      }
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
}
