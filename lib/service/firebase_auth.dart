import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_loge/utils/network_exception.dart';

class FirebaseAuthentication {
  static final _firebaseAuth = FirebaseAuth.instance;

  static Future<UserCredential> login(String email, String password) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).catchError((err){throwNetworkException(err);});
  }

  static Future<UserCredential> register(String email, String password) {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
