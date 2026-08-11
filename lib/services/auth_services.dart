import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //------------------------------------------Creating a new user----------------------------------------------

  static Future createUser({
    required String email,
    required String password,
    required String username,
    required String profileImage,
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
        'profileImage': profileImage,
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

  static Future loginUser({
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
        return 'Wrong password provided.';
      } else {
        return 'Account does not exist!!!';
      }
    } catch (e) {
      return 'Unexpected error';
    }
  }

  //--------------------------------------------Logout user-------------------------------------------------------

  static Future logOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return 'success';
    } catch (e) {
      return e.toString();
    }
  }

  //----------------------------------------------Delete user------------------------------------------------------

  static Future deleteUser() async {
  try {
    final User? currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      return 'There is no user to delete.';
    }

    final uid = currentUser.uid;
    final firestore = FirebaseFirestore.instance;

    // Delete user's posts
    final myPosts = await firestore
        .collection('posts')
        .where('userId', isEqualTo: uid)
        .get();

    for (final post in myPosts.docs) {
      final comments = await post.reference
          .collection('comments')
          .get();

      for (final comment in comments.docs) {
        await comment.reference.delete();
      }

      await post.reference.delete();
    }

    // Remove user's comments from other posts
    final allPosts = await firestore.collection('posts').get();

    for (final post in allPosts.docs) {
      final comments = await post.reference
          .collection('comments')
          .where('userId', isEqualTo: uid)
          .get();

      for (final comment in comments.docs) {
        await comment.reference.delete();
      }

      // Remove user's likes
      await post.reference.update({
        'likedBy': FieldValue.arrayRemove([uid]),
        'likesCount': FieldValue.increment(
          post.data()['likedBy']?.contains(uid) == true ? -1 : 0,
        ),
      });
    }

    // Delete user document
    await firestore.collection('users').doc(uid).delete();

    // Delete Firebase Authentication account
    await currentUser.delete();

    return 'success';
  } catch (e) {
    print('DELETE USER ERROR: $e');
    return 'Unexpected error';
  }
}

  //----------------------------------------------Reset Password------------------------------------------------------

  static Future resetPassword({
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