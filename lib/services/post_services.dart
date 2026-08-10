import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sprints_firstapp/models/post_model.dart';
import 'package:sprints_firstapp/models/comment_model.dart';

class PostServices {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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

      final userSnapshot = await _firestore.collection('users').doc(uid).get();

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

        // Likes
        'likesCount': 0,
        'likedBy': [],

        // Comments
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

  // ---------------- Like / Unlike Post ----------------

  static Future<String> likePost(String postId) async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return 'No user is currently logged in.';
      }

      final uid = currentUser.uid;

      final postRef = _firestore.collection('posts').doc(postId);

      final postSnapshot = await postRef.get();

      if (!postSnapshot.exists) {
        return 'Post not found.';
      }

      final data = postSnapshot.data()!;

      final List likedBy = List.from(data['likedBy'] ?? []);

      if (likedBy.contains(uid)) {
        // Unlike
        await postRef.update({
          'likedBy': FieldValue.arrayRemove([uid]),
          'likesCount': FieldValue.increment(-1),
        });
      } else {
        // Like
        await postRef.update({
          'likedBy': FieldValue.arrayUnion([uid]),
          'likesCount': FieldValue.increment(1),
        });
      }

      return 'success';
    } catch (e) {
      print('LIKE POST ERROR: $e');
      return 'Unexpected error';
    }
  }
  // ---------------- Add Comment ----------------

  static Future<String> addComment({
    required String postId,
    required String text,
  }) async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return 'No user is currently logged in.';
      }

      final uid = currentUser.uid;

      final userSnapshot = await _firestore.collection('users').doc(uid).get();

      if (!userSnapshot.exists) {
        return 'User profile not found.';
      }

      final userData = userSnapshot.data()!;

      final username = userData['username'] ?? 'Username';

      final commentsRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments');

      await commentsRef.add({
        'userId': uid,
        'username': username,
        'text': text,
        'createdAt': Timestamp.now(),
      });

      await _firestore.collection('posts').doc(postId).update({
        'commentsCount': FieldValue.increment(1),
      });

      return 'success';
    } catch (e) {
      print('ADD COMMENT ERROR: $e');
      return 'Unexpected error';
    }
  }

  // ---------------- Get Comments ----------------

  static Stream<List<Comment>> getComments(String postId) {
    return _firestore
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs
                .map(
                  (document) => Comment.fromFirestore(document),
                )
                .toList();
          },
        );
  }
}
