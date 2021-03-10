import 'dart:io';

import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  FirebaseStorage storage =FirebaseStorage(storageBucket: "gs://cz2006-dsai.appspot.com");
  //FirebaseStorage storage = FirebaseStorage.instance;
  AuthenticationServices _auth = locator.get<AuthenticationServices>();
  Future<String> uploadProfile(File file) async {
    var user = await _auth.getCurrentUser();
    var storageRef = storage.ref().child("user/profiles/${user.UserId}");
    var uploadTask = storageRef.putFile(file);
    var completefTask = await uploadTask.onComplete;
    String downloadUrl = await completefTask.ref.getDownloadURL();
    return downloadUrl;
  }
  

  Future<String> uploadPostImage(File file) async {
    var storageRef = storage.ref().child("posts");
    var timeKey = new DateTime.now();
    var uploadTask =
        storageRef.child(timeKey.toString() + '.jpg').putFile(file);
    var completefTask = await uploadTask.onComplete;
    String downloadUrl = await completefTask.ref.getDownloadURL();
    print("uploading");
    return downloadUrl;
  }

  Future<String> getUserProfileImage(String uid) async {
    return await storage.ref().child("user/profiles/$uid").getDownloadURL();
  }

  Future<void> deleteURL(String url) async
  {

    StorageReference storageReference =
        await storage.getReferenceFromUrl(url);
        await storageReference.delete();

  }

}
