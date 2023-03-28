import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //Register
  static Future<int> registerUser(String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 1;
    } on FirebaseAuthException catch (e) {
      print("FAILED.");
      print(e.code);

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return 2;
    } catch (e) {
      print(e);
    }
    return 0;
  }

  //Login
  static Future<int> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return 0;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
