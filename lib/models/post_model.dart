import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String userId;
  final String username;
  final String title;
  final String description;
  final String imageUrl;
  final Timestamp createdAt;
  final int likesCount;
  final int commentsCount;

  Post({
    required this.postId,
    required this.userId,
    required this.username,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
  });

  factory Post.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return Post(
      postId: document.id,
      userId: data['userId'],
      username: data['username'],
      title: data['title'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      createdAt: data['createdAt'],
      likesCount: data['likesCount'],
      commentsCount: data['commentsCount'],
    );
  }
}