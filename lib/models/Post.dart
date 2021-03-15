import 'dart:io';
import 'dart:convert';
import 'dart:core';

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

  Post() {
    print("post is created");
    images = [];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'content': this.content,
      'image': jsonEncode(this.images),
      'id': this.id,
      'userID': this.userID,
      'time': DateTime.now().microsecondsSinceEpoch
    };
  }

  Post.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    content = data['content'];
    print(data['image']);
    images = (jsonDecode(data['image']) as List<dynamic>).cast<String>();
    id = data['id'];
    userID = data['userID'];
    timeOfCreation = data['time'];
  }
}
