import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> singIn(String email, String password);

  Future<String> singUp(String enail, String password);

  Future<void> singOut();

  Future<FirebaseUser> getCurrentUser();
}

class Auth extends BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<String> singIn(String email, String password) async {
    var result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;
    return user.uid;
  }

  @override
  Future<void> singOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<String> singUp(String enail, String password) async {
    var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: enail, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }
}
