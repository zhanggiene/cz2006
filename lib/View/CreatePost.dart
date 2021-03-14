import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/controller/UserController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/Post.dart';
import 'package:cz2006/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
//import 'package:image_picker/image_picker.dart';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'dart:async';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  //PickedFile imageFile;
  // ignore: deprecated_member_use
  List<Asset> images = List<Asset>();
  List<File> fileImageArray = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Post _post = locator.get<PostController>().post;
  User currentUser = locator.get<UserController>().currentuser;
  //Post _post = new Post();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("upload Post"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            RaisedButton(
              child: Text("Pick images"),
              onPressed: pickImages,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(images.length, (index) {
                  print(index);
                  Asset asset = images[index];
                  return AssetThumb(
                    asset: asset,
                    width: 300,
                    height: 300,
                  );
                }),
              ),
            ),
            TextFormField(
                decoration: InputDecoration(labelText: "Title"),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "title is required";
                  }
                  return null;
                },
                onSaved: (String value) {
                  print("hi");
                  _post.title = value;
                }),
            TextFormField(
                decoration: InputDecoration(labelText: "Description"),
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                validator: (String value) {
                  if (value.isEmpty) {
                    return "description  is required";
                  }
                  return null;
                },
                onSaved: (String value) {
                  print("hi from description");
                  _post.content = value;
                }),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  //locator
                  locator.get<PostController>().uploadPosts(fileImageArray);
                  locator.get<UserController>().updateCoins(10).then((value) =>
                      {
                        AwesomeDialog(
                            context: context,
                            animType: AnimType.LEFTSLIDE,
                            headerAnimationLoop: false,
                            dialogType: DialogType.SUCCES,
                            body: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'You have made a post!',
                                  style: TextStyle(
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'You have earned 10 points',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ],
                            )),
                            btnOkOnPress: () {
                              debugPrint('OnClcik');
                              Navigator.pop(context);
                            },
                            btnOkIcon: Icons.check_circle,
                            onDissmissCallback: () {
                              debugPrint('Dialog Dissmiss from callback');
                            })
                          ..show()
                      });
                }
              },
              child: new Text("Post"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickImages() async {
List<Asset> resultList = <Asset>[];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 8,
        enableCamera: true,
        selectedAssets: images,
        materialOptions: MaterialOptions(
          actionBarTitle: " ",
          selectCircleStrokeColor: "#000000",
          actionBarColor: "#abcdef",
        ),
      );
    } on Exception catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      images = resultList;
    });

    images.forEach((imageAsset) async {
      final filePath =
          await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);

      File tempFile = File(filePath);
      if (tempFile.existsSync()) {
        fileImageArray.add(tempFile);
      }
    });
  }
}
