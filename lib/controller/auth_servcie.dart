import 'package:cz2006/models/User.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // registration with email and password
  Future<bool> isEmailVerified() async {
    var user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  Future<User> getCurrentUser() async {
    var firebaseUser = await _auth.currentUser();
    return User(firebaseUser?.uid, name: firebaseUser?.displayName);
  }

  Future<void> sendEmailVerification() async {
    var user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User> signIn(String email, String password) async {
    var authResult = (await _auth.signInWithEmailAndPassword(
        email: email, password: password));
    return User(authResult.user.uid, name: authResult.user.displayName);
  }

  Future<String> signUp(String email, String password, String name) async {
    var user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    var userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await user.updateProfile(userUpdateInfo);
    print("display name is");
    print(user.displayName);
    await user.sendEmailVerification();
    user.reload();

    return user.uid;
  }

  Future signOut() {
    return _auth.signOut();
  }

  Future<void> updateName(String newName) async {
    var user = await _auth.currentUser();
    user.updateProfile(
      UserUpdateInfo()..displayName = newName,
    );
  }
}
