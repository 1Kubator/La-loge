import 'package:firebase_auth/firebase_auth.dart';
import 'package:la_loge/error_handling/network_exception.dart';

class FirebaseAuthentication {
  static Future<UserCredential> login(String email, String password) async {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .catchError((err) {
      throwNetworkException(err);
    });
  }

  static Future<UserCredential> register(String email, String password) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> resetPassword(String email) {
    return FirebaseAuth.instance
        .sendPasswordResetEmail(email: email)
        .catchError((err) {
      throwNetworkException(err);
    });
  }

  static Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }
}
