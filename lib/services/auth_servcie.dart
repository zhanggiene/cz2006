import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // registration with email and password
  Future<bool> isEmailVerified() async {
    var user = await _auth.currentUser();
    return user.isEmailVerified;
  }

  Future createNewUser(String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      user.sendEmailVerification();
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> getCurrentUID() async {
    String uid = (await _auth.currentUser()).uid;
    return uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  Future<void> sendEmailVerification() async {
    var user = await _auth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<String> signIn(String email, String password) async {
    var user = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    var user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future signOut() {
    return _auth.signOut();
  }
}
