import 'dart:io';

class Post {
  /// this is the documentation 
  String userID;
  String id;
  String content;
  String title;
  DateTime time;
  double xCoordinate;
  double yCoordinate;
  String image;

  Post() {
    print("post is created");
  }

  Map<String, dynamic> toJson() {
    return {
      'title': this.title,
      'content': this.content,
      'image': this.image,
      'id': this.id,
    };
  }

  Post.fromMap(Map<String, dynamic> data) {
    title = data['title'];
    content = data['content'];
    image = data['image'];
    id = data['id'];
  }
}
