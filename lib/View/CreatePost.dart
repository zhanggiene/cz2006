import 'dart:io';

import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/locator.dart';
import 'package:cz2006/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPhotoPage extends StatefulWidget {
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  PickedFile imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Post _post = locator.get<PostController>().post;
  //Post _post = new Post();

  @override
  openGallery(BuildContext context) async {
    var picture = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  openCamera(BuildContext context) async {
    var picture = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("choose "),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  GestureDetector(
                    child: Text("gallery"),
                    onTap: () {
                      openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget ImageView() {
    if (imageFile == null) {
      return Text("NO image selected");
    } else {
      return Image.file(File(imageFile.path), width: 100, height: 100);
    }
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageView(),
                ElevatedButton.icon(
                  onPressed: () {
                    _showDialog(context);
                  },
                  icon: Icon(Icons.add),
                  label: Text("add picture!"),
                )
              ],
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
                  locator
                      .get<PostController>()
                      .uploadPost(File(imageFile.path));
                }
              },
              child: new Text("Press here"),
            ),
          ],
        ),
      ),
    );
  }
}
