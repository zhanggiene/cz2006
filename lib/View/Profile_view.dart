import 'dart:io';
import 'dart:ui';

import 'package:cz2006/View/InputDecoration.dart';
import 'package:cz2006/View/coupon_redemption.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/models/User.dart';
import 'package:cz2006/widgets/ProfileImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../locator.dart';
import 'coupon_redemption.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User currentUser = locator.get<UserController>().currentuser;
  final NameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    NameController.text = currentUser.name;
  }

  @override
  Widget build(BuildContext context) {
    User user;
    String userRewards;
    Future<void> getCurrentUser() async {
      user = locator.get<UserController>().currentuser;
      userRewards = user.coins.toString();
      user.imageURL = await locator.get<UserController>().downloadurl();
    }

    getCurrentUser();

    return Scaffold(
        body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Text("Edit Profile",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500)),
                    SizedBox(height: 15),
                    // Text(currentUser.name),
                    ProfileImage(
                      url: currentUser?.imageURL,
                      onTap: () async {
                        PickedFile pickedFile = await ImagePicker().getImage(
                          source: ImageSource.gallery,
                          maxWidth: 1800,
                          maxHeight: 1800,
                        );
                        File selected = File(pickedFile.path);
                        await locator
                            .get<UserController>()
                            .uploadProfilePicture(selected);
                        setState(() {});

                        print("uploading profile pic");
                      },
                    ),
                    SizedBox(height: 35),
                    // if (currentUser.isAdmin) Text("I am admin"),
                    TextField(
                      controller: NameController,
                      decoration: textInputDecoration.copyWith(
                          hintText: "Full name",
                          // errorText: NameController.text.isNotEmpty
                          //       ? "name cannot be empty"
                          //       : null,
                          hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                      // decoration: InputDecoration(
                      //     contentPadding: EdgeInsets.only(bottom: 3),
                      //     labelText: "full name",
                      //     floatingLabelBehavior: FloatingLabelBehavior.always,
                      //     errorText: NameController.text.isNotEmpty
                      //         ? "name cannot be empty"
                      //         : null,
                      //     hintStyle: TextStyle(
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.black,
                      //     )),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlineButton(
                              onPressed: () {},
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text("CANCEL",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.black))),
                          RaisedButton(
                            onPressed: () {
                              locator
                                  .get<UserController>()
                                  .updateName(NameController.text);
                              setState(() {});
                            },
                            color: Colors.green,
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 55),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ]),
                    SizedBox(height: 20.0),
                    Text(!currentUser.isAdmin ? "Rewards" : "Admin Services",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500)),
                    SizedBox(height: 10.0),
                    !currentUser.isAdmin
                        // normal user
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                  backgroundImage:
                                      AssetImage("images/coins.png"),
                                  backgroundColor: Colors.yellow,
                                  radius: 15.0),
                              Text(
                                userRewards,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 70.0,
                              ),
                              RaisedButton(
                                onPressed: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return CouponRedemptionView();
                                  })).then((value) => setState(() {
                                        getCurrentUser();
                                      }));
                                },
                                color: Colors.green,
                                child: Text(
                                  "REDEEM",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.white),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 43),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ],
                          )
                        // admin services
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CouponRedemptionView();
                                    }));
                                  },
                                  color: Colors.green,
                                  child: Text(
                                    "MANAGE COUPON",
                                    style: TextStyle(
                                        fontSize: 14,
                                        letterSpacing: 2.2,
                                        color: Colors.white),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 43),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ],
                          )
                  ],
                ))));
  } //build
}
