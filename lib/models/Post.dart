import 'dart:io';
import 'dart:convert';

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
    };
  }

  Post.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    content = data['content'];
    print(data['image']);
    images = (jsonDecode(data['image']) as List<dynamic>).cast<String>();
    id = data['id'];
  }
}
