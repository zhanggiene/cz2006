import 'dart:io';
import 'dart:convert';
import 'dart:core';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  /// this is the documentation
  String userID;
  String id;
  String content;
  String title;
  DateTime time;
  double xCoordinate;
  double yCoordinate;
  List<String> images = [];
  int timeOfCreation;
  LatLng location;
  List<String> likedBy = [];

  Post() {
    userID = "";
    id = "";
    content = "";
    title = "";
    xCoordinate = 0;
    yCoordinate = 0;

    print("post is created");
    images = [];
    likedBy = [];
  }

  void addLikedUserId(String userID) {
    likedBy.add(userID);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'content': this.content,
      'image': jsonEncode(this.images),
      'likedBy': jsonEncode(this.content),
      'id': this.id,
      'userID': this.userID,
      'time': DateTime.now().microsecondsSinceEpoch,
      'location': GeoPoint(location.latitude, location.longitude)
    };
  }

  Post.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    content = data['content'];
    images = (jsonDecode(data['image']) as List<dynamic>).cast<String>();

    id = data['id'];
    userID = data['userID'];
    timeOfCreation = data['time'];
    location =
        new LatLng(data['location'].latitude, data['location'].longitude);
  }
}
