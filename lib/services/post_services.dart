import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprints_firstapp/models/post_model.dart';

class PostServices {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static final FirebaseAuth _firebaseAuth =
      FirebaseAuth.instance;

  // ---------------- Create Post ----------------

  static Future<String> createPost({
    required String title,
    required String description,
    required String imageUrl,
  }) async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return 'No user is currently logged in.';
      }

      final uid = currentUser.uid;

      final userSnapshot =
          await _firestore.collection('users').doc(uid).get();

      if (!userSnapshot.exists) {
        return 'User profile not found.';
      }

      final userData = userSnapshot.data()!;

      final username = userData['username'] ?? 'Username';

      await _firestore.collection('posts').add({
        'userId': uid,
        'username': username,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
        'likesCount': 0,
        'commentsCount': 0,
      });

      return 'success';
    } catch (e) {
      print('CREATE POST ERROR: $e');
      return 'Unexpected error';
    }
  }

  // ---------------- Get Posts ----------------

  static Stream<List<Post>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (document) => Post.fromFirestore(document),
                )
                .toList();
          },
        );
  }
}