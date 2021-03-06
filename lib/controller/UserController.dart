import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cz2006/controller/StorageRepo.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/models/User.dart';

import '../locator.dart';

class UserController {
  User _currentUser;
  AuthenticationServices _auth = locator.get<AuthenticationServices>();
  StorageService _storageService = locator.get<StorageService>();
  final CollectionReference _coinsCollectionReference =
      Firestore.instance.collection('users');
  Future init;
  Future<User> initUser() async {
    _currentUser = await _auth.getCurrentUser();
    return _currentUser;
  }

  UserController() {
    print("i am being initialized");
    init = initUser();
  }
  User get currentuser => _currentUser;

  Future<void> uploadProfilePicture(File image) async {
    _currentUser.imageURL =
        await locator.get<StorageService>().uploadProfile(image);
  }

  Future<String> downloadurl() async {
    return await _storageService.getUserProfileImage(currentuser.UserId);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    _currentUser = await _auth.signIn(email, password);
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(_currentUser.UserId)
        .get();
    //_currentUser.imageURL = await downloadurl();
    _currentUser.coins = variable.data['rewards'];
    _currentUser.isAdmin = variable.data['isAdmin'];
  }

  Future<void> signUp(
      String email, String password, String name, bool isAdmin) async {
    String usid = await _auth.signUp(email, password, name);
    await _coinsCollectionReference
        .document(usid)
        .setData({"rewards": 0, "isAdmin": isAdmin,"likedNum":0});
    _currentUser.isAdmin = isAdmin;
  }

  void updateName(String newName) {
    _currentUser.name = newName;
    _auth.updateName(newName);
  }

  Future<void> updateCoins(int changes) async {
    User currentUser = locator.get<UserController>().currentuser;
    var variable =
        Firestore.instance.collection('users').document(currentUser.UserId);
    variable.updateData({"rewards": FieldValue.increment(changes)});
    currentUser.coins = currentUser.coins + changes;
  }

  Future<void> updateOtherUserCoins(String userID, int changes) async {
    var variable = Firestore.instance.collection('users').document(userID);
    variable.updateData({"rewards": FieldValue.increment(changes)});
  }

  Future<int> getCoins() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(_currentUser.UserId)
        .get();
    return variable.data['rewards'];
  }

    Future<int> getLikedNumber() async {
    DocumentSnapshot variable = await Firestore.instance
        .collection('users')
        .document(_currentUser.UserId)
        .get();
    return variable.data['likedNum'];
  }

  Stream<DocumentSnapshot> get userSnapshot {
    User currentUser = locator.get<UserController>().currentuser;
    return _coinsCollectionReference.document(currentUser.UserId).snapshots();
  }
}
