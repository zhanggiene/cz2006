import 'dart:collection';

import 'package:cz2006/models/Post.dart';
import 'package:flutter/material.dart';

class PostNotifier with ChangeNotifier {
  List<Post> _postList = [];
  Post _currentPost;
  UnmodifiableListView<Post> get foodList => UnmodifiableListView(_postList);
  Post get currentFood => _currentPost;
  set PostList(List<Post> PostList) {
    _postList = foodList;
  }

  set currentPost(Post post) {
    _currentPost = post;
    notifyListeners();
  }
}
