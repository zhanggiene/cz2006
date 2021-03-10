import 'package:cz2006/controller/PostController.dart';
import 'package:cz2006/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:cz2006/locator.dart';

class Detail extends StatelessWidget {
  final Post post;
  const Detail({this.post});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: Center(
          child: Column(
        children: [
          Image.network(post.image),
          Text(post.content),
          TextButton(
            onPressed: () {
              locator.get<PostController>().deletePost(post);
              Navigator.pop(context);
            },
            child: Text(
              "delete",
            ),
          )
        ],
      )),
    );
  }

  void onPressed() {}
}
