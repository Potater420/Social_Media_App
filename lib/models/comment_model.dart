import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String userId;
  final String username;
  final String text;
  final Timestamp createdAt;

  Comment({
    required this.commentId,
    required this.userId,
    required this.username,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;

    return Comment(
      commentId: document.id,
      userId: data['userId'],
      username: data['username'],
      text: data['text'],
      createdAt: data['createdAt'],
    );
  }
}