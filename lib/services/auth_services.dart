import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //------------------------------------------Creating a new user----------------------------------------------

  static Future<String> createUser({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'username': username,
        'email': email,
        'profileImage': '',
      });

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
      print('FIRESTORE ERROR: $e');
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
        return 'Wrong password provided.';
      } else if (e.code == 'invalid-credential') {
        return 'Invalid email or password.';
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

  //----------------------------------------------Reset Password------------------------------------------------------
  static Future<String> resetPassword({
    required String email,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(
        email: email,
      );

      return 'success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        return 'Please enter a valid email address.';
      } else {
        return 'Unable to send password reset email.';
      }
    } catch (e) {
      return 'Unexpected error';
    }
  }
}
