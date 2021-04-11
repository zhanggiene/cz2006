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
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UploadPhotoPage extends StatefulWidget {
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  @override
  _UploadPhotoPageState createState() => _UploadPhotoPageState();
}

class _UploadPhotoPageState extends State<UploadPhotoPage> {
  //PickedFile imageFile;
  // ignore: deprecated_member_use
  PickResult selectedPlace;
  List<Asset> images = List<Asset>();
  List<File> fileImageArray = [];
  AnimationController _animationController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Post _post = locator.get<PostController>().post;
  User currentUser = locator.get<UserController>().currentuser;
  //Post _post = new Post();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text("upload Post"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              RaisedButton(
                child: Text("Pick images"),
                onPressed: pickImages,
              ),
              Flexible(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(images.length, (index) {
                    Asset asset = images[index];
                    return AssetThumb(
                      asset: asset,
                      width: 300,
                      height: 300,
                    );
                  }),
                ),
              ),
              RaisedButton(
                child: Text("Load Google Map"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return PlacePicker(
                          apiKey: "AIzaSyCVNX_dr0ebA4zmzokVUxcizwN1NRdifcI",
                          initialPosition: LatLng(1.3521, 103.8198),
                          useCurrentLocation: true,
                          selectInitialPosition: true,
                          enableMyLocationButton: true,
                          forceAndroidLocationManager: true,

                          //usePlaceDetailSearch: true,
                          onPlacePicked: (result) {
                            selectedPlace = result;
                            Navigator.of(context).pop();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              selectedPlace == null
                  ? Container()
                  : Text(selectedPlace.formattedAddress ?? ""),
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
                    _post.content = value;
                  }),
              ButtonTheme(
                minWidth: 400.0,
                height: 100.0,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      _post.userID = currentUser.UserId;
                      _post.location = new LatLng(
                          selectedPlace.geometry.location.lat,
                          selectedPlace.geometry.location.lng);
                      // upload post
                      //locator
                      locator
                          .get<PostController>()
                          .uploadPosts(fileImageArray)
                          .then((value) {
                        fileImageArray.clear();
                        print("dispossing the map");

                        return locator
                            .get<UserController>()
                            .updateCoins(10)
                            .then((value) => {
                                  AwesomeDialog(
                                      context: context,
                                      animType: AnimType.LEFTSLIDE,
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.SUCCES,
                                      body: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'You have made a post!',
                                            style: TextStyle(
                                                fontSize: 26.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'You have earned 10 points',
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ],
                                      )),
                                      btnOkOnPress: () {
                                        debugPrint('OnClick');
                                        Navigator.pop(context);
                                      },
                                      btnOkIcon: Icons.check_circle,
                                      onDissmissCallback: () {
                                        debugPrint(
                                            'Dialog Dissmiss from callback');
                                      })
                                    ..show()
                                });
                      });
                    }
                  },
                  child: new Text("Post"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImages() async {
    List<Asset> resultList = <Asset>[];
    resultList.clear();
    fileImageArray.clear();
    print("file length is ${fileImageArray.length}");

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
