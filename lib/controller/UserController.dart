import 'dart:io';

import 'package:cz2006/controller/StorageRepo.dart';
import 'package:cz2006/controller/auth_servcie.dart';
import 'package:cz2006/models/User.dart';

import '../locator.dart';

class UserController {
  User _currentUser;
  AuthenticationServices _auth = locator.get<AuthenticationServices>();
  StorageService _storageService = locator.get<StorageService>();
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
    //_currentUser.imageURL = await downloadurl();
    print("name is ");
    print(_currentUser.name);
  }

  void updateName(String newName) {
    _currentUser.name = newName;
    _auth.updateName(newName);
  }
}
