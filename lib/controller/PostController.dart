import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cz2006/controller/StorageRepo.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/models/Post.dart';

import '../locator.dart';

class PostController {
  Post _post;
  int PostSelected;
  AuthenticationServices _auth = locator.get<AuthenticationServices>();
  StorageService _storageService = locator.get<StorageService>();
  final CollectionReference _postsCollectionReference =
      Firestore.instance.collection('posts');

  PostController() {
    print("post is being initialzied");
    _post = new Post();
  }
  Post get post => _post;

  Future<void> uploadPosts(List<File> images) async {
    for (var i = 0; i < images.length; i++) {
      _post.images.add(await _storageService.uploadPostImage(images[i]));
    }

    //var id = _database.child("posts/").push(); // one user can create two post
    //print(_post.toJson());
    //id.set(_post.toJson());
    DocumentReference documentRef =
        await _postsCollectionReference.add(post.toJson());
    _post.id = documentRef.documentID;
    await documentRef.setData(post.toJson(), merge: true);
  }

  Future<List<Post>> getAllPosts() async {
    QuerySnapshot snapshot = await _postsCollectionReference.getDocuments();
    List<Post> postList = [];

    snapshot.documents.forEach((document) {
      Post post = Post.fromMap(document.data);
      postList.add(post);
    });
    print("all post done done");
    return postList;
  }

  void deletePost(Post post) {
    if (post.images != null) {
      for (var i = 0; i < post.images.length; i++) {
        _storageService.deleteURL(post.images[i]);
      }
    }
    _postsCollectionReference.document(post.id).delete();
    //postDeleted(post); // call back function.
  }

  getPostBytime() {}
}
