import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //------------------------------------------Creating a new user----------------------------------------------

  static Future<String> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return 'Unexpected error';
      }
    } catch (e) {
      return 'Oops! there was an error creating the account!!!';
    }
  }
  //----------------------------------------Login user-----------------------------------------------------------

  static Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return 'Account does not exist!!!';
      }
    } catch (e) {
      return 'Unexpected error';
    }
  }

  //--------------------------------------------Logout user-------------------------------------------------------

  static Future<String> logOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return 'success';
    } catch (e) {
      return (e.toString());
    }
  }

  //----------------------------------------------Delete user------------------------------------------------------

  static Future<String> deleteUser() async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
        return 'success';
      } else {
        return 'There is no user to delete.';
      }
    } catch (e) {
      return 'unexpected error';
    }
  }
}
