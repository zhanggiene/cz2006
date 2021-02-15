import 'dart:io';
import 'dart:ui';

import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/models/User.dart';
import 'package:cz2006/widgets/ProfileImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../locator.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  User currentUser = locator.get<UserController>().currentuser;
  final NameController = TextEditingController();
  @override
   @override
  void initState() { 
    super.initState();
    NameController.text=currentUser.name;
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
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
                    SizedBox(
                      height: 15,
                    ),
                    Text(currentUser.name),
                    TextButton(
                        child: Text("EDIT"),
                        style: TextButton.styleFrom(
                          primary: Colors.green,
                        ),
                        onPressed: () => showBarModalBottomSheet(
                              expand: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Text("hi"),
                            )),
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
                    TextField(
                      controller: NameController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: "full name",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          errorText: NameController.text.isNotEmpty
                              ? "name cannot be empty"
                              : null,
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          )),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlineButton(
                              onPressed: () {},
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text("CONCEL",
                                  style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 2.2,
                                      color: Colors.black))),
                          RaisedButton(
                            onPressed: () {
                              locator
                                  .get<UserController>()
                                  .updateName(NameController.text);
                              setState(() {
                                
                              });
                            },
                            color: Colors.green,
                            child: Text(
                              "SAVE",
                              style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.white),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ])
                  ],
                ))));
  } //build
}
